function [ ] = renameData( mainDir )

    d = dir(mainDir);
    isub = [d(:).isdir];
    labelDir = {d(isub).name}';
    labelDir(ismember(labelDir,{'.','..'})) = [];
    totalCount=0;

    for i=1:length(labelDir)
        subCount=0;
        sampleDir=strcat(mainDir,labelDir{i},'/');
        d_sub=dir(sampleDir);
        isub = [d_sub(:).isdir];
        instanceDir = {d_sub(isub).name}';
        instanceDir(ismember(instanceDir,{'.','..'})) = [];
        display(strcat('label:',labelDir{i},'...[',num2str(length(instanceDir)),']'));
        instCount=length(instanceDir);
        for j=1:instCount
            base_dir=strcat(mainDir,labelDir{i},'/',instanceDir{j},'/');
            if(exist(strcat(base_dir,'/data/feature_data.mat'),'file'))
% % % %                 totalCount=totalCount+1;
% % % %                 subCount=subCount+1;
% % % %                 new_dir=strcat(mainDir,labelDir{i},'/',labelDir{i},'_P_',...
% % % %                     num2str(subCount),'-',num2str(instCount),'--',...
% % % %                     num2str(totalCount),'-',datestr(now,'HHMMSS'),'/');
% % % %                 display(strcat('........Old:...',base_dir));
% % % %                 display(strcat('........New:...',new_dir));                
% % % %                 movefile(base_dir,new_dir,'f');
            else
                display(strcat('........ERROR:',base_dir)); %%%% error!!!!
            end
        end
    end

end
