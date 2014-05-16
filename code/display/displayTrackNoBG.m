%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Saikat R. Gomes
%% Email: saikat@cs.wisc.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [  ] = displayTrackNoBG(  playerCollection, frame , dir,fName , isPrint )

warning('off','all');
SHOW_PLOTS=0;
f=figure();

backImg=zeros(size(frame,1),size(frame,2),3);
imshow(backImg);

if(SHOW_PLOTS==0)
    set(f,'visible','off');
end

hold on;

for i=1:playerCollection.count
    onePlayer=playerCollection.list(i);
    st=onePlayer.startFrame;
    last=onePlayer.lastFrame;
    
    plot(onePlayer.smoothTrackY_net(1:end,1),onePlayer.smoothTrackX_net(1:end,1),...
        'w.-','markersize',1,'linewidth',5)       
end
hold off;
if(isPrint==1)
    img=getframe(f);
    imwrite(img.cdata,strcat(dir,'/',fName,'.jpg'));
end
close(f);
if(isPrint==1)
    
    f2=figure();    
    for s=[8 16 32 64 128]
        [featureVector, hogVisualization] = extractHOGFeatures(img.cdata,'CellSize', [s s]);
        plot(hogVisualization);
        img2=getframe(f2);
        imwrite(img2.cdata,strcat(dir,'/',fName,'_HOG_',num2str(s),'.jpg'));        
    end
    close(f2);
    
end
