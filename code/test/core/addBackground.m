function [  ] = addBackground( fName,ext )
    
bgImg=getAveGB(fName,ext,1);
inputVid=VideoReader(strcat(fName,'.',ext));
outVid=VideoWriter(strcat(fName,'_Processed.',ext));
outVid.FrameRate=inputVid.FrameRate;
open(outVid);

for i=1:50
   writeVideo(outVid,bgImg); 
end

close(outVid);

end

