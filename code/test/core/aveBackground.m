D = vision.VideoFileReader('../data/packers_A/1.mp4');
c=1;
frame = D.step();
sum=double(zeros(size(frame,1),size(frame,2),3));
while ~isDone(D)
   frame = D.step();
   c=c+1;
   sum=sum+frame;
end
ave=sum/c;
%imshow(double(ave));
imwrite(double(ave),'../data/packers_A/1bg.jpg');