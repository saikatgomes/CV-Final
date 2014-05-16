%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Saikat R. Gomes
%% Email: saikat@cs.wisc.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ idx,ctrs ,SUMD, DistMat ] = getCentroids( X, Y, k )
    
dataset=[X Y];
opts = statset('Display','off');
[idx,ctrs,SUMD, DistMat ] = kmeans(dataset,k,'Distance','sqEuclidean',...
    'Replicates',7,'Options',opts);

end

