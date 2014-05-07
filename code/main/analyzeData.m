function [ ] = analyzeData( mainDir )

    d = dir(mainDir);
    isub = [d(:).isdir];
    labelDir = {d(isub).name}';
    labelDir(ismember(labelDir,{'.','..'})) = [];
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
                if(j<11)
                    trainCount=trainCount+1;
                    trainFeatures(trainCount,:)=hog_hm_64;
                    trainLabel(trainCount)=i;
                else
                    testCount=testCount+1;
                    testFeatures(testCount,:)=hog_hm_64;
                    testLabel(testCount)=i;
                end

            else
                display(strcat('........Instance [NOOOOOO]:',base_dir)); %%%% error!!!!
            end
        end



    end
    

    trainLblVector=double(trainLabel');
    trainfeatureVector=sparse(double(trainFeatures));
    testLblVector=double(testLabel');



    testfeatureVector=sparse(double(testFeatures));


%     addpath('../../../../public/html/Sp13/cs766/P3-LLC/liblinear/matlab');
    addpath('liblinear/matlab');
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Training model on LIBLINEAR'));        
    model = train(trainLblVector, trainfeatureVector);        
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Predict on LIBLINEAR'));    
    [predictLblVector1, accuracy, decision_values] = predict(testLblVector, testfeatureVector, model);
    rmpath('liblinear/matlab');
    

end
