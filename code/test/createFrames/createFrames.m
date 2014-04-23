function [] = createFrames(vName,ext)
    obj.reader = vision.VideoFileReader(strcat(vName,'.',ext));
    fcount=0;
    mkdir(vName);
    while ~isDone(obj.reader)
        fcount=fcount+1;
        frame = obj.reader.step();
        imwrite(frame,strcat(vName,'/',num2str(fcount),'.jpg'));
    end    
end
