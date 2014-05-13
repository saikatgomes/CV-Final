function [ ] = analyzeData( mainDir ,trainNum)

    d = dir(mainDir);
    isub = [d(:).isdir];
    labelDir = {d(isub).name}';
    labelDir(ismember(labelDir,{'.','..','FEATURES'})) = [];
    numOfLabels=length(labelDir);

    testCount=0;
    trainCount=0;
    totalCount=0;

    for i=1:numOfLabels
        sampleDir=strcat(mainDir,labelDir{i},'/');
        d_sub=dir(sampleDir);
        isub = [d_sub(:).isdir];
        instanceDir = {d_sub(isub).name}';
        instanceDir(ismember(instanceDir,{'.','..'})) = [];
        display(strcat('label:',labelDir{i},'...[',num2str(length(instanceDir)),']'));
        instCount=length(instanceDir);

        for j=1:instCount
            base_dir=strcat(mainDir,labelDir{i},'/',instanceDir{j},'/');
            featureFile=strcat(base_dir,'data/feature_data.mat');
            if(exist(featureFile,'file'))
                load(featureFile);
                if(j<trainNum)
                    trainCount=trainCount+1;
                    
                    trn_F_hog_overlay_64(trainCount,:)=hog_overlay_64;
                    trn_Lbl_hog_overlay_64(trainCount)=i;
                else
                    testCount=testCount+1;

                    tst_F_hog_overlay_64(testCount,:)=hog_overlay_64;
                    tst_Lbl_hog_overlay_64(testCount)=i;
                end

            else
                display(strcat('........Instance [NOOOOOO]:',base_dir)); %%%% error!!!!
            end
        end



    end
    

    trn_Lbl_hog_overlay_64=double(trn_Lbl_hog_overlay_64');
    trn_F_hog_overlay_64=sparse(double(trn_F_hog_overlay_64));
    tst_Lbl_hog_overlay_64=double(tst_Lbl_hog_overlay_64');
    tst_F_hog_overlay_64=sparse(double(tst_F_hog_overlay_64));

    addpath('liblinear/matlab');
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Training model on LIBLINEAR'));        
    model_hog_overlay_64 = train(trn_Lbl_hog_overlay_64, trn_F_hog_overlay_64);        
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Predict on LIBLINEAR'));    
    [predictLbl_hog_overlay_64, acc_hog_overlay_64, decision_values_hog_overlay_64] = predict(tst_Lbl_hog_overlay_64, tst_F_hog_overlay_64, model_hog_overlay_64);
    rmpath('liblinear/matlab');
    
      
%     save(strcat(mainDir,'FEATURES/features_hog_hm_128.mat'),'stuff');
%     save(strcat(mainDir,'FEATURES/features_hog_hm_64.mat'),'stuff');
%     save(strcat(mainDir,'FEATURES/features_hog_hm_32.mat'),'stuff');
%     save(strcat(mainDir,'FEATURES/features_hog_hm_16.mat'),'stuff');
%     save(strcat(mainDir,'FEATURES/features_hog_hm_8.mat'),'stuff');
%     save(strcat(mainDir,'FEATURES/features_hog_hm_overlay_128.mat'),'stuff');
%     save(strcat(mainDir,'FEATURES/features_hog_hm_overlay_64.mat'),'stuff');
%     save(strcat(mainDir,'FEATURES/features_hog_hm_overlay_32.mat'),'stuff');
%     save(strcat(mainDir,'FEATURES/features_hog_hm_overlay_16.mat'),'stuff');
%     save(strcat(mainDir,'FEATURES/features_hog_hm_overlay_8.mat'),'stuff');
%     save(strcat(mainDir,'FEATURES/features_hog_overlay_128.mat'),'stuff');
    save(strcat(mainDir,'FEATURES/features_hog_overlay_64.mat'),'stuff');
%     save(strcat(mainDir,'FEATURES/features_hog_overlay_32.mat'),'stuff');
%     save(strcat(mainDir,'FEATURES/features_hog_overlay_16.mat'),'stuff');
%     save(strcat(mainDir,'FEATURES/features_hog_overlay_8.mat'),'stuff');
    

end
