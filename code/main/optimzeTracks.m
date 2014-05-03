function [ isFound, playerCollection ] = optimzeTracks( playerCollection )

    isFound=0;
    minDist=[25 50 60 70 75];
    timeDiff=[1 2 3 4 5 0 -1 -2 -3];
    pCount=playerCollection.count;
    for t=timeDiff
        %for d=minDist
            for p=1:pCount
                clear foundList;
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
%                     
%                     if(p==3 &&q==13)
%                         temp=0;
%                     end
%                     
%                     if(p==61 &&q==3)
%                         temp=0;
%                     end
                    
                    distance = pdist([ x1 y1  ;...
                                       x2 y2 ]);
                    if(distance>80)
                        continue;
                    end
                    
                    isFound=1;
                    foundCount=foundCount+1;
                    foundList(foundCount)=q;
                    %return;
                end
                if(foundCount>0)
                    m=min(foundList);
                    display(strcat('main:',num2str(p),10,'possible:',num2str(foundList),'...candicate:',num2str(m)));
                    playerCollection= mergeTracks( playerCollection, p, m );   
                    isFound=1;
                    return;
                    %display(strcat('t=',num2str(t),',d=',num2str(d),10,'main:',num2str(p),10,'possible:',num2str(foundList)));
                end
            end
        %end
    end
end

