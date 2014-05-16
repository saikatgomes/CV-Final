%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Saikat R. Gomes
%% Email: saikat@cs.wisc.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ isFound, playerCollection ] = optimzeTracks( playerCollection )

    isFound=0;
    minDist=[25 50 60 70 75];
    timeDiff=[1 2 3 4 5 0 -1 -2 -3];
    pCount=playerCollection.count;
    for t=timeDiff
        %for d=minDist
        for p=1:pCount
            clear foundList;
            clear foundDist;
            foundCount=0;
            for q=1:pCount
                if(p==q)
                    continue;
                end
                mainPlayer=playerCollection.list(p);
                otherPlayer=playerCollection.list(q);
                if(mainPlayer.lastFrame+t~=otherPlayer.startFrame)
                    continue;
                end

                x1=mainPlayer.lastKnownX;
                y1=mainPlayer.lastKnownY;
                x2=otherPlayer.startingX;
                y2=otherPlayer.startingY;

                distance = pdist([ x1 y1 ; x2 y2 ]);
                if(distance>80)
                    continue;
                end
                if(playerCollection.list(q).steps<2)
                    %wont consider 1 steps
                    continue;
                end

                isFound=1;
                foundCount=foundCount+1;
                foundList(foundCount)=q;
                foundDist(foundCount)=distance;
                %return;
            end
            if(foundCount>0)
                minD=min(foundDist);
                idx=find(foundDist==minD);
                m=foundList(idx);
                %                     display(strcat('main:',num2str(p),10,'possible:',num2str(foundList),'...candicate:',num2str(m)));
                playerCollection= mergeTracks( playerCollection, p, m );
                isFound=1;
                return;
                %display(strcat('t=',num2str(t),',d=',num2str(d),10,'main:',num2str(p),10,'possible:',num2str(foundList)));
            end
        end
        %end
    end
end

