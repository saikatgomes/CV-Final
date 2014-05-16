%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Saikat R. Gomes
%% Email: saikat@cs.wisc.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [  ] = displayTracksContinuous( playerCollection, frame )

    warning('off','all');
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

    
    totNumOfFrame=playerCollection.totNumOfFrame;
    count=playerCollection.count ;
        
    for i=1:count
        onePlayer=playerCollection.list(i);
        st=onePlayer.startFrame;
        last=onePlayer.lastFrame;
        Cz = mod(i,6)+1; %pick color
        clear f;
        hold on;
        for j=1:totNumOfFrame
            if(st>j)
                continue;
            end
            if(last<j)
                break;
            end
            %pause(.1);
            if(j>1 && st<j)
               delete(f(j-1)); 
            end
            j
            f(j)=plot(onePlayer.smoothTrackY(j,1),...
                onePlayer.smoothTrackX(j,1),...
                'o','markersize',12,'linewidth',8,'Color',c_list(Cz));
            plot(onePlayer.smoothTrackY(st:j,1),...
                onePlayer.smoothTrackX(st:j,1),...
                'w.-','markersize',1,'linewidth',1);
            
        end
    end
    

        hold off;
end

