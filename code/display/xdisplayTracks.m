%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Saikat R. Gomes
%% Email: saikat@cs.wisc.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [  ] = displayTracks( playerCollection, frame , dir, ...
                        fName , isPrint, isShowEnds, showActual )

    warning('off','all');
    SHOW_PLOTS=1;
    f=figure();
    imshow(frame);

    if(SHOW_PLOTS==0)
        set(f,'visible','off');
    end

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

    for i=1:playerCollection.count
        onePlayer=playerCollection.list(i);
        st=onePlayer.startFrame;
        last=onePlayer.lastFrame;
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

%         plot(onePlayer.smoothTrackY_net(1:end,1),onePlayer.smoothTrackX_net(1:end,1),...
%             '.-','markersize',4,'linewidth',4,'Color',cr)

        if(showActual==1)
            tmX = onePlayer.trackX(st:last);
            tmY = onePlayer.trackY(st:last);
            plot(tmY,tmX,'.-','markersize',4,'color',cr,'linewidth',4)
        else
            plot(onePlayer.smoothTrackY_net(1:end,1),onePlayer.smoothTrackX_net(1:end,1),...
            '.-','markersize',4,'linewidth',4,'Color',cr)
        end
        if(isShowEnds==1)
            text(onePlayer.lastKnownY, onePlayer.lastKnownX, ...
                strcat('......',num2str(i),'[E:',num2str(last),']'),...
                'BackgroundColor', 'none', 'FontSize', 9,'FontWeight','normal',...
                'Color',cr)
            text(onePlayer.startingY, onePlayer.startingX, ...
                strcat('............',num2str(i),'[S',num2str(st),']'),...
                'BackgroundColor', 'none', 'FontSize', 9,'FontWeight','normal',...
                'Color',cr)
        end
    end
    hold off;
    if(isPrint==1)
        img=getframe(f);
        imwrite(img.cdata,strcat(dir,'/',fName,'.jpg'));
    end
    close(f);
end

