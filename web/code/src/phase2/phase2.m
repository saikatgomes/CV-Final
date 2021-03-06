function [ ] = phase2( base_dir )

    load(strcat(base_dir,'/data/phase1_data.mat'));

    %CHRISCROSSS :(
    X=Y_new;
    Y=X_new;

    % define main variables for KALMAN FILTER! :P
    dt = 1;  %our sampling rate
    % S_frame = 5 % find(cellfun(@length, X)>11,1); %starting frame
    S_frame = 1; % find(cellfun(@length, X)>11,1); %starting frame

    %now, since we have multiple players, we need a way to deal with a changing
    %number of estimates! this way seems more clear for a tutorial I think, but
    %there is probably a much more efficient way to do it.

    u = 0; % define acceleration magnitude to start
    HexAccel_noise_mag = 2; %process noise: the variability in how fast the Hexbug is speeding up (stdv of acceleration: meters/sec^2)
    tkn_x = .2;  %measurement noise in the horizontal direction (x axis).
    tkn_y = .2;  %measurement noise in the horizontal direction (y axis).
    Ez = [tkn_x 0; 0 tkn_y];
    Ex = [dt^4/4 0 dt^3/2 0; ...
        0 dt^4/4 0 dt^3/2; ...
        dt^3/2 0 dt^2 0; ...
        0 dt^3/2 0 dt^2].*HexAccel_noise_mag^2; % Ex convert the process noise (stdv) into covariance matrix
    P = Ex; % estimate of initial player position variance (covariance matrix)

    % Define update equations in 2-D! (Coefficent matrices): A physics based model for where we expect the player to be [state transition (state + velocity)] + [input control (acceleration)]
    A = [1 0 dt 0; 0 1 0 dt; 0 0 1 0; 0 0 0 1]; %state update matrice
    B = [(dt^2/2); (dt^2/2); dt; dt];
    C = [1 0 0 0; 0 1 0 0];  %this is our measurement function C, that we apply to the state estimate Q to get our expect next/new measurement

    % initize result variables
    Q_loc_meas = []; % the fly detecions  extracted by the detection algo
    % initize estimation variables for two dimensions
    Q= [X{S_frame} Y{S_frame} zeros(length(X{S_frame}),1) zeros(length(X{S_frame}),1)]';
    Q_estimate = nan(4,2000);
    Q_estimate(:,1:size(Q,2)) = Q;  %estimate of initial location estimation of where the players are(what we are updating)
    Q_loc_estimateY = nan(2000); %  position estimate
    Q_loc_estimateX= nan(2000); %  position estimate
    P_estimate = P;  %covariance estimator
    strk_trks = zeros(1,2000);  %counter of how many strikes a track has gotten
    nD = size(X{S_frame},1); %initize number of detections
    nF =  find(isnan(Q_estimate(1,:))==1,1)-1 ; %initize number of track estimates

    oneReader.reader = vision.VideoFileReader(strcat(base_dir,'/new.mp4'));
    inputVid=VideoReader(strcat(base_dir,'/new.mp4'));
    totNumOfFrame = inputVid.NumberOfFrames;
    frameCount=S_frame-1;

    for t = S_frame:totNumOfFrame-1

        frameCount=frameCount+1;
        %     display(strcat(datestr(now,'HH:MM:SS'),' [INFO] processing frame -> ',num2str(frameCount)));
        frame = oneReader.reader.step();
        img = frame(:,:,1);
        % make the given detections matrix
        Q_loc_meas = [X{t} Y{t}];

        hold on

        %% do the kalman filter
        % Predict next state of the players with the last state and predicted motion.
        nD = size(X{t},1); %set new number of detections
        for F = 1:nF
            Q_estimate(:,F) = A * Q_estimate(:,F) + B * u;
        end

        %predict next covariance
        P = A * P* A' + Ex;
        % Kalman Gain
        K = P*C'*inv(C*P*C'+Ez);

        %% now we assign the detections to estimated track positions
        %make the distance (cost) matrice between all pairs rows = tracks, coln =
        %detections
        est_dist = pdist([Q_estimate(1:2,1:nF)'; Q_loc_meas]);
        est_dist = squareform(est_dist); %make square
        est_dist = est_dist(1:nF,nF+1:end) ; %limit to just the tracks to detection distances

        [asgn, cost] = assignmentoptimal(est_dist); %do the assignment with hungarian algo
        asgn = asgn';

        % ok, now we check for tough situations and if it's tough, just go with estimate and ignore the data
        %make asgn = 0 for that tracking element
        %check 1: is the detection far from the observation? if so, reject it.
        rej = [];
        for F = 1:nF
            if asgn(F) > 0
                rej(F) =  est_dist(F,asgn(F)) < 50 ;
            else
                rej(F) = 0;
            end
        end
        asgn = asgn.*rej;


        %apply the assingment to the update
        k = 1;
        for F = 1:length(asgn)
            if asgn(F) > 0
                Q_estimate(:,k) = Q_estimate(:,k) + K * (Q_loc_meas(asgn(F),:)' - C * Q_estimate(:,k));
            end
            k = k + 1;
        end

        % update covariance estimation.
        P =  (eye(4)-K*C)*P;

        % Store data
        Q_loc_estimateX(t,1:nF) = Q_estimate(1,1:nF);
        Q_loc_estimateY(t,1:nF) = Q_estimate(2,1:nF);

        new_trk = [];
        new_trk = Q_loc_meas(~ismember(1:size(Q_loc_meas,1),asgn),:)';
        if ~isempty(new_trk)
            Q_estimate(:,nF+1:nF+size(new_trk,2))=  [new_trk; zeros(2,size(new_trk,2))];
            nF = nF + size(new_trk,2);  % number of track estimates with new ones included
        end

        %give a strike to any tracking that didn't get matched up to a
        %detection
        no_trk_list =  find(asgn==0);
        if ~isempty(no_trk_list)
            strk_trks(no_trk_list) = strk_trks(no_trk_list) + 1;
        end

        %if a track has a strike greater than 3, delete the tracking. i.e.
        %make it nan first vid = 3
        %bad_trks = find(strk_trks > 10);
        bad_trks = find(strk_trks > 3);
        Q_estimate(:,bad_trks) = NaN;

    end

    dataDir=strcat(base_dir,'/data');
    mkdir(dataDir);
    save(strcat(dataDir,'/phase2_data.mat'),'totNumOfFrame','Q_loc_estimateY','Q_loc_estimateX','nF','frame');

end

