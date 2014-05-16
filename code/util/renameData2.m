%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Saikat R. Gomes
%% Email: saikat@cs.wisc.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ ] = renameData2( mainDir )

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
                cpyFile=strcat(base_dir,'data\*');
                newFile=strcat('U:\u.saikat-523968\raw\data\',labelDir{i},'b\',instanceDir{j},'\');
                if(exist(strcat(base_dir,'/original.mp4'),'file'))
                    cpyFile2=strcat(base_dir,'original.mp4');
                    newFile2=strcat('U:\u.saikat-523968\raw\samples\',labelDir{i},'b\',instanceDir{j},'.mp4');  
                    if(~exist(newFile2,'file'))                        
                        display(strcat('Copying: ',base_dir));
                        copyfile(cpyFile2,newFile2,'f');
                        mkdir(newFile);
                        copyfile(cpyFile,newFile,'f');
                    end
                else
                    display(strcat('........ERROR no original:',base_dir)); %%%% error!!!!
                end
            else
                display(strcat('........ERROR no feature:',base_dir)); %%%% error!!!!
            end
            
        end
    end

end
