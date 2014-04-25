function [] = createFramesBatch()

ext='mp4';
fileList{1}='../data/colts_A/1';
fileList{2}='../data/colts_A/2';
fileList{3}='../data/colts_A/3';
fileList{4}='../data/colts_A/2';
fileList{5}='../data/packers_A/1';
fileList{6}='../data/packers_A/2';
fileList{7}='../data/packers_A/3';

for i=1:length(fileList)
    vName= fileList{i};
    display(vName);
    obj.reader = vision.VideoFileReader(strcat(vName,'.',ext));
    fcount=0;
    mkdir(vName);
    while ~isDone(obj.reader)
        fcount=fcount+1;
        frame = obj.reader.step();
        imwrite(frame,strcat(vName,'/',num2str(fcount),'.jpg'));
    end    
end

end
