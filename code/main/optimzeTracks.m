function [ isFound ] = optimzeTracks( playerCollection )
    
    isFound=0;
    minDist=[25 50 60 70 75];
    timeDiff=[0 1 2 3 4 5 -1 -2 -3];
    pCount=playerCollection.count;
    for d=minDist
        for t=timeDiff
            for p=1:pCount
                clear foundList;
                foundCount=0;
                for q=1:pCount
                    if(p==q)
                        continue;
                    end
                    mainPlayer=playerCollection.list(p);                    
                    otherPlayer=playerCollection.list(q);
                    if(mainPlayer.startFrame+t~=otherPlayer.startFrame)
                        continue;
                    end
                    
                    
                    isFound=1;
                    foundCount=foundCount+1;
                    foundList(foundCount)=q;
                    return;
                end
                if(foundCount>0)
                    display(strcat('main:',num2str(p),10,'possible:',num2str(foundList)));
                end
            end            
        end
    end
end

