function [ idx,ctrs ] = getCentroids( X, Y, k )
    
dataset=[X Y];
opts = statset('Display','final');
[idx,ctrs] = kmeans(dataset,k,'Distance','city',...
    'Replicates',5,'Options',opts);
end

