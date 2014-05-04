function [  ] = displayTracks( playerCollection, frame , dir, fName , isPrint, isShowEnds, showActual )

warning('off','all');
SHOW_PLOTS=0;
f=figure();

backImg=zeros(size(frame,1),size(frame,2),3);

imshow(frame);
% imshow(backImg);

if(SHOW_PLOTS==0)
    set(f,'visible','off');
end

hold on;
c_list = ['r' 'b' 'g' 'c' 'm' 'y'];

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
    Cz = mod(i,6)+1; %pick color
    
    plot(onePlayer.smoothTrackY_net(1:end,1),onePlayer.smoothTrackX_net(1:end,1),...
        '.-','markersize',1,'linewidth',1,'Color',c_list(Cz))
       
    if(showActual==1)
        tmX = onePlayer.trackX(st:last);
        tmY = onePlayer.trackY(st:last);
        plot(tmY,tmX,'.-','markersize',1,'color',c_list(Cz),'linewidth',1)
    end
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
hold off;
if(isPrint==1)
    img=getframe(f);
    imwrite(img.cdata,strcat(dir,'/',fName,'.jpg'));
end
close(f);
end

