function [  ] = displayTracksContinuous( playerCollection, frame, base_dir, isPrint, isShowEnds  )

warning('off','all');

hostName=getHostName();
f1=figure();
imshow(frame);
hold on;
c_list = ['r' 'b' 'g' 'c' 'm' 'y'];

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
    est_tracks.FrameRate=FrameRate;
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
        Cz = mod(i,6)+1; %pick color
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
        
        plot(onePlayer.smoothTrackY(j,1),...
            onePlayer.smoothTrackX(j,1),...
            'wo','markersize',9,'linewidth',8);
        plot(onePlayer.smoothTrackY(j,1),...
            onePlayer.smoothTrackX(j,1),...
            'o','markersize',8,'linewidth',8,'Color',c_list(Cz));
        
        disStr=[strcat('............',num2str(i),' (',onePlayer.position,')', ...
                    10,...
                    '           [V: ',num2str(v),']',...
                    10,...
                    '           [D: ',num2str(cdist),']'    )];
        
        plot(onePlayer.smoothTrackY(st:j,1),...
            onePlayer.smoothTrackX(st:j,1),...
            '.-','markersize',1,'linewidth',1,'Color',c_list(Cz));
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
    
    hold off;
    pause(.01);
    
    if(isPrint==1)
        saveas(f1,strcat(hostName,'_temp.jpg'),'bmp');
        tempI=imread(strcat(hostName,'_temp.jpg'));
        writeVideo(est_tracks,tempI);
        delete(strcat(hostName,'_temp.jpg'));
    end
end

if(isPrint==1)    
    close(est_tracks);
end

end

