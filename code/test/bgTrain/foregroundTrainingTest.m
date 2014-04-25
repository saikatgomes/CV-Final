D = vision.ForegroundDetector('NumGaussians', 3, ...
    'NumTrainingFrames', 50);

videoReader = vision.VideoFileReader('../data/packers_A/1.mp4');
bgFrame=imread('bg1.jpg');
for i = 1:50
    %frame = step(videoReader); % read the next video frame
    
    mask = D.step(bgFrame);
    %foreground = step(foregroundDetector, frame);
end

for i=51:100
    frame = videoReader.step();
    mask = D.step(frame);
    forMap(:,:,1)=double(frame(:,:,1).*mask);
    forMap(:,:,2)=double(frame(:,:,2).*mask);
    forMap(:,:,3)=double(frame(:,:,3).*mask);
    imshow(forMap); 
end


figure; imshow(foreground);
