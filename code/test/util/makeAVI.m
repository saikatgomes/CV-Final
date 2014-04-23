function [  ] = convert(  )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

files = dir(fullfile('*.mp4'));
for i = 1:length(files)
    filename = files(i).name;

    %create objects to read and write the video
    readerObj = VideoReader(files(i).name);
    str = files(i).name;
    [~,fileBase,fileExt] = fileparts(str);
    %writerObj = VideoWriter('files(i).name.avi','Uncompressed AVI');    
	writerObj = VideoWriter([fileBase '.avi'],'Uncompressed AVI');

    %open AVI file for writing
    open(writerObj);

    %read and write each frame
    for k = 1:readerObj.NumberOfFrames
       img = read(readerObj,k);
       writeVideo(writerObj,img);
    end
    close(writerObj);
end

end

