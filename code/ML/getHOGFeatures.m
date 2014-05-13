function [ featureVector, hogVisualization ] = getHOGFeatures( img, s )
    [featureVector, hogVisualization] = extractHOGFeatures(img,'CellSize', [s s]);
end

