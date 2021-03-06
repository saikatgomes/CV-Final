%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Saikat R. Gomes
%% Email: saikat@cs.wisc.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [  ] = phase3( base_dir  )

    warning('off','all');
    load(strcat(base_dir,'/data/phase2_data.mat'));
    set(0,'DefaultFigureWindowStyle','docked')

    player = struct('id','',...
        'position','',...
        'startFrame','',...
        'lastFrame','',...
        'lastKnownX','',...
        'lastKnownY','',...
        'startingX','',...
        'startingY','',...
        'trackX','',...
        'trackY','',...
        'trackX_net','',...
        'trackY_net','',...
        'smoothTrackX','',...
        'smoothTrackY','',...
        'smoothTrackX_net','',...
        'smoothTrackY_net','',...
        'steps','',...
        'isOutOfBounds','',...
        'distance','',...
        'smoothDistance','',...
        'cumDistance','',...
        'aveVel',''...
        );
    playerCollection.list(2000)=player;
    playerCollection.count=0;
    playerCollection.threshold=50;
    playerCollection.totNumOfFrame=totNumOfFrame;
    playerCollection.screenH=size(frame,1);
    playerCollection.screenW=size(frame,2);

    for trackN=1:size(Q_loc_estimateY,2)
        m=min( Q_loc_estimateY(:,trackN));
        if(isnan(m))
            break;
        end
        st=NaN;
        last=NaN;
        for j=1:totNumOfFrame
            if(isnan(st))
                if(~isnan(Q_loc_estimateY(j,trackN)))
                    st=j;
                end
            else
                if(isnan(Q_loc_estimateY(j,trackN)))
                    last=j-1;
                    break;
                end
            end
        end
        if(isnan(last))
            last= totNumOfFrame;
        end
        if(~isnan(st) && ~isnan(last))
            if(last~=totNumOfFrame-1)
                last=last-3;
            end
        end
        if(last-st<2)
            continue;
        end
        p_count=playerCollection.count+1;
        playerCollection.count=p_count;
        onePlayer = struct('id','',...
            'position','',...
            'startFrame','',...
            'lastFrame','',...
            'lastKnownX','',...
            'lastKnownY','',...
            'startingX','',...
            'startingY','',...
            'trackX','',...
            'trackY','',...
            'trackX_net','',...
            'trackY_net','',...
            'smoothTrackX','',...
            'smoothTrackY','',...
            'smoothTrackX_net','',...
            'smoothTrackY_net','',...
            'steps','',...
            'isOutOfBounds','',...
            'distance','',...
            'smoothDistance','',...
            'cumDistance','',...
            'aveVel',''...
            );
        onePlayer.id=p_count;
        onePlayer.position='unknown';
        onePlayer.startFrame=st;
        onePlayer.lastFrame=last;
        onePlayer.lastKnownX=Q_loc_estimateX(last,trackN);
        onePlayer.lastKnownY=Q_loc_estimateY(last,trackN);
        onePlayer.startingX=Q_loc_estimateX(st,trackN);
        onePlayer.startingY=Q_loc_estimateY(st,trackN);
        onePlayer.trackX=Q_loc_estimateX(1:totNumOfFrame,trackN);
        onePlayer.trackY=Q_loc_estimateY(1:totNumOfFrame,trackN);

        for n=last+1:totNumOfFrame
            onePlayer.trackX(n)=nan;
            onePlayer.trackY(n)=nan;
        end
        onePlayer.steps=last-st+1;
        onePlayer.isOutOfBounds=1;
        playerCollection.list(p_count)=onePlayer;
    end

    playerCollection.list(playerCollection.count+1:end)=[]; %remove empty spaces
    playerCollection.list_unsorted=playerCollection.list;
    addpath('sort/');
    playerCollection.list = nestedSortStruct(playerCollection.list, 'steps');

    playerCollection= updateStats( playerCollection );
    addpath('display/');
    displayTracks( playerCollection, frame , base_dir , 'phase3_initial' , 1, 0 ,0);

    isFound=1;
    while(isFound==1)
        [isFound,playerCollection]=optimzeTracks( playerCollection);
    end

    playerCollection.list = nestedSortStruct(playerCollection.list, 'steps');
    displayTracks( playerCollection, frame , base_dir , 'phase3_pass1' , 1, 0 ,0);
    playerCollection = pruneTracks( playerCollection, 20 ); %prune all tracks that are less that 20
    displayTracks( playerCollection, frame , base_dir , 'phase3_pass2' , 1, 0 ,0);
    displayTracks( playerCollection, frame , base_dir , 'phase3_pass2_withEnds' , 1, 1 ,0);
    displayTrackNoBG( playerCollection, frame , base_dir, 'phase3_justTracks' , 1 )
    displayTracksContinuous( playerCollection, frame , base_dir,1,0);

    dataDir=strcat(base_dir,'/data');
    mkdir(dataDir);
    save(strcat(dataDir,'/phase3_data.mat'),'playerCollection');
    rmpath('sort/');
    rmpath('display/');
end

