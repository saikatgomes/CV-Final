function [  ] = displayTracksContinuous( playerCollection, frame, base_dir, isPrint, isShowEnds  )

warning('off','all');
SHOW_PLOTS=0;

hostName=getHostName();
f1=figure();

if(SHOW_PLOTS==0)
    set(f1,'visible','off');
end
imshow(frame);
hold on;
% c_list = ['r' 'b' 'g' 'c' 'm' 'y'];
% c_list = ['r' 'b' 'g' 'm' 'y'];
c_list = ['r' 'b' 'g'  'y'];

h=size(frame,1);
w=size(frame,2);

plot([w*.33 w*.33]',[1 h]','y.:','markersize',1,'linewidth',1)
plot([w*.66 w*.66]',[1 h]','y.:','markersize',1,'linewidth',1)

plot([w*.4 w*.4]',[1 h]','r.:','markersize',1,'linewidth',1)
plot([w*.59 w*.59]',[1 h]','r.:','markersize',1,'linewidth',1)

plot([1 w]',[h*.64 h*.64]','y.:','markersize',1,'linewidth',1)

if(isPrint==1)    
    inputVid=VideoReader(strcat(base_dir,'/new.mp4'));
    FrameRate=inputVid.FrameRate;
    est_tracks=VideoWriter(strcat(base_dir,'/est_tracks.mp4'),'MPEG-4');
    est_tracks.FrameRate=FrameRate/2;
    open(est_tracks);
end

oneReader = vision.VideoFileReader(strcat(base_dir,'/new.mp4'));
totNumOfFrame=playerCollection.totNumOfFrame;
count=playerCollection.count ;

for j=1:totNumOfFrame-1
    frame = oneReader.step();
    imshow(frame);
    
    hold on;
    for i=1:count
        onePlayer=playerCollection.list(i);
        st=onePlayer.startFrame;
        last=onePlayer.lastFrame;
        if(st>j || last<j)
            continue;
        end
        %pause(.1);
        
        if(j>st+2)            
            d=pdist([onePlayer.smoothTrackY(j) onePlayer.smoothTrackX(j); ...
                    onePlayer.smoothTrackY(j-1) onePlayer.smoothTrackX(j-1)]);            
            d=d+pdist([onePlayer.smoothTrackY(j-1) onePlayer.smoothTrackX(j-1); ...
                    onePlayer.smoothTrackY(j-2) onePlayer.smoothTrackX(j-2)]);
        elseif(j==st+1)
            d=pdist([onePlayer.smoothTrackY(j) onePlayer.smoothTrackX(j); ...
                onePlayer.smoothTrackY(j-1) onePlayer.smoothTrackX(j-1)]); 
            d=d*2;
        else
            d=0;
        end
        
        v=d/2;
        v = sprintf('%.2f',v);
        cdist=onePlayer.cumDistance(j);
        cdist = sprintf('%.2f',cdist);        
        
        
        %     Cz = mod(i,6)+1; %pick color
        %     Cz = mod(i,5)+1; %pick color
        Cz = mod(i,4)+1; %pick color        
        if(strcmp(onePlayer.position,'WR'))
            cr='c';
        elseif(strcmp(onePlayer.position,'TE'))
            cr='m';
        else
            cr=c_list(Cz);
        end
        plot(onePlayer.smoothTrackY(j,1),...
            onePlayer.smoothTrackX(j,1),...
            'wo','markersize',9,'linewidth',8);
        plot(onePlayer.smoothTrackY(j,1),...
            onePlayer.smoothTrackX(j,1),...
            'o','markersize',8,'linewidth',8,'Color',cr);
        
        disStr=[strcat('............',num2str(i),' (',onePlayer.position,')', ...
                    10,...
                    '           [V: ',num2str(v),']',...
                    10,...
                    '           [D: ',num2str(cdist),']'    )];
        
        plot(onePlayer.smoothTrackY(st:j,1),...
            onePlayer.smoothTrackX(st:j,1),...
            '.-','markersize',1,'linewidth',1,'Color',cr);
        text(onePlayer.smoothTrackY(j,1), onePlayer.smoothTrackX(j,1), ...
        disStr,...
        'BackgroundColor', 'none', 'FontSize', 7,'FontWeight','normal',...
        'Color','w')                   
    end
        
    plot([w*.33 w*.33]',[1 h]','y.:','markersize',1,'linewidth',1)
    plot([w*.66 w*.66]',[1 h]','y.:','markersize',1,'linewidth',1)    
    plot([w*.4 w*.4]',[1 h]','r.:','markersize',1,'linewidth',1)
    plot([w*.59 w*.59]',[1 h]','r.:','markersize',1,'linewidth',1)    
    plot([1 w]',[h*.64 h*.64]','y.:','markersize',1,'linewidth',1)
    
    %pause(.01);
    
    if(isPrint==1)
        %saveas(f1,strcat(hostName,'_temp.jpg'));
        %tempI=imread(strcat(hostName,'_temp.jpg'));
        writeVideo(est_tracks,getframe(f1));
        %delete(strcat(hostName,'_temp.jpg'));
    end
    hold off;
end

if(isPrint==1)    
    close(est_tracks);
end

close(f1);

end

