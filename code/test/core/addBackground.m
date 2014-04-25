function [  ] = addBackground( fName,ext )

bgImgName=strcat(fName,'_BG.jpg');
processedVidName=strcat(fName,'_Processed.',ext);



if exist(processedVidName,'file')
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] ',processedVidName,' already exists.'));
else
    if exist(bgImgName,'file')
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] ',bgImgName,' already exists.'));
        bgImg=imread(bgImgName);
    else
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] extracting average background Image.'));
        bgImg=getAveGB(fName,ext,1);
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] ',bgImgName,' created.'));
    end
    
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] adding average background to video.'));
    inputVid=VideoReader(strcat(fName,'.',ext));
    outVid=VideoWriter(strcat(fName,'_Processed.',ext),'MPEG-4');
    outVid.FrameRate=inputVid.FrameRate;
    open(outVid);
    
    for i=1:50
        writeVideo(outVid,bgImg);
    end
    
    numFrames = get(inputVid, 'NumberOfFrames');
    for i=1:numFrames
        img=read(inputVid,i);
        writeVideo(outVid,img);
    end
    
    close(outVid);
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] ',processedVidName,' created.'));
end
end

