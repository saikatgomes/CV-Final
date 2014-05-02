function [playerCollection ] = updateStats( playerCollection )

    for i=1:playerCollection.count
        
        onePlayer=playerCollection.list(i);
        steps = onePlayer.steps;
        distance=0;
        for t=1:steps-1
            d=pdist([onePlayer.trackY_net(t) onePlayer.trackX_net(t); ...
                onePlayer.trackY_net(t+1) onePlayer.trackX_net(t+1)]);
            distance=distance+d;
        end
        onePlayer.distance=distance;
    end

end

