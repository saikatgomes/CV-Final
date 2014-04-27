function [ idx,ctrs ,SUMD, DistMat ] = getCentroids( X, Y, k )
    
dataset=[X Y];
opts = statset('Display','final');
[idx,ctrs,SUMD, DistMat ] = kmeans(dataset,k,'Distance','city',...
    'Replicates',5,'Options',opts);
end

