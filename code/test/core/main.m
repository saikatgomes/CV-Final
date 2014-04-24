
fileName='../data/packer_multi_res/1a_big';
% fileName='../data/packers_lowTexture/1a_big';
% fileName='../data/packer_multi_res/1a_med';
% fileName='../data/packer_multi_res/1a_small';
minBlobArea=300;
% minBlobArea=125;
% minBlobArea=50;
ext='mp4';

%create player detector
playerDetector.reader = vision.VideoFileReader(strcat(fileName,'.',ext));
mkdir(strcat(fileName,'noBG/'));

playerDetector.videoPlayer = vision.VideoPlayer('Position', [20, 400, 700, 400]);
playerDetector.maskPlayer = vision.VideoPlayer('Position', [740, 400, 700, 400]);

playerDetector.detector = vision.ForegroundDetector('NumGaussians', 3, ...
    'NumTrainingFrames', 50, 'MinimumBackgroundRatio', 0.5);

playerDetector.blobAnalyser = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', true, 'CentroidOutputPort', true, ...
    'MinimumBlobArea', minBlobArea); %, 'MaximumBlobArea', 150

tracks = struct(...mask
    'id', {}, ...
    'bbox', {}, ...
    'kalmanFilter', {}, ...
    'age', {}, ...
    'totalVisibleCount', {}, ...
    'consecutiveInvisibleCount', {});