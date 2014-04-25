function [] = process( fileName, ext )
warning('off','all');
WRITE_NO_BG=1;
MAKE_NO_BG_VID=1;
dataDir=strcat(fileName,'_data/');
minBlobArea=300;
ext='mp4';
delay=5;

mkdir(dataDir);
mkdir(strcat(dataDir,'/noBG/'));
addBackground(fileName,ext,delay);

if(MAKE_NO_BG_VID==1)
    outVid=VideoWriter(strcat(dataDir,'/noBGVid.',ext),'MPEG-4');
    inputVid=VideoReader(strcat(dataDir,'edited.',ext));
    outVid.FrameRate=inputVid.FrameRate;
    open(outVid);
end

playerDetector.reader = vision.VideoFileReader(strcat(dataDir,'edited.',ext));
playerDetector.detector = vision.ForegroundDetector('NumGaussians', 3, ...
    'NumTrainingFrames', 50, 'MinimumBackgroundRatio', 0.7);

while ~isDone(playerDetector.reader)
    
    frameCount=frameCount+1;
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] processing frame -> ',num2str(frameCount)));
    
    frame = playerDetector.reader.step();
end

