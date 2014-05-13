function [ ] = classify( mainDir ,trainNum)

    hm_128=0;
    hm_64=0;
    hm_32=0;
    hm_16=0;
    hm_8=1;
    
    hm_overlay_128=0;
    hm_overlay_64=0;
    hm_overlay_32=0;
    hm_overlay_16=0;
    hm_overlay_8=1;
    
    overlay_128=0;
    overlay_64=0;
    overlay_32=0;
    overlay_16=0;
    overlay_8=1;

    d = dir(mainDir);
    isub = [d(:).isdir];
    labelDir = {d(isub).name}';
    labelDir(ismember(labelDir,{'.','..','FEATURES'})) = [];
    numOfLabels=length(labelDir);

    trainLabel_hm_128=[];
    testLabel_hm_128=[];
    trainFeatures_hm_128=[];
    testFeatures_hm_128=[];    

    trainLabel_hm_64=[];
    testLabel_hm_64=[];
    trainFeatures_hm_64=[];
    testFeatures_hm_64=[];    

    trainLabel_hm_32=[];
    testLabel_hm_32=[];
    trainFeatures_hm_32=[];
    testFeatures_hm_32=[];    

    trainLabel_hm_16=[];
    testLabel_hm_16=[];
    trainFeatures_hm_16=[];
    testFeatures_hm_16=[];    

    trainLabel_hm_8=[];
    testLabel_hm_8=[];
    trainFeatures_hm_8=[];
    testFeatures_hm_8=[];
    

    trainLabel_hm_overlay_128=[];
    testLabel_hm_overlay_128=[];
    trainFeatures_hm_overlay_128=[];
    testFeatures_hm_overlay_128=[];    

    trainLabel_hm_overlay_64=[];
    testLabel_hm_overlay_64=[];
    trainFeatures_hm_overlay_64=[];
    testFeatures_hm_overlay_64=[];    

    trainLabel_hm_overlay_32=[];
    testLabel_hm_overlay_32=[];
    trainFeatures_hm_overlay_32=[];
    testFeatures_hm_overlay_32=[];    

    trainLabel_hm_overlay_16=[];
    testLabel_hm_overlay_16=[];
    trainFeatures_hm_overlay_16=[];
    testFeatures_hm_overlay_16=[];    

    trainLabel_hm_overlay_8=[];
    testLabel_hm_overlay_8=[];
    trainFeatures_hm_overlay_8=[];
    testFeatures_hm_overlay_8=[];
    
    

    trainLabel_overlay_128=[];
    testLabel_overlay_128=[];
    trainFeatures_overlay_128=[];
    testFeatures_overlay_128=[];    

    trainLabel_overlay_64=[];
    testLabel_overlay_64=[];
    trainFeatures_overlay_64=[];
    testFeatures_overlay_64=[];    

    trainLabel_overlay_32=[];
    testLabel_overlay_32=[];
    trainFeatures_overlay_32=[];
    testFeatures_overlay_32=[];    

    trainLabel_overlay_16=[];
    testLabel_overlay_16=[];
    trainFeatures_overlay_16=[];
    testFeatures_overlay_16=[];    

    trainLabel_overlay_8=[];
    testLabel_overlay_8=[];
    trainFeatures_overlay_8=[];
    testFeatures_overlay_8=[];
    
    for i=1:numOfLabels
        featureFile=strcat(mainDir,labelDir{i},'/FEATURES/all_feature_data.mat');
        if(~exist(featureFile,'file'))
            display(strcat(datestr(now,'HH:MM:SS'),' [ERROR] feature file MISSING!!! ___ ',featureFile));
            return;
        end
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Loading ___ ',featureFile));
        load(featureFile);
        
        if(hm_128==1)
            trainLabel_hm_128=[trainLabel_hm_128 sampleLabel(1:trainNum)];
            testLabel_hm_128=[testLabel_hm_128 sampleLabel(trainNum+1:end)];
            trainFeatures_hm_128=[trainFeatures_hm_128;features_hog_hm_128(1:trainNum,:)];
            testFeatures_hm_128=[testFeatures_hm_128;features_hog_hm_128(trainNum+1:end,:)];
        end
        
        if(hm_64==1)
            trainLabel_hm_64=[trainLabel_hm_64 sampleLabel(1:trainNum)];
            testLabel_hm_64=[testLabel_hm_64 sampleLabel(trainNum+1:end)];
            trainFeatures_hm_64=[trainFeatures_hm_64;features_hog_hm_64(1:trainNum,:)];
            testFeatures_hm_64=[testFeatures_hm_64;features_hog_hm_64(trainNum+1:end,:)];
        end
        
        if(hm_32==1)
            trainLabel_hm_32=[trainLabel_hm_32 sampleLabel(1:trainNum)];
            testLabel_hm_32=[testLabel_hm_32 sampleLabel(trainNum+1:end)];
            trainFeatures_hm_32=[trainFeatures_hm_32;features_hog_hm_32(1:trainNum,:)];
            testFeatures_hm_32=[testFeatures_hm_32;features_hog_hm_32(trainNum+1:end,:)];
        end
        
        if(hm_16==1)
            trainLabel_hm_16=[trainLabel_hm_16 sampleLabel(1:trainNum)];
            testLabel_hm_16=[testLabel_hm_16 sampleLabel(trainNum+1:end)];
            trainFeatures_hm_16=[trainFeatures_hm_16;features_hog_hm_16(1:trainNum,:)];
            testFeatures_hm_16=[testFeatures_hm_16;features_hog_hm_16(trainNum+1:end,:)];
        end
        
        if(hm_8==1)
            trainLabel_hm_8=[trainLabel_hm_8 sampleLabel(1:trainNum)];
            testLabel_hm_8=[testLabel_hm_8 sampleLabel(trainNum+1:end)];
            trainFeatures_hm_8=[trainFeatures_hm_8;features_hog_hm_8(1:trainNum,:)];
            testFeatures_hm_8=[testFeatures_hm_8;features_hog_hm_8(trainNum+1:end,:)];
        end
        
        if(hm_overlay_128==1)
            trainLabel_hm_overlay_128=[trainLabel_hm_overlay_128 sampleLabel(1:trainNum)];
            testLabel_hm_overlay_128=[testLabel_hm_overlay_128 sampleLabel(trainNum+1:end)];
            trainFeatures_hm_overlay_128=[trainFeatures_hm_overlay_128;features_hog_hm_overlay_128(1:trainNum,:)];
            testFeatures_hm_overlay_128=[testFeatures_hm_overlay_128;features_hog_hm_overlay_128(trainNum+1:end,:)];
        end
        
        if(hm_overlay_64==1)
            trainLabel_hm_overlay_64=[trainLabel_hm_overlay_64 sampleLabel(1:trainNum)];
            testLabel_hm_overlay_64=[testLabel_hm_overlay_64 sampleLabel(trainNum+1:end)];
            trainFeatures_hm_overlay_64=[trainFeatures_hm_overlay_64;features_hog_hm_overlay_64(1:trainNum,:)];
            testFeatures_hm_overlay_64=[testFeatures_hm_overlay_64;features_hog_hm_overlay_64(trainNum+1:end,:)];
        end
        
        if(hm_overlay_32==1)
            trainLabel_hm_overlay_32=[trainLabel_hm_overlay_32 sampleLabel(1:trainNum)];
            testLabel_hm_overlay_32=[testLabel_hm_overlay_32 sampleLabel(trainNum+1:end)];
            trainFeatures_hm_overlay_32=[trainFeatures_hm_overlay_32;features_hog_hm_overlay_32(1:trainNum,:)];
            testFeatures_hm_overlay_32=[testFeatures_hm_overlay_32;features_hog_hm_overlay_32(trainNum+1:end,:)];
        end
        
        if(hm_overlay_16==1)
            trainLabel_hm_overlay_16=[trainLabel_hm_overlay_16 sampleLabel(1:trainNum)];
            testLabel_hm_overlay_16=[testLabel_hm_overlay_16 sampleLabel(trainNum+1:end)];
            trainFeatures_hm_overlay_16=[trainFeatures_hm_overlay_16;features_hog_hm_overlay_16(1:trainNum,:)];
            testFeatures_hm_overlay_16=[testFeatures_hm_overlay_16;features_hog_hm_overlay_16(trainNum+1:end,:)];
        end
        
        if(hm_overlay_8==1)
            trainLabel_hm_overlay_8=[trainLabel_hm_overlay_8 sampleLabel(1:trainNum)];
            testLabel_hm_overlay_8=[testLabel_hm_overlay_8 sampleLabel(trainNum+1:end)];
            trainFeatures_hm_overlay_8=[trainFeatures_hm_overlay_8;features_hog_hm_overlay_8(1:trainNum,:)];
            testFeatures_hm_overlay_8=[testFeatures_hm_overlay_8;features_hog_hm_overlay_8(trainNum+1:end,:)];
        end
        
        if(overlay_128==1)
            trainLabel_overlay_128=[trainLabel_overlay_128 sampleLabel(1:trainNum)];
            testLabel_overlay_128=[testLabel_overlay_128 sampleLabel(trainNum+1:end)];
            trainFeatures_overlay_128=[trainFeatures_overlay_128;features_hog_overlay_128(1:trainNum,:)];
            testFeatures_overlay_128=[testFeatures_overlay_128;features_hog_overlay_128(trainNum+1:end,:)];
        end
        
        if(overlay_64==1)
            trainLabel_overlay_64=[trainLabel_overlay_64 sampleLabel(1:trainNum)];
            testLabel_overlay_64=[testLabel_overlay_64 sampleLabel(trainNum+1:end)];
            trainFeatures_overlay_64=[trainFeatures_overlay_64;features_hog_overlay_64(1:trainNum,:)];
            testFeatures_overlay_64=[testFeatures_overlay_64;features_hog_overlay_64(trainNum+1:end,:)];
        end
        
        if(overlay_32==1)
            trainLabel_overlay_32=[trainLabel_overlay_32 sampleLabel(1:trainNum)];
            testLabel_overlay_32=[testLabel_overlay_32 sampleLabel(trainNum+1:end)];
            trainFeatures_overlay_32=[trainFeatures_overlay_32;features_hog_overlay_32(1:trainNum,:)];
            testFeatures_overlay_32=[testFeatures_overlay_32;features_hog_overlay_32(trainNum+1:end,:)];
        end
        
        if(overlay_16==1)
            trainLabel_overlay_16=[trainLabel_overlay_16 sampleLabel(1:trainNum)];
            testLabel_overlay_16=[testLabel_overlay_16 sampleLabel(trainNum+1:end)];
            trainFeatures_overlay_16=[trainFeatures_overlay_16;features_hog_overlay_16(1:trainNum,:)];
            testFeatures_overlay_16=[testFeatures_overlay_16;features_hog_overlay_16(trainNum+1:end,:)];
        end
        
        if(overlay_8==1)
            trainLabel_overlay_8=[trainLabel_overlay_8 sampleLabel(1:trainNum)];
            testLabel_overlay_8=[testLabel_overlay_8 sampleLabel(trainNum+1:end)];
            trainFeatures_overlay_8=[trainFeatures_overlay_8;features_hog_overlay_8(1:trainNum,:)];
            testFeatures_overlay_8=[testFeatures_overlay_8;features_hog_overlay_8(trainNum+1:end,:)];
        end
                
    end

    if(hm_128==1)
        trainLabel_hm_128=double(trainLabel_hm_128');
        trainFeatures_hm_128=sparse(double(trainFeatures_hm_128));
        testLabel_hm_128=double(testLabel_hm_128');
        testFeatures_hm_128=sparse(double(testFeatures_hm_128));

        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Running SVM for HM 128'));
        [ predictedLabels_hm_128, accuracy_hm_128, d_values_hm_128, model_hm_128 ] = runSVM( trainFeatures_hm_128, trainLabel_hm_128, testFeatures_hm_128, testLabel_hm_128 );      
        resultsDir=strcat(mainDir,'/FEATURES/');        
        mkdir(resultsDir);
        save(strcat(resultsDir,'results_hm_128_',num2str(trainNum),'.mat'),'predictedLabels_hm_128', 'accuracy_hm_128', 'd_values_hm_128', 'model_hm_128' );
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Done!'));
    end
        
    if(hm_64==1)
        trainLabel_hm_64=double(trainLabel_hm_64');
        trainFeatures_hm_64=sparse(double(trainFeatures_hm_64));
        testLabel_hm_64=double(testLabel_hm_64');
        testFeatures_hm_64=sparse(double(testFeatures_hm_64));

        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Running SVM for HM 64'));
        [ predictedLabels_hm_64, accuracy_hm_64, d_values_hm_64, model_hm_64 ] = runSVM( trainFeatures_hm_64, trainLabel_hm_64, testFeatures_hm_64, testLabel_hm_64 );
        resultsDir=strcat(mainDir,'/FEATURES/');        
        mkdir(resultsDir);
        save(strcat(resultsDir,'results_hm_64_',num2str(trainNum),'.mat'),'predictedLabels_hm_64', 'accuracy_hm_64', 'd_values_hm_64', 'model_hm_64' );
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Done!'));
    end
    
    if(hm_32==1)
        trainLabel_hm_32=double(trainLabel_hm_32');
        trainFeatures_hm_32=sparse(double(trainFeatures_hm_32));
        testLabel_hm_32=double(testLabel_hm_32');
        testFeatures_hm_32=sparse(double(testFeatures_hm_32));

        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Running SVM for HM 32'));
        [ predictedLabels_hm_32, accuracy_hm_32, d_values_hm_32, model_hm_32 ] = runSVM( trainFeatures_hm_32, trainLabel_hm_32, testFeatures_hm_32, testLabel_hm_32 );
        resultsDir=strcat(mainDir,'/FEATURES/');        
        mkdir(resultsDir);
        save(strcat(resultsDir,'results_hm_32_',num2str(trainNum),'.mat'),'predictedLabels_hm_32', 'accuracy_hm_32', 'd_values_hm_32', 'model_hm_32' );
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Done!'));
    end
    
    if(hm_16==1)
        trainLabel_hm_16=double(trainLabel_hm_16');
        trainFeatures_hm_16=sparse(double(trainFeatures_hm_16));
        testLabel_hm_16=double(testLabel_hm_16');
        testFeatures_hm_16=sparse(double(testFeatures_hm_16));

        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Running SVM for HM 16'));
        [ predictedLabels_hm_16, accuracy_hm_16, d_values_hm_16, model_hm_16 ] = runSVM( trainFeatures_hm_16, trainLabel_hm_16, testFeatures_hm_16, testLabel_hm_16 );
        resultsDir=strcat(mainDir,'/FEATURES/');        
        mkdir(resultsDir);
        save(strcat(resultsDir,'results_hm_16_',num2str(trainNum),'.mat'),'predictedLabels_hm_16', 'accuracy_hm_16', 'd_values_hm_16', 'model_hm_16' );
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Done!'));
    end
    if(hm_8==1)
        trainLabel_hm_8=double(trainLabel_hm_8');
        trainFeatures_hm_8=sparse(double(trainFeatures_hm_8));
        testLabel_hm_8=double(testLabel_hm_8');
        testFeatures_hm_8=sparse(double(testFeatures_hm_8));

        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Running SVM for HM 8'));
        [ predictedLabels_hm_8, accuracy_hm_8, d_values_hm_8, model_hm_8 ] = runSVM( trainFeatures_hm_8, trainLabel_hm_8, testFeatures_hm_8, testLabel_hm_8 );
        resultsDir=strcat(mainDir,'/FEATURES/');        
        mkdir(resultsDir);
        save(strcat(resultsDir,'results_hm_8_',num2str(trainNum),'.mat'),'predictedLabels_hm_8', 'accuracy_hm_8', 'd_values_hm_8', 'model_hm_8' );
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Done!'));
    end
    if(hm_overlay_128==1)
        trainLabel_hm_overlay_128=double(trainLabel_hm_overlay_128');
        trainFeatures_hm_overlay_128=sparse(double(trainFeatures_hm_overlay_128));
        testLabel_hm_overlay_128=double(testLabel_hm_overlay_128');
        testFeatures_hm_overlay_128=sparse(double(testFeatures_hm_overlay_128));

        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Running SVM for HM OVERLAY 128'));
        [ predictedLabels_hm_overlay_128, accuracy_hm_overlay_128, d_values_hm_overlay_128, model_hm_overlay_128 ] = runSVM( trainFeatures_hm_overlay_128, trainLabel_hm_overlay_128, testFeatures_hm_overlay_128, testLabel_hm_overlay_128 );
        resultsDir=strcat(mainDir,'/FEATURES/');        
        mkdir(resultsDir);
        save(strcat(resultsDir,'results_hm_overlay_128_',num2str(trainNum),'.mat'),'predictedLabels_hm_overlay_128', 'accuracy_hm_overlay_128', 'd_values_hm_overlay_128', 'model_hm_overlay_128' );
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Done!'));
    end
    if(hm_overlay_64==1)
        trainLabel_hm_overlay_64=double(trainLabel_hm_overlay_64');
        trainFeatures_hm_overlay_64=sparse(double(trainFeatures_hm_overlay_64));
        testLabel_hm_overlay_64=double(testLabel_hm_overlay_64');
        testFeatures_hm_overlay_64=sparse(double(testFeatures_hm_overlay_64));

        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Running SVM for HM OVERLAY 64'));
        [ predictedLabels_hm_overlay_64, accuracy_hm_overlay_64, d_values_hm_overlay_64, model_hm_overlay_64 ] = runSVM( trainFeatures_hm_overlay_64, trainLabel_hm_overlay_64, testFeatures_hm_overlay_64, testLabel_hm_overlay_64 );
        resultsDir=strcat(mainDir,'/FEATURES/');        
        mkdir(resultsDir);
        save(strcat(resultsDir,'results_hm_overlay_64_',num2str(trainNum),'.mat'),'predictedLabels_hm_overlay_64', 'accuracy_hm_overlay_64', 'd_values_hm_overlay_64', 'model_hm_overlay_64' );
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Done!'));
    end
    if(hm_overlay_32==1)
        trainLabel_hm_overlay_32=double(trainLabel_hm_overlay_32');
        trainFeatures_hm_overlay_32=sparse(double(trainFeatures_hm_overlay_32));
        testLabel_hm_overlay_32=double(testLabel_hm_overlay_32');
        testFeatures_hm_overlay_32=sparse(double(testFeatures_hm_overlay_32));

        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Running SVM for HM OVERLAY 32'));
        [ predictedLabels_hm_overlay_32, accuracy_hm_overlay_32, d_values_hm_overlay_32, model_hm_overlay_32 ] = runSVM( trainFeatures_hm_overlay_32, trainLabel_hm_overlay_32, testFeatures_hm_overlay_32, testLabel_hm_overlay_32 );
        resultsDir=strcat(mainDir,'/FEATURES/');        
        mkdir(resultsDir);
        save(strcat(resultsDir,'results_hm_overlay_32_',num2str(trainNum),'.mat'),'predictedLabels_hm_overlay_32', 'accuracy_hm_overlay_32', 'd_values_hm_overlay_32', 'model_hm_overlay_32' );
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Done!'));
    end
    if(hm_overlay_16==1)
        trainLabel_hm_overlay_16=double(trainLabel_hm_overlay_16');
        trainFeatures_hm_overlay_16=sparse(double(trainFeatures_hm_overlay_16));
        testLabel_hm_overlay_16=double(testLabel_hm_overlay_16');
        testFeatures_hm_overlay_16=sparse(double(testFeatures_hm_overlay_16));

        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Running SVM for HM OVERLAY 16'));
        [ predictedLabels_hm_overlay_16, accuracy_hm_overlay_16, d_values_hm_overlay_16, model_hm_overlay_16 ] = runSVM( trainFeatures_hm_overlay_16, trainLabel_hm_overlay_16, testFeatures_hm_overlay_16, testLabel_hm_overlay_16 );
        resultsDir=strcat(mainDir,'/FEATURES/');        
        mkdir(resultsDir);
        save(strcat(resultsDir,'results_hm_overlay_16_',num2str(trainNum),'.mat'),'predictedLabels_hm_overlay_16', 'accuracy_hm_overlay_16', 'd_values_hm_overlay_16', 'model_hm_overlay_16' );
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Done!'));
    end
    if(hm_overlay_8==1)
        trainLabel_hm_overlay_8=double(trainLabel_hm_overlay_8');
        trainFeatures_hm_overlay_8=sparse(double(trainFeatures_hm_overlay_8));
        testLabel_hm_overlay_8=double(testLabel_hm_overlay_8');
        testFeatures_hm_overlay_8=sparse(double(testFeatures_hm_overlay_8));

        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Running SVM for HM OVERLAY 8'));
        [ predictedLabels_hm_overlay_8, accuracy_hm_overlay_8, d_values_hm_overlay_8, model_hm_overlay_8 ] = runSVM( trainFeatures_hm_overlay_8, trainLabel_hm_overlay_8, testFeatures_hm_overlay_8, testLabel_hm_overlay_8 );
        resultsDir=strcat(mainDir,'/FEATURES/');        
        mkdir(resultsDir);
        save(strcat(resultsDir,'results_hm_overlay_8_',num2str(trainNum),'.mat'),'predictedLabels_hm_overlay_8', 'accuracy_hm_overlay_8', 'd_values_hm_overlay_8', 'model_hm_overlay_8' );
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Done!'));
    end
    if(overlay_128==1)
        trainLabel_overlay_128=double(trainLabel_overlay_128');
        trainFeatures_overlay_128=sparse(double(trainFeatures_overlay_128));
        testLabel_overlay_128=double(testLabel_overlay_128');
        testFeatures_overlay_128=sparse(double(testFeatures_overlay_128));

        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Running SVM for OVERLAY 128'));
        [ predictedLabels_overlay_128, accuracy_overlay_128, d_values_overlay_128, model_overlay_128 ] = runSVM( trainFeatures_overlay_128, trainLabel_overlay_128, testFeatures_overlay_128, testLabel_overlay_128 );
        resultsDir=strcat(mainDir,'/FEATURES/');        
        mkdir(resultsDir);
        save(strcat(resultsDir,'results_overlay_128_',num2str(trainNum),'.mat'),'predictedLabels_overlay_128', 'accuracy_overlay_128', 'd_values_overlay_128', 'model_overlay_128' );
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Done!'));
    end
    if(overlay_64==1)
        trainLabel_overlay_64=double(trainLabel_overlay_64');
        trainFeatures_overlay_64=sparse(double(trainFeatures_overlay_64));
        testLabel_overlay_64=double(testLabel_overlay_64');
        testFeatures_overlay_64=sparse(double(testFeatures_overlay_64));

        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Running SVM for OVERLAY 64'));
        [ predictedLabels_overlay_64, accuracy_overlay_64, d_values_overlay_64, model_overlay_64 ] = runSVM( trainFeatures_overlay_64, trainLabel_overlay_64, testFeatures_overlay_64, testLabel_overlay_64 );
        resultsDir=strcat(mainDir,'/FEATURES/');        
        mkdir(resultsDir);
        save(strcat(resultsDir,'results_overlay_64_',num2str(trainNum),'.mat'),'predictedLabels_overlay_64', 'accuracy_overlay_64', 'd_values_overlay_64', 'model_overlay_64' );
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Done!'));
    end
    if(overlay_32==1)
        trainLabel_overlay_32=double(trainLabel_overlay_32');
        trainFeatures_overlay_32=sparse(double(trainFeatures_overlay_32));
        testLabel_overlay_32=double(testLabel_overlay_32');
        testFeatures_overlay_32=sparse(double(testFeatures_overlay_32));

        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Running SVM for OVERLAY 32'));
        [ predictedLabels_overlay_32, accuracy_overlay_32, d_values_overlay_32, model_overlay_32 ] = runSVM( trainFeatures_overlay_32, trainLabel_overlay_32, testFeatures_overlay_32, testLabel_overlay_32 );
        resultsDir=strcat(mainDir,'/FEATURES/');        
        mkdir(resultsDir);
        save(strcat(resultsDir,'results_overlay_32_',num2str(trainNum),'.mat'),'predictedLabels_overlay_32', 'accuracy_overlay_32', 'd_values_overlay_32', 'model_overlay_32' );
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Done!'));
    end
    if(overlay_16==1)
        trainLabel_overlay_16=double(trainLabel_overlay_16');
        trainFeatures_overlay_16=sparse(double(trainFeatures_overlay_16));
        testLabel_overlay_16=double(testLabel_overlay_16');
        testFeatures_overlay_16=sparse(double(testFeatures_overlay_16));

        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Running SVM for OVERLAY 16'));
        [ predictedLabels_overlay_16, accuracy_overlay_16, d_values_overlay_16, model_overlay_16 ] = runSVM( trainFeatures_overlay_16, trainLabel_overlay_16, testFeatures_overlay_16, testLabel_overlay_16 );
        resultsDir=strcat(mainDir,'/FEATURES/');        
        mkdir(resultsDir);
        save(strcat(resultsDir,'results_overlay_16_',num2str(trainNum),'.mat'),'predictedLabels_overlay_16', 'accuracy_overlay_16', 'd_values_overlay_16', 'model_overlay_16' );
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Done!'));
    end
    if(overlay_8==1)
        trainLabel_overlay_8=double(trainLabel_overlay_8');
        trainFeatures_overlay_8=sparse(double(trainFeatures_overlay_8));
        testLabel_overlay_8=double(testLabel_overlay_8');
        testFeatures_overlay_8=sparse(double(testFeatures_overlay_8));

        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Running SVM for OVERLAY 8'));
        [ predictedLabels_overlay_8, accuracy_overlay_8, d_values_overlay_8, model_overlay_8 ] = runSVM( trainFeatures_overlay_8, trainLabel_overlay_8, testFeatures_overlay_8, testLabel_overlay_8 );
        resultsDir=strcat(mainDir,'/FEATURES/');        
        mkdir(resultsDir);
        save(strcat(resultsDir,'results_overlay_8_',num2str(trainNum),'.mat'),'predictedLabels_overlay_8', 'accuracy_overlay_8', 'd_values_overlay_8', 'model_overlay_8' );
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Done!'));
    end

end
