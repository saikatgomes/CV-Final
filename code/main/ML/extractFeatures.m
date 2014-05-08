function [ ] = extractFeatures( mainDir )

d = dir(mainDir);
isub = [d(:).isdir];
labelDir = {d(isub).name}';
labelDir(ismember(labelDir,{'.','..'})) = [];

for i=1:length(labelDir)
    sampleDir=strcat(mainDir,labelDir{i},'/');
    d_sub=dir(sampleDir);
    isub = [d_sub(:).isdir];
    instanceDir = {d_sub(isub).name}';
    instanceDir(ismember(instanceDir,{'.','..'})) = [];
    display(strcat('......................label:',labelDir{i},'...[',num2str(length(instanceDir)),']'));
    for j=1:length(instanceDir)
        base_dir=strcat(mainDir,labelDir{i},'/',instanceDir{j},'/');
        if(exist(strcat(base_dir,'/data/phase3_data.mat'),'file'))
            display(strcat('Processing...',base_dir));
            analyzeOne( base_dir );
        else
            display(strcat('###################### NO FEATURES.MAT in DATA DIR :',base_dir));
        end
    end
end

end

