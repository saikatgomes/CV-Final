function [ myresult,count ] = readResults()

    resultsDir=strcat('../../../FEATURES/');

%     featureSet={'features_hog_overlay_128' 'features_hog_overlay_64' ...
%                 'features_hog_hm_128' 'features_hog_hm_64'...
%                 'features_hog_hm_overlay_128' 'features_hog_hm_overlay_64'  ...
%                 };
%             
    featureSet={  'features_hog_overlay_8' 'features_hog_overlay_16' 'features_hog_overlay_32' 'features_hog_overlay_64' 'features_hog_overlay_128'...
         'features_hog_hm_8'  'features_hog_hm_16'  'features_hog_hm_32'  'features_hog_hm_64' 'features_hog_hm_128'...
        'features_hog_hm_overlay_8' 'features_hog_hm_overlay_16' 'features_hog_hm_overlay_32' 'features_hog_hm_overlay_64' 'features_hog_hm_overlay_128'...
        };
%    
%     featureSet={'features_hog_overlay_128' 'features_hog_overlay_64' 'features_hog_overlay_32' 'features_hog_overlay_16'  'features_hog_overlay_8' };
    trainSetSize=[10 25 50 75];
    numOfIter=5;

    count=0;
    for f=1:length(featureSet)
        for t=trainSetSize
            dispStr=strcat(featureSet{f},',',num2str(t));
            acc=0;
            for k=1:numOfIter                  
%                 resultsFileName=strcat(resultsDir,'ML_results_',featureSet{f},'_',num2str(t),'-',num2str(k),'.mat');    
                resultsFileName=strcat(resultsDir,'ML_results_st_',featureSet{f},'_',num2str(t),'-',num2str(k),'.mat');   
                if(exist(resultsFileName,'file'))
                    load(resultsFileName);
                    dispStr=strcat(dispStr,',',num2str(accuracy(1)));    
                    acc=acc+accuracy(1);
                    save(strcat(resultsDir,'ML_results_',featureSet{f},'_',num2str(t),'-',num2str(k),'__CONFMAT.mat'),'confMat');
                else
                    display(strcat('ERRROR.....',dispStr));
                end                                    
            end
            aveAcc=acc/numOfIter;
            dispStr=strcat(dispStr,',',num2str(aveAcc));
            display(dispStr);     
            count=count+1;
            myresult{count}=cellstr(dispStr);
        end
    end

    myresult=myresult';
end
