function [ playerCollection ] = mergeTracks( playerCollection, parent, child )

    parentPlayer=playerCollection.list(parent);
    childPlayer=playerCollection.list(child);
    c_start=childPlayer.startFrame;
    c_last=childPlayer.lastFrame;
    p_last=parentPlayer.lastFrame;

    parentPlayer.lastKnownX=childPlayer.lastKnownX;
    parentPlayer.lastKnownY=childPlayer.lastKnownY;
    parentPlayer.lastFrame=childPlayer.lastFrame;
    parentPlayer.steps=parentPlayer.steps+childPlayer.steps;
    parentPlayer.isOutOfBounds=childPlayer.isOutOfBounds;       

    if(c_start>p_last)
        for i=c_start:c_last
            parentPlayer.trackX(i)=childPlayer.trackX(i);
            parentPlayer.trackY(i)=childPlayer.trackY(i);
        end
        if(c_start>p_last+1)
            %need to interpolate!
        end
    else
        for i=c_start:c_last
            if(i>p_last)
                parentPlayer.trackX(i)=childPlayer.trackX(i);
                parentPlayer.trackY(i)=childPlayer.trackY(i);
            else
                %need to average it!
                parentPlayer.trackX(i)=(parentPlayer.trackX(i)+childPlayer.trackX(i))/2;
                parentPlayer.trackY(i)=(parentPlayer.trackY(i)+childPlayer.trackY(i))/2;                
            end            
        end
    end
    
    if(child==1)        
        playerCollection.list=playerCollection.list(2:end);        
    elseif(child==playerCollection.count)        
        playerCollection.list=playerCollection.list(1:end-1);   
    else
        A=playerCollection.list(1:child-1);
        B=playerCollection.list(child+1:end);
        C=[A B];
        playerCollection.list=C;     
    end   
    playerCollection.count=playerCollection.count-1;
    playerCollection= updateStats( playerCollection );
end