function [ predictedLabels, accuracy, d_values, model ] = runSVM( trainFeatures, trainLabels, testFeatures, testLabels )

    addpath('../liblinear/matlab');
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Training model on LIBLINEAR'));        
%     model = train(trainLabels, trainFeatures, 's', 5);              
    model = train(trainLabels, trainFeatures, 's v q', [5 10]); 
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Predict on LIBLINEAR'));    
    [predictedLabels, accuracy, d_values] = predict(testLabels, testFeatures, model);
    rmpath('../liblinear/matlab');

end

