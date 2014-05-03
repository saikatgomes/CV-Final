function [ playerCollection ] = pruneTracks( playerCollection, cutOffDis )
    
    newCount=0;
    for i=1:playerCollection.count
        onePlayer=playerCollection.list(i);
       if (onePlayer.steps<cutOffDis)
           continue;
       end
        newCount=newCount+1;
        newList(newCount)=onePlayer;
    end
    
    playerCollection.list=newList;
    playerCollection.count=newCount;

end

