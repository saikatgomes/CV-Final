function [] = createFrames(img)
    obj.reader = vision.VideoFileReader(img);
    fcount=0;
    while ~isDone(obj.reader)
        fcount=fcount+1;
        frame = obj.reader.step();
        imwrite(frame,strcat('srgTest',num2str(fcount),'.jpg'));
    end
    
    
end
