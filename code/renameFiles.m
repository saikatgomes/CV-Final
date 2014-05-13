function [ ] = renameFiles( mainDir )

d = dir(mainDir);
isub = [d(:).isdir];
fFir = {d(isub).name}';
fFir(ismember(fFir,{'.','..'})) = [];

for i=1:length(fFir)
    vFile=strcat(mainDir,fFir{i},'/new.mp4')
    cpFileName=strcat(mainDir,fFir{i},'.mp4')
    copyfile(vFile,cpFileName,'f');
end

end

