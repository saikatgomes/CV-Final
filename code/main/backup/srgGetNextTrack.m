function [ t_num, f_start, f_end, isTrackDone, numFound ] = srgGetNextTrack(   t_num, f_start, f_end,numFound, Q_loc_estimateY, Q_loc_estimateX , isTrackDone, totNumOfFrame)

%MaxDis=125;
MaxDis=50;

lastTrackFound=t_num(numFound);
lastEnd=f_end(numFound);
lastX=Q_loc_estimateX(lastEnd,lastTrackFound);
lastY=Q_loc_estimateY(lastEnd,lastTrackFound);


for ii=1:length(isTrackDone)
    if(min(isTrackDone)==1)
        break;
    end
    if(isTrackDone(ii)==1)
        continue;
    end
    
    
    %try 3 frames later:
    for jj=-2:2
% % %         lastX
% % %         lastY
% % %         Q_loc_estimateY(lastEnd+jj,ii)
% % %         Q_loc_estimateY(lastEnd+jj+1,ii)
        
        if( isnan(Q_loc_estimateY(lastEnd+jj,ii)) && ~isnan(Q_loc_estimateY(lastEnd+jj+1,ii)))
            
            newX=Q_loc_estimateX(lastEnd+jj+1,ii);
            newY=Q_loc_estimateY(lastEnd+jj+1,ii);
            distance = pdist([lastY lastX ; newY newX ],'euclidean');
            if(distance<MaxDis)
                isTrackDone(ii)=1;
                numFound=numFound+1;
                t_num(numFound)=ii;
                f_start(numFound)=lastEnd+jj+1;
                for kk=lastEnd+jj+2:totNumOfFrame
                    if(isnan(Q_loc_estimateY(kk,ii)))
                        f_end(numFound)=kk-1;
                        if(f_end(numFound)~=totNumOfFrame-1)
                            f_end(numFound)=f_end(numFound)-3;
                        end
                        break;
                    end
                end
                % try to find more
                if(f_end(numFound)==totNumOfFrame)
                    return;
                else
                   [ t_num, f_start, f_end, isTrackDone, numFound ] = srgGetNextTrack(   t_num, f_start, f_end,numFound, Q_loc_estimateY, Q_loc_estimateX , isTrackDone, totNumOfFrame);
                   return;
                end
            end
        end
        
    end
    
    
end

end
