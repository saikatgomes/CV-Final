function [ ] = stratifiedOffWithDef()

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
        

% featureSet={'features_hog_overlay_16' 'features_hog_hm_16' 'features_hog_hm_overlay_16' ...
%             'features_hog_overlay_8' 'features_hog_hm_8' 'features_hog_hm_overlay_8' ...
%             };       
       

% featureSet={'features_hog_overlay_128' 'features_hog_overlay_64' 'features_hog_overlay_32' };   

% featureSet={'features_hog_hm_128' 'features_hog_hm_64' 'features_hog_hm_32' 'features_hog_hm_16' 'features_hog_hm_8' }; 
featureSet={'features_hog_hm_32'}; 

trainSetSize=[10 25 50 75];
trainSetNum=[1 2 3 4];
numOfIter=5;

for f=1:length(featureSet)
    for t=trainSetNum
        for k=1:numOfIter
            display(strcat(featureSet{f},'-',num2str(trainSetSize(t)),'-',num2str(k)));                  
            inputFileName=strcat(resultsDir,'ML_input_st_',featureSet{f},'_',num2str(trainSetSize(t)),'-',num2str(k),'.mat');    
            resultsFileName=strcat(resultsDir,'ML_results_st_',featureSet{f},'_',num2str(trainSetSize(t)),'-',num2str(k),'.mat');           
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
                    
                    if(i==1)
                        t_val=[10 25 49 74];
                    elseif(i==2)
                        t_val=[8 20 40 60];
                    elseif(i==3)
                        t_val=[11 27 54 81];
                    elseif(i==4)
                        t_val=[11 28 56 84];
                    else
                        t_val=[10 25 51 76];
                    end
                    
                    trainLabel=[trainLabel sampleLabel(1,idx(1:t_val(t)))];
                    mySet=eval(featureSet{f});
                    trainFeatures=[trainFeatures; mySet(idx(1:t_val(t)),:)];
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
