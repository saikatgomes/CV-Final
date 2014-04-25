
function main()
    warning('off','all');
    % fileName='../data/packers_lowTexture/1a_big';
    % fileName='../data/packer_multi_res/1a_med';
    % fileName='../data/packer_multi_res/1a_small';
    % minBlobArea=125;
    % minBlobArea=50;
    
    fileName='../data/packers_A/1';
    minBlobArea=300;
    ext='mp4';
    
    addBackground( fileName,ext );
    %bgImg=getAveGB(fileName,ext,1);
    
    

    %create player detector
    %playerDetector.reader = vision.VideoFileReader(strcat(fileName,'_Processed.',ext));
    playerDetector.reader = vision.VideoFileReader(strcat(fileName,'.',ext));
    %mkdir(strcat(fileName,'noBG/'));

    playerDetector.videoPlayer = vision.VideoPlayer('Position', [20, 400, 700, 400]);
    playerDetector.maskPlayer = vision.VideoPlayer('Position', [740, 400, 700, 400]);

    playerDetector.detector = vision.ForegroundDetector('NumGaussians', 3, ...
        'NumTrainingFrames', 50, 'MinimumBackgroundRatio', 0.7);

    playerDetector.blobAnalyser = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
        'AreaOutputPort', true, 'CentroidOutputPort', true, ...
        'MinimumBlobArea', minBlobArea); %, 'MaximumBlobArea', 150

    tracks = struct(...
        'id', {}, ...
        'bbox', {}, ...
        'kalmanFilter', {}, ...
        'age', {}, ...
        'totalVisibleCount', {}, ...
        'consecutiveInvisibleCount', {});

    nextTrackID=1;
    frameCount=0;

    hsizeh = 30  %need to iterative test these values two values. the bigger they are, the larger the blob they will find!
    sigmah = 6   %
    h = fspecial('log', hsizeh, sigmah);
    

    while ~isDone(playerDetector.reader)

        frameCount=frameCount+1;
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] processing frame -> ',num2str(frameCount)));
        
        frame = playerDetector.reader.step();
        imshow(frame);
                
        %img_tmp = double(frame); %load in the image and convert to double too allow for computations on the image
        img_bw = frame(:,:,1); %reduce to just the first dimension, we don't care about color (rgb) values here.
        imshow(img_bw); 
        
        [centroids, bboxes, mask] = detectObjects(frame);
        predictNewLocationsOfTracks();
        
        forMap(:,:,1)=double(frame(:,:,1).*mask);
        forMap(:,:,2)=double(frame(:,:,2).*mask);
        forMap(:,:,3)=double(frame(:,:,3).*mask);
        imshow(forMap); 
        
        forMap_bw=forMap(:,:,1); 
        imshow(forMap_bw);   
        
        blob_ori = conv2(forMap_bw,h,'same');
        imagesc(blob_ori); 
        colormap(jet)
        
        idx = find(blob_ori > -.5); 
        blob_ori(idx) = 0 ;
        imagesc(blob_ori); 
        colormap(jet)
                        
        [assignments, unassignedTracks, unassignedDetections] = ...
            detectionToTrackAssignment();

        updateAssignedTracks();
        updateUnassignedTracks();
        deleteLostTracks();
        createNewTracks();

        displayTrackingResults();

    end
    
    function [centroids, bboxes, mask] = detectObjects(frame)
        
        % Detect foreground.
        mask = playerDetector.detector.step(frame);
        
        % Apply morphological operations to remove noise and fill in holes.
        mask = imopen(mask, strel('rectangle', [3,3]));
        mask = imclose(mask, strel('rectangle', [15, 15])); 
        mask = imfill(mask, 'holes');
        
        % Perform blob analysis to find connected components.
        [~, centroids, bboxes] = playerDetector.blobAnalyser.step(mask);
    end
    

    function predictNewLocationsOfTracks()
        for i = 1:length(tracks)
            bbox = tracks(i).bbox;

            % Predict the current location of the track.
            predictedCentroid = predict(tracks(i).kalmanFilter);

            % Shift the bounding box so that its center is at
            % the predicted location.
            predictedCentroid = int32(predictedCentroid) - bbox(3:4) / 2;
            %tracks(i).bbox = [predictedCentroid, bbox(3:4)];
            tracks(i).bbox = [predictedCentroid, 50,50];
        end
    end

    function [assignments, unassignedTracks, unassignedDetections] = ...
        detectionToTrackAssignment()

        nTracks = length(tracks);
        nDetections = size(centroids, 1);

        % Compute the cost of assigning each detection to each track.
        cost = zeros(nTracks, nDetections);
        for i = 1:nTracks
            cost(i, :) = distance(tracks(i).kalmanFilter, centroids);
        end

        % Solve the assignment problem.
        costOfNonAssignment = 20;
        [assignments, unassignedTracks, unassignedDetections] = ...
        assignDetectionsToTracks(cost, costOfNonAssignment);
    end
    

    function updateAssignedTracks()
        numAssignedTracks = size(assignments, 1);
        for i = 1:numAssignedTracks
            trackIdx = assignments(i, 1);
            detectionIdx = assignments(i, 2);
            centroid = centroids(detectionIdx, :);
            bbox = bboxes(detectionIdx, :);
            
            %srg
            bbox(3)=50;
            bbox(4)=50;
            
            % Correct the estimate of the object's location
            % using the new detection.
            correct(tracks(trackIdx).kalmanFilter, centroid);
            
            % Replace predicted bounding box with detected
            % bounding box.
            tracks(trackIdx).bbox = bbox;
            
            % Update track's age.
            tracks(trackIdx).age = tracks(trackIdx).age + 1;
            
            % Update visibility.
            tracks(trackIdx).totalVisibleCount = ...
                tracks(trackIdx).totalVisibleCount + 1;
            tracks(trackIdx).consecutiveInvisibleCount = 0;
        end
    end

    function updateUnassignedTracks()
        for i = 1:length(unassignedTracks)
            ind = unassignedTracks(i);
            tracks(ind).age = tracks(ind).age + 1;
            tracks(ind).consecutiveInvisibleCount = ...
            tracks(ind).consecutiveInvisibleCount + 1;
        end
    end


    function deleteLostTracks()
        if isempty(tracks)
            return;
        end
        
        invisibleForTooLong = 10;
        ageThreshold = 8;
        
        % Compute the fraction of the track's age for which it was visible.
        ages = [tracks(:).age];
        totalVisibleCounts = [tracks(:).totalVisibleCount];
        visibility = totalVisibleCounts ./ ages;
        
        % Find the indices of 'lost' tracks.
        lostInds = (ages < ageThreshold & visibility < 0.6) | ...
            [tracks(:).consecutiveInvisibleCount] >= invisibleForTooLong;
        
        % Delete lost tracks.
        tracks = tracks(~lostInds);
    end


    function createNewTracks()
        centroids = centroids(unassignedDetections, :);
        bboxes = bboxes(unassignedDetections, :);
        
        for i = 1:size(centroids, 1)
            
            centroid = centroids(i,:);
            bbox = bboxes(i, :);
            
            % Create a Kalman filter object.
            kalmanFilter = configureKalmanFilter('ConstantVelocity', ...
                centroid, [200, 50], [100, 25], 100);
            
            % Create a new track.
            newTrack = struct(...
                'id', nextTrackID, ...
                'bbox', bbox, ...
                'kalmanFilter', kalmanFilter, ...
                'age', 1, ...
                'totalVisibleCount', 1, ...
                'consecutiveInvisibleCount', 0);
            
            % Add it to the array of tracks.
            tracks(end + 1) = newTrack;
            
            % Increment the next id.
            nextTrackID = nextTrackID + 1;
        end
    end


    function displayTrackingResults()
        % Convert the frame and the mask to uint8 RGB.
        frame = im2uint8(frame);
        mask = uint8(repmat(mask, [1, 1, 3])) .* 255;
        
        minVisibleCount = 8;
        if ~isempty(tracks)
              
            % Noisy detections tend to result in short-lived tracks.
            % Only display tracks that have been visible for more than 
            % a minimum number of frames.
            reliableTrackInds = ...
                [tracks(:).totalVisibleCount] > minVisibleCount;
            reliableTracks = tracks(reliableTrackInds);
            
            % Display the objects. If an object has not been detected
            % in this frame, display its predicted bounding box.
            if ~isempty(reliableTracks)
                % Get bounding boxes.
                bboxes = cat(1, reliableTracks.bbox);
                
                % Get ids.
                ids = int32([reliableTracks(:).id]);
                
                % Create labels for objects indicating the ones for 
                % which we display the predicted rather than the actual 
                % location.
                labels = cellstr(int2str(ids'));
                predictedTrackInds = ...
                    [reliableTracks(:).consecutiveInvisibleCount] > 0;
                isPredicted = cell(size(labels));
                isPredicted(predictedTrackInds) = {' predicted'};
                labels = strcat(labels, isPredicted);
                
                % Draw the objects on the frame.
                frame = insertObjectAnnotation(frame, 'rectangle', ...
                    bboxes, labels);
                
                % Draw the objects on the mask.
                mask = insertObjectAnnotation(mask, 'rectangle', ...
                    bboxes, labels);
            end
        end
        
        % Display the mask and the frame.
        playerDetector.maskPlayer.step(mask);        
        playerDetector.videoPlayer.step(frame);
    end

displayEndOfDemoMessage(mfilename)

end

