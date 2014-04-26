    function [] = process( fileName, ext )
    warning('off','all');
    WRITE_NO_BG=1;
    MAKE_NO_BG_VID=1;
    dataDir=strcat(fileName,'_data/');
    minBlobArea=300;
    ext='mp4';
    delay=5;

    mkdir(dataDir);
    addBackground(fileName,ext,delay);

    if(WRITE_NO_BG==1)
        mkdir(strcat(dataDir,'/noBG/'));
    end

    if(MAKE_NO_BG_VID==1)
        outVid=VideoWriter(strcat(dataDir,'/noBGVid.',ext),'MPEG-4');
        inputVid=VideoReader(strcat(dataDir,'edited.',ext));
        outVid.FrameRate=inputVid.FrameRate;
        open(outVid);
    end

    playerDetector.reader = vision.VideoFileReader(strcat(dataDir,'edited.',ext));
    playerDetector.detector = vision.ForegroundDetector('NumGaussians', 3, ...
        'NumTrainingFrames', 50, 'MinimumBackgroundRatio', 0.7);
    playerDetector.blobAnalyser = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
        'AreaOutputPort', true, 'CentroidOutputPort', true, ...
        'MinimumBlobArea', minBlobArea); %, 'MaximumBlobArea', 150

    frameCount=0;
    
    while ~isDone(playerDetector.reader)

        frameCount=frameCount+1;
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] processing frame -> ',num2str(frameCount)));
        frame = playerDetector.reader.step();
        % Detect foreground.
        mask = playerDetector.detector.step(frame);

        % Apply morphological operations to remove noise and fill in holes.
        mask = imopen(mask, strel('rectangle', [3,3]));
        mask = imclose(mask, strel('rectangle', [15, 15]));
        mask = imfill(mask, 'holes');
        
        M=max(max(mask));
        if(M==0)
            display(strcat(datestr(now,'HH:MM:SS'),' [INFO] skipping frame -> ',num2str(frameCount)));
            continue;
        end
        
        %[~, centroids, bboxes] = playerDetector.blobAnalyser.step(mask);
        forMap(:,:,1)=double(frame(:,:,1).*mask);
        forMap(:,:,2)=double(frame(:,:,2).*mask);
        forMap(:,:,3)=double(frame(:,:,3).*mask);
        
        if(WRITE_NO_BG==1 && frameCount>delay)
            imwrite(forMap,strcat(fileName,'_data/noBG/',num2str(frameCount-delay),'.jpg'));
        end

        if(MAKE_NO_BG_VID==1 && frameCount>delay)
            writeVideo(outVid,forMap);
        end
    end
    if(MAKE_NO_BG_VID==1)
        close(outVid);
    end
end

