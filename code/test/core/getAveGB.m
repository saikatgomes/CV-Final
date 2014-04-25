function [ bgImg ] = getAveGB(fName,ext,isWrite)

detector = vision.VideoFileReader(strcat(fName,'.',ext));
count=1;
frame = detector.step();
sum=double(zeros(size(frame,1),size(frame,2),3));

while ~isDone(detector)
    frame = detector.step();
    count=count+1;
    sum=sum+frame;
end

ave=sum/count;

bgImg=double(ave);
%imshow(bgImg);
if(isWrite==1)
    imwrite(bgImg,strcat(fName,'_data/BG.jpg'));
end

end

