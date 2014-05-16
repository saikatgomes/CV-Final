%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Saikat R. Gomes
%% Email: saikat@cs.wisc.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ ] = classifyOffWithDef()

trainDir='../../../data/';
testDir='../../../data2/';
resultsDir=strcat('../../../FEATURES/');

% featureSet={'features_hog_overlay_128' 'features_hog_overlay_64' ...
%             'features_hog_hm_128' 'features_hog_hm_64'...
%             'features_hog_hm_overlay_128' 'features_hog_hm_overlay_64'  ...
%             };

% featureSet={'features_hog_overlay_32' ...
%             'features_hog_hm_32' ...
%             'features_hog_hm_overlay_32' ...
%             };       
        

featureSet={'features_hog_overlay_16' 'features_hog_hm_16' 'features_hog_hm_overlay_16' ...
            'features_hog_overlay_8' 'features_hog_hm_8' 'features_hog_hm_overlay_8' ...
            };       
        

trainSetSize=[10 25 50 75];
numOfIter=5;

for f=1:length(featureSet)
    for t=trainSetSize
        for k=1:numOfIter
            display(strcat(featureSet{f},'-',num2str(t),'-',num2str(k)));                  
            inputFileName=strcat(resultsDir,'ML_input_',featureSet{f},'_',num2str(t),'-',num2str(k),'.mat');    
            resultsFileName=strcat(resultsDir,'ML_results_',featureSet{f},'_',num2str(t),'-',num2str(k),'.mat');           
            if(exist(inputFileName,'file'))
                load(inputFileName);
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
                    clear sampleLabel mySet;
                    load(featureFile);    
                    
                    idx =randperm(length(sampleLabel));                    
                    trainLabel=[trainLabel sampleLabel(1,idx(1:t))];
                    mySet=eval(featureSet{f});
                    trainFeatures=[trainFeatures; mySet(idx(1:t),:)];
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
                    testFeatures=[testFeatures; eval(featureSet{f});];
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
            save(resultsFileName,'predictedLabels', 'accuracy', 'd_values', 'model', 'confMat', 'order' );
            save(inputFileName,'trainLabel', 'trainFeatures', 'testLabel', 'testFeatures' );
            display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Done!'));        
                        
        end
        
    end
end


end
