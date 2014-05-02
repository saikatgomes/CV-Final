function [playerCollection ] = updateStats( playerCollection )

    totNumOfFrame=playerCollection.totNumOfFrame;
    count=playerCollection.count ;
    allStartsX=NaN(count,1);
    allStartsY=NaN(count,1);
    allEndsX=NaN(count,1);
    allEndsY=NaN(count,1);
    h=playerCollection.screenH;
    w=playerCollection.screenW;

    for i=1:count
        onePlayer=playerCollection.list(i);
        steps = onePlayer.steps;        
        
        onePlayer.smoothTrackY_net =smooth(onePlayer.trackY_net,'moving');
        onePlayer.smoothTrackX_net =smooth(onePlayer.trackX_net,'moving');
        
        %srg test #####################################
        %super smooth!
        onePlayer.smoothTrackY_net =smooth(onePlayer.smoothTrackY_net,'moving');
        onePlayer.smoothTrackX_net =smooth(onePlayer.smoothTrackX_net,'moving');
        onePlayer.smoothTrackY_net =smooth(onePlayer.smoothTrackY_net,'moving');
        onePlayer.smoothTrackX_net =smooth(onePlayer.smoothTrackX_net,'moving');
        %srg test #####################################       
        
        onePlayer.smoothTrackY=NaN(totNumOfFrame,1);
        onePlayer.smoothTrackX=NaN(totNumOfFrame,1);
        
        st=onePlayer.startFrame;
        last=onePlayer.lastFrame;
        onePlayer.smoothTrackY(st:last,1)=onePlayer.smoothTrackY_net;
        onePlayer.smoothTrackX(st:last,1)=onePlayer.smoothTrackX_net;
        
        distance=0;
        smoothDistance=0;
        velocitySum=0;
        
        onePlayer.cumDistance=NaN(totNumOfFrame,1);
        
        onePlayer.cumDistance(st)=0;
        
        for t=1:steps-1
            d=pdist([onePlayer.trackY_net(t) onePlayer.trackX_net(t); ...
                onePlayer.trackY_net(t+1) onePlayer.trackX_net(t+1)]);
            distance=distance+d;
            d=pdist([onePlayer.smoothTrackY_net(t) onePlayer.smoothTrackX_net(t); ...
                onePlayer.smoothTrackY_net(t+1) onePlayer.smoothTrackX_net(t+1)]);
            smoothDistance=smoothDistance+d;
            onePlayer.cumDistance(st+t)=smoothDistance;
            if(t<steps-1)
                d2= pdist([onePlayer.smoothTrackY_net(t+1) onePlayer.smoothTrackX_net(t+1); ...
                    onePlayer.smoothTrackY_net(t+2) onePlayer.smoothTrackX_net(t+2)]);
                d_tot=d+d2;
                v=d_tot/2;
                velocitySum=velocitySum+v;
            else
                velocitySum=velocitySum+d;
            end
        end
        onePlayer.distance=distance;
        onePlayer.smoothDistance=smoothDistance;
        onePlayer.aveVel=velocitySum/steps;
        if(onePlayer.startingY<(w*.33)||onePlayer.startingY>(w*.66))
            onePlayer.position='WR';
        end
        playerCollection.list(i)=onePlayer;

        allStartsX(i)=onePlayer.startingX;
        allStartsY(i)=onePlayer.startingY;
        allEndsX(i)=onePlayer.lastKnownX;
        allEndsY(i)=onePlayer.lastKnownY;
                
    end

    playerCollection.allStartsX=allStartsX;
    playerCollection.allStartsY=allStartsY;
    playerCollection.allEndsX=allEndsX;
    playerCollection.allEndsY=allEndsY;

    est_dist = pdist([ allStartsX allStartsY  ; ...
        allEndsX allEndsY]);
    est_dist = squareform(est_dist); %make square
    est_dist=est_dist(1:count,count+1:end);

    th=playerCollection.threshold;

    [candidateStart candidateEnd]=find(est_dist<th);
    playerCollection.candidateStart=candidateStart;
    playerCollection.candidateEnd=candidateEnd;


end

