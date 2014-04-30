function [ t_num, f_start, f_end, isTrackDone, numFound ] = srgGetNextTrack(   t_num, f_start, f_end,numFound, Q_loc_estimateY, Q_loc_estimateX , isTrackDone, totNumOfFrame)

    for i=1:totNumOfFrame
        if(min(isTrackDone)==1)
            break;
        end
        if(isTrackDone(i)==1)
            continue;
        end
        lastTrackFound=t_num(numFound);
        lastEnd=f_end(numFound);
        lastX=Q_loc_estimateX(lastEnd,lastTrackFound);
        lastY=Q_loc_estimateY(lastEnd,lastTrackFound);

    end

end

