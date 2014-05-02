function [  ] = displayTracks( playerCollection, frame , dir, fName , isPrint, isShowEnds )

    warning('off','all');
    f=figure();
    imshow(frame);
    hold on;
    c_list = ['r' 'b' 'g' 'c' 'm' 'y'];
    for i=1:playerCollection.count
        onePlayer=playerCollection.list(i);
        st=onePlayer.startFrame;
        last=onePlayer.lastFrame;
        Cz = mod(i,6)+1; %pick color
        tmX = onePlayer.trackX(st:last);
        tmY = onePlayer.trackY(st:last);
        
        plot(onePlayer.smoothTrackY_net(1:end,1),onePlayer.smoothTrackX_net(1:end,1),'w.-','markersize',1,'linewidth',1)
        
%         text(onePlayer.startingY, onePlayer.startingX, ...
%                 strcat('............',num2str(i),'[',num2str(onePlayer.smoothDistance),']'),...
%                 'BackgroundColor', 'none', 'FontSize', 9,'FontWeight','normal',...
%                 'Color','w')
        
         plot(tmY,tmX,'.-','markersize',1,'color',c_list(Cz),'linewidth',1)
        if(isShowEnds==1)
            text(onePlayer.lastKnownY, onePlayer.lastKnownX, ...
                strcat('......',num2str(i),'[E:',num2str(last),']'),...
                'BackgroundColor', 'none', 'FontSize', 9,'FontWeight','normal',...
                'Color',c_list(Cz))
            text(onePlayer.startingY, onePlayer.startingX, ...
                strcat('............',num2str(i),'[S',num2str(st),']'),...
                'BackgroundColor', 'none', 'FontSize', 9,'FontWeight','normal',...
                'Color',c_list(Cz))
        end
    end
    if(isPrint==1)       
        saveas(f,strcat(dir,'/',fName,'_',datestr(now,'HH-MM-SS'),'.jpg')); 
    end
    hold off;
    %close(f2);


end

