%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Saikat R. Gomes
%% Email: saikat@cs.wisc.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ featureVector, hogVisualization ] = getHOGFeatures( img, s )
    [featureVector, hogVisualization] = extractHOGFeatures(img,'CellSize', [s s]);
end

