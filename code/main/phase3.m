function [  ] = phase3( base_dir, myVid  )

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
    'isOutOfBounds','');
playerCollection.list(2000)=player;
playerCollection.count=0;

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
        'isOutOfBounds','');
    onePlayer.id=p_count;
    onePlayer.position='unknown';
    onePlayer.startFrame=st;
    onePlayer.lastFrame=last;
    onePlayer.lastKnownX=Q_loc_estimateX(last,trackN);
    onePlayer.lastKnownY=Q_loc_estimateY(last,trackN);
    onePlayer.startingX=Q_loc_estimateX(st,trackN);
    onePlayer.startingY=Q_loc_estimateY(st,trackN);    
    onePlayer.trackX=Q_loc_estimateX(:,trackN);
    onePlayer.trackY=Q_loc_estimateY(:,trackN);
    onePlayer.trackX_net=Q_loc_estimateX(st:last,trackN);
    onePlayer.trackY_net=Q_loc_estimateY(st:last,trackN);   
    
    onePlayer.smoothTrackY_net =smooth(onePlayer.trackY_net,'moving');
    onePlayer.smoothTrackX_net =smooth(onePlayer.trackX_net,'moving');
    
    onePlayer.steps=last-st+1;
    onePlayer.isOutOfBounds=1;
    playerCollection.list(p_count)=onePlayer;
end

playerCollection.list(playerCollection.count+1:end)=[]; %remove empty spaces
playerCollection.list_unsorted=playerCollection.list;
addpath('sort/');
playerCollection.list = nestedSortStruct(playerCollection.list, 'steps');
%C = nestedSortStruct(A, {'year', 'name'});
rmpath('sort/');

displayTracks( playerCollection, frame , base_dir , 'phase3_1a' , 1, 1 );
displayTracks( playerCollection, frame , base_dir , 'phase3_1b' , 1, 0 );

f3=figure();
imshow(frame);
isTrackDone=zeros(nF,1);
hold on;
Ms = [3 5]; %marker sizes
c_list = ['r' 'b' 'g' 'c' 'm' 'y'];
trackNumer=0;

newTracksY=NaN(totNumOfFrame,100);
newTracksX=NaN(totNumOfFrame,100);

for i=1:nF
    if(min(isTrackDone)==1)
        break;
    end
    if(isTrackDone(i)==1)
        continue;
    end
    st=NaN;
    last=NaN;
    trackNumer=trackNumer+1;
    Sz = mod(trackNumer,2)+1; %pick marker size
    Cz = mod(trackNumer,6)+1; %pick color
    for j=1:totNumOfFrame
        if(isnan(st))
            if(~isnan(Q_loc_estimateY(j,i)))
                st=j;
                continue;
            end
        else
            if(isnan(Q_loc_estimateY(j,i)))
                last=j-1;
            end
        end
        if(~isnan(last) && last~=totNumOfFrame-1)
            last=last-3;
        end
        if(~isnan(st) && ~isnan(last))
            newTracksY(st:last,trackNumer)=Q_loc_estimateY(st:last,i);
            newTracksX(st:last,trackNumer)=Q_loc_estimateX(st:last,i);
            isTrackDone(i)=1;
            clear t_num f_start f_end numFound;
            t_num(1)=i;
            f_start(1)=st;
            f_end(1)=last;
            if(j==totNumOfFrame)
                continue;
            end
            [ t_num, f_start, f_end, isTrackDone, numFound ] = findNearTracks(  t_num, f_start, f_end,1, Q_loc_estimateY, Q_loc_estimateX , isTrackDone, totNumOfFrame);
            for k=2:numFound
                new_s=f_start(k);
                new_e=f_end(k);
                t=t_num(k);
                st=last+1;
                last=st+(new_e-new_s);
                for l=0:new_e-new_s
                    newTracksY(st+l,trackNumer)=Q_loc_estimateY(new_s+l,t);
                    newTracksX(st+l,trackNumer)=Q_loc_estimateX(new_s+l,t);
                    
                end
            end
            break;
        end
        
    end
    %plot(newTracksY(:,trackNumer),newTracksX(:,trackNumer),'.-','markersize',Ms(Sz),'color',c_list(Cz),'linewidth',3)
    %plot(newTracksY(:,trackNumer),newTracksX(:,trackNumer),'w.-','markersize',3,'linewidth',1);
    
    smoothY=smooth(newTracksY(find(~isnan(newTracksY(:,trackNumer))),trackNumer),'rlowess');
    smoothX=smooth(newTracksX(find(~isnan(newTracksX(:,trackNumer))),trackNumer),'rlowess');
    smoothLnt=length(smoothX);
    if(smoothX(smoothLnt)<1 && smoothY(smoothLnt)<1)
        smoothX(smoothLnt)=[];
        smoothY(smoothLnt)=[];
    end
    
    plot(smoothY,smoothX,'.-','markersize',3,'linewidth',2,'color',c_list(Cz))
    
    % text(smoothY(1), smoothX(1), strcat('......',num2str(i),'(',num2str(smoothY(1)),',',num2str(smoothX(1)),')'),  'BackgroundColor', 'none', 'FontSize', 12,'FontWeight','normal','Color',c_list(Cz))
    text(smoothY(1), smoothX(1), strcat('......',num2str(i)),  'BackgroundColor', 'none', 'FontSize', 12,'FontWeight','normal','Color',c_list(Cz))
    
end


hold off




end

