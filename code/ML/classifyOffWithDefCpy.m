%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Saikat R. Gomes
%% Email: saikat@cs.wisc.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ ] = classifyOffWithDef()

trainDir='../../../data/';
testDir='../../../data2/';
resultsDir=strcat('../../../FEATURES/');

featureSet={'features_hog_overlay_128' 'features_hog_overlay_64' 'features_hog_overlay_32' ...
            'features_hog_hm_128' 'features_hog_hm_64' 'features_hog_hm_32' ...
            'features_hog_hm_overlay_128' 'features_hm_hog_overlay_64' 'features_hog_hm_overlay_32' ...
            };
        
        
trainSetSize=[10 25 50 100 200]

if(exist(strcat(resultsDir,'ML_input.mat'),'file'))
    load(strcat(resultsDir,'ML_input.mat'));
else    

    trainLabel=[];
    testLabel=[];
    trainFeatures=[];
    testFeatures=[];
    
    d = dir(trainDir);
    isub = [d(:).isdir];
    labelDir = {d(isub).name}';
    labelDir(ismember(labelDir,{'.','..','FEATURES'})) = [];
    numOfLabels=length(labelDir);
    for i=1:numOfLabels
        featureFile=strcat(trainDir,labelDir{i},'/FEATURES/all_feature_data.mat');
        if(~exist(featureFile,'file'))
            display(strcat(datestr(now,'HH:MM:SS'),' [ERROR] feature file MISSING!!! ___ ',featureFile));
            return;
        end
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Loading ___ ',featureFile));
        clear sampleLabel features_hog_hm_128;
        load(featureFile);    
        trainLabel=[trainLabel sampleLabel];
%         trainFeatures=[trainFeatures; features_hog_hm_128];
        trainFeatures=[trainFeatures; features_hog_overlay_64];
    end

    d = dir(testDir);
    isub = [d(:).isdir];
    labelDir = {d(isub).name}';
    labelDir(ismember(labelDir,{'.','..','FEATURES'})) = [];
    numOfLabels=length(labelDir);
    for i=1:numOfLabels
        featureFile=strcat(testDir,labelDir{i},'/FEATURES/all_feature_data.mat');
        if(~exist(featureFile,'file'))
            display(strcat(datestr(now,'HH:MM:SS'),' [ERROR] feature file MISSING!!! ___ ',featureFile));
            return;
        end
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Loading ___ ',featureFile));
        clear sampleLabel features_hog_hm_128;
        load(featureFile);
        testLabel=[testLabel sampleLabel];
%         testFeatures=[testFeatures; features_hog_hm_128];
        testFeatures=[testFeatures; features_hog_overlay_64];
    end
    trainLabel=double(trainLabel');
    trainFeatures=sparse(double(trainFeatures));
    testLabel=double(testLabel');
    testFeatures=sparse(double(testFeatures));
end

display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Running SVM for both off & def'));
[ predictedLabels, accuracy, d_values, model ] = runSVM( trainFeatures, trainLabel, testFeatures, testLabel );
[confMat,order] = confusionmat(testLabel,predictedLabels);
mkdir(resultsDir);
save(strcat(resultsDir,'ML_results.mat'),'predictedLabels', 'accuracy', 'd_values', 'model', 'confMat' );
save(strcat(resultsDir,'ML_input.mat'),'trainLabel', 'trainFeatures', 'testLabel', 'testFeatures' );
display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Done!'));


end
