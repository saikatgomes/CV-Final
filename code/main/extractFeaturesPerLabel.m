function [ ] = extractFeaturesPerLabel( sampleDir )

%     sampleDir='../../data/play1/';
    d_sub=dir(sampleDir);
    isub = [d_sub(:).isdir];
    instanceDir = {d_sub(isub).name}';
    instanceDir(ismember(instanceDir,{'.','..'})) = [];
    for j=1:length(instanceDir)
        base_dir=strcat(sampleDir,instanceDir{j},'/');
        if(exist(strcat(base_dir,'/data/phase3_data.mat'),'file'))
            display(strcat('Processing...',base_dir));
            analyzeOne( base_dir );
        else
            display(strcat('###################### NO FEATURES.MAT in DATA DIR :',base_dir));
        end
    end

end

