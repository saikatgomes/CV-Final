function [  ] = addBackground( fName,ext )

bgImg=getAveGB(fName,ext,1);
%vision.VideoFileReader(strcat(fileName,'.',ext));
inputVid=VideoReader(strcat(fName,'.',ext));
%inputVid=vision.VideoFileReader(strcat(fName,'.',ext));
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

end

