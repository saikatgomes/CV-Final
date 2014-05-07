load('srgTestSet.mat');



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