function [ ] = consolidateData( mainDir )

    d = dir(mainDir);
    isub = [d(:).isdir];
    labelDir = {d(isub).name}';
    labelDir(ismember(labelDir,{'.','..','FEATURES'})) = [];
    numOfLabels=length(labelDir);
    for i=1:numOfLabels
        sampleDir=strcat(mainDir,labelDir{i},'/');
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Consolidating ... ',sampleDir));
        d_sub=dir(sampleDir);
        isub = [d_sub(:).isdir];
        instanceDir = {d_sub(isub).name}';
        instanceDir(ismember(instanceDir,{'.','..','FEATURES'})) = [];
        display(strcat('label:',labelDir{i},'...[',num2str(length(instanceDir)),']'));
        instCount=length(instanceDir);
        totalCount=0;
        
        clear features_hog_hm_128 features_hog_hm_64 features_hog_hm_32 features_hog_hm_16 features_hog_hm_8;
        clear features_hog_hm_overlay_128 features_hog_hm_overlay_64 features_hog_hm_overlay_32 features_hog_hm_overlay_16 features_hog_hm_overlay_8
        clear features_hog_overlay_128 features_hog_overlay_64 features_hog_overlay_32 features_hog_overlay_16 features_hog_overlay_8;
        clear sampleLabel;
        
        for j=1:instCount
            base_dir=strcat(mainDir,labelDir{i},'/',instanceDir{j},'/');
            featureFile=strcat(base_dir,'data/feature_data.mat');           
            if(exist(featureFile,'file'))
                load(featureFile);
                totalCount=totalCount+1;
                features_hog_hm_128(totalCount,:)=hog_hm_128;
                features_hog_hm_64(totalCount,:)=hog_hm_64;
                features_hog_hm_32(totalCount,:)=hog_hm_32;
                features_hog_hm_16(totalCount,:)=hog_hm_16;
                features_hog_hm_8(totalCount,:)=hog_hm_8;
                features_hog_hm_overlay_128(totalCount,:)=hog_hm_overlay_128;
                features_hog_hm_overlay_64(totalCount,:)=hog_hm_overlay_64;
                features_hog_hm_overlay_32(totalCount,:)=hog_hm_overlay_32;
                features_hog_hm_overlay_16(totalCount,:)=hog_hm_overlay_16;
                features_hog_hm_overlay_8(totalCount,:)=hog_hm_overlay_8;
                features_hog_overlay_128(totalCount,:)=hog_overlay_128;
                features_hog_overlay_64(totalCount,:)=hog_overlay_64;
                features_hog_overlay_32(totalCount,:)=hog_overlay_32;
                features_hog_overlay_16(totalCount,:)=hog_overlay_16;
                features_hog_overlay_8(totalCount,:)=hog_overlay_8;
                sampleLabel(totalCount)=i;              
            else
                display(strcat('........Instance [NOOOOOO]:',base_dir)); %%%% error!!!!
            end
        end
        featuresDir=strcat(sampleDir,'FEATURES/');
        mkdir(featuresDir);
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Saving features at ... ',featuresDir));
        save(strcat(featuresDir,'all_feature_data.mat'),...
                                'features_hog_hm_128',...
                                'features_hog_hm_64',...
                                'features_hog_hm_32',...
                                'features_hog_hm_16',...
                                'features_hog_hm_8',...
                                'features_hog_hm_overlay_128',...
                                'features_hog_hm_overlay_64',...
                                'features_hog_hm_overlay_32',...
                                'features_hog_hm_overlay_16',...
                                'features_hog_hm_overlay_8',...
                                'features_hog_overlay_128',...
                                'features_hog_overlay_64',...
                                'features_hog_overlay_32',...
                                'features_hog_overlay_16',...
                                'features_hog_overlay_8',...
                                        'sampleLabel'...
                                        );                                    
                                    
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Done ... ',sampleDir));
    end
end
