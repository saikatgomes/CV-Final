function [playerCollection ] = updateStats( playerCollection )

    for i=1:playerCollection.count
        
        onePlayer=playerCollection.list(i);
        steps = onePlayer.steps;
        distance=0;
        smoothDistance=0;
        for t=1:steps-1
            d=pdist([onePlayer.trackY_net(t) onePlayer.trackX_net(t); ...
                onePlayer.trackY_net(t+1) onePlayer.trackX_net(t+1)]);
            distance=distance+d;
            d=pdist([onePlayer.smoothTrackY_net(t) onePlayer.smoothTrackX_net(t); ...
                onePlayer.smoothTrackY_net(t+1) onePlayer.smoothTrackX_net(t+1)]);
            smoothDistance=smoothDistance+d;
        end
        onePlayer.distance=distance;
        onePlayer.smoothDistance=smoothDistance;
        playerCollection.list(i)=onePlayer;
    end

end

