
load('srgTest.mat');

f2=figure()
imshow(frame);
hold on;
Ms = [3 5]; %marker sizes
c_list = ['r' 'b' 'g' 'c' 'm' 'y']
for i=1:nF
    st=NaN;
    last=NaN;
    Sz = mod(i,2)+1; %pick marker size
    Cz = mod(i,6)+1; %pick color
    for j=1:totNumOfFrame
        if(isnan(st))
            if(~isnan(Q_loc_estimateY(j,i)))
                st=j;
            end
        else
            if(isnan(Q_loc_estimateY(j,i)))
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
        tmX = Q_loc_estimateX(st:last,i);
        tmY = Q_loc_estimateY(st:last,i);
        plot(tmY,tmX,'.-','markersize',Ms(Sz),'color',c_list(Cz),'linewidth',3)
        text(Q_loc_estimateY(last,i), Q_loc_estimateX(last,i), strcat('......',num2str(i),'[E:',num2str(last),']'),  'BackgroundColor', 'none', 'FontSize', 12,'FontWeight','normal','Color',c_list(Cz))
        text(Q_loc_estimateY(st,i), Q_loc_estimateX(st,i), strcat('............',num2str(i),'[S',num2str(st),']'),  'BackgroundColor', 'none', 'FontSize', 12,'FontWeight','normal','Color',c_list(Cz))
        
        % % % %             if(last~=totNumOfFrame)
        % % % %                 tmX = Q_loc_estimateX(last-3:last,i);
        % % % %                 tmY = Q_loc_estimateY(last-3:last,i);
        % % % %                 plot(tmY,tmX,'.:','markersize',Ms(Sz),'color',c_list(Cz),'linewidth',3)
        % % % %             end
        continue;
    end
    
end
close(f2);
f3=figure();
imshow(frame);
isTrackDone=zeros(nF,1);
hold on;
Ms = [3 5]; %marker sizes
c_list = ['r' 'b' 'g' 'c' 'm' 'y']
trackNumer=0;
for i=1:nF
    i
    if(min(isTrackDone)==1)
        break;
    end
    if(isTrackDone(i)==1)
        continue;
    end
    st=NaN;
    last=NaN;
    trackNumer=trackNumer+1;
    for j=1:totNumOfFrame
        j
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
            clear t_Num f_start f_end numFound;
            t_num(1)=i;
            f_start(1)=st;
            f_end(1)=last;
            [ t_num, f_start, f_end, isTrackDone, numFound ] = srgGetNextTrack(  t_num, f_start, f_end,1, Q_loc_estimateY, Q_loc_estimateX , isTrackDone, totNumOfFrame);
            for k=2:numFound
                new_s=f_start(k);
                new_e=f_end(k);
                t=t_num(k);
                st=last+1;
                last=st+(new_s-new_e);                
                newTracksY(st:last,trackNumer)=Q_loc_estimateY(new_s:new_e,t);
                newTracksX(st:last,trackNumer)=Q_loc_estimateX(new_s:new_e,t);
            end
            break;
        end
        
    end
    
end


hold off
