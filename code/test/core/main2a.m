
%Student Dave's tutorial on:  Finding flies! lol :P
%this code uses blob analysis to find
%Copyright Student Dave's Tutorials 2013
%if you would like to use this code, please feel free, just remember to
%reference and tell your friends! :)
%requires matlabs image processing toolbox

%you can get the fly footage here!  (notably, the free version is pretty low quality so
%tracking will have some issues ..you gotta tweaky it :-/
%http://footage.shutterstock.com/clip-978808-stock-footage-swarm-of-flies-buzzing-with-matte-for-easy-compositing-into-your-own-scenes.html

%What the heck does this code do!?
%the code tries to find the flies..but not just when they are very visual,
%but even when the are partially overlapping..how?!
% 1) Averaged background subtraction
% 2) Noise reduction via image smoothing using 2-d gaussian filter.
% 3) Threshold and point detection in binary image.

clear all;
close all;
set(0,'DefaultFigureWindowStyle','docked') %dock the figures..just a personal preference you don't need this.

% MAKE_GD_VID=1;
% MAKE_LM_VID=1;
% MAKE_CLUSTER_VID=1;
% MAKE_CENTROID_VID=1;
% MAKE_TRACKS_VID=1;

MAKE_GD_VID=0;
MAKE_LM_VID=0;
MAKE_CLUSTER_VID=0;
MAKE_CENTROID_VID=0;
MAKE_TRACKS_VID=1;

ext='mp4';
centerAll=[];
% centerAll=double(ones(1,1));

base_dir = '../data/packers_A/1_data';
read_dir = strcat(base_dir,'/noBG');

    inputVid=VideoReader(strcat(base_dir,'/edited.',ext));

if(MAKE_GD_VID==1)
    gdVid=VideoWriter(strcat(base_dir,'/gradient.',ext),'MPEG-4');
    gdVid.FrameRate=inputVid.FrameRate;
    open(gdVid);
end

if(MAKE_LM_VID==1)
    lmVid=VideoWriter(strcat(base_dir,'/localMins.',ext),'MPEG-4');
    lmVid.FrameRate=inputVid.FrameRate;
    open(lmVid);
end

if(MAKE_CLUSTER_VID==1)
    clusterVid=VideoWriter(strcat(base_dir,'/clusters.',ext),'MPEG-4');
    clusterVid.FrameRate=inputVid.FrameRate;
    open(clusterVid);
end


if(MAKE_TRACKS_VID==1)
    tracksVid=VideoWriter(strcat(base_dir,'/tracks.',ext),'MPEG-4');
    tracksVid.FrameRate=inputVid.FrameRate;
    open(tracksVid);
end

if(MAKE_CENTROID_VID==1)
    cenVid1=VideoWriter(strcat(base_dir,'/centroid1.',ext),'MPEG-4');
    cenVid1.FrameRate=inputVid.FrameRate;
    open(cenVid1);
    
    cenVid2=VideoWriter(strcat(base_dir,'/centroid2.',ext),'MPEG-4');
    cenVid2.FrameRate=inputVid.FrameRate;
    open(cenVid2);
end

%% get listing of frames so that you can cycle through them easily.
fullfile(read_dir,'/*jpg')
imageNames  =  dir(fullfile(read_dir,'/*jpg'));
imageNames  = {imageNames.name}';
imageStrings = regexp([imageNames{:}],'(\d*)','match');
imageNumbers = str2double(imageStrings);
[~,sortedIndices] = sort(imageNumbers);
imgList = imageNames(sortedIndices);

%% initialize gaussian filter

%using fspecial, we will make a laplacian of a gaussian (LOG) template to convolve (pass over)
%over the image to find blobs!

hsizeh = 150  %you will need to iterative test these values two values. the bigger they are, the larger the blob they will find!
sigmah =6   %
h = fspecial('log', hsizeh, sigmah)
% % % % subplot(121); imagesc(h)
% % % % subplot(122); mesh(h)
% % % % colormap(jet)


%frame = obj.reader.step();

%% iteratively (frame by frame) find flies and save the X Y coordinates!
X = cell(1,length(imgList)); %detection X coordinate indice
Y = cell(1,length(imgList));  %detection Y coordinate indice

%cd(base_dir);

for i = 1:length(imgList)
    
    readImg=strcat(read_dir,'/',imgList{i});
    %display(readImg);
    img_real = imread(readImg); %just for plottin purposes
    img_tmp = double(imread(readImg)); %load in the image and convert to double too allow for computations on the image
    img = img_tmp(:,:,1); %reduce to just the first dimension, we don't care about color (rgb) values here.
    %imshow(int8(img))
    
    %do the blob filter!
   
    f1 = figure();
    set(f1,'visible','off');
    blob_img = conv2(img,h,'same');    
    imagesc(blob_img)
    colormap(jet)
    
    if(MAKE_GD_VID==1)    
        saveas(f1,'temp.jpg');
        tempI=imread('temp.jpg');
        writeVideo(gdVid,tempI);
        delete('temp.jpg');
    end
    close(f1);
    
    %threshold the image to blobs only: you'll need to decide what your
    %threshold level is..you can use your eyes or a histogram :P
    blob_ori=blob_img;
    
    f2 = figure();
    set(f2,'visible','off');
    idx = find(blob_ori >-0.5);
    blob_img(idx) = nan ;
    imagesc(blob_img)
    
    blob_img=blob_ori;
    
    idx = find(blob_ori >-1);
    blob_img(idx) = nan ;
    imagesc(blob_img)
    
    blob_img=blob_ori;
    
    idx = find(blob_ori >-1.5);
    blob_img(idx) = nan ;
    imagesc(blob_img)
    
    
    if(MAKE_LM_VID==1)    
        saveas(f2,'temp.jpg');
        tempI=imread('temp.jpg');
        writeVideo(lmVid,tempI);
        delete('temp.jpg');
    end
    close(f2);
    
    %now we have an image of hills and valleys..some are distinct, some
    %overlap..but you can still see the peak...most of the time.
    %use this GREAT 2-d local max/min finder
    %http://www.mathworks.com/matlabcentral/fileexchange/12275-extrema-m-extrema2-m
    %it find the blob peak indices for this video, there should be ~11
    addpath('../lib/extrema');
    [zmax,imax,zmin,imin] = extrema2(blob_img);
    [X{i},Y{i}] = ind2sub(size(blob_img),imax);
    rmpath('../lib/extrema');
    %for plotting
    %%{
    clf
    % % %     subplot(211);
    % % %     imagesc(blob_img)
    % % %         axis off
    % % %     subplot(212)
    f3=figure();
    set(f3,'visible','off');
    imshow(img_real)
    hold on
    for j = 1:length(X{i})
        plot(Y{i}(j),X{i}(j),'or')
    end
    axis off
    
    if(MAKE_CLUSTER_VID==1)    
        saveas(f3,'temp.jpg');
        tempI=imread('temp.jpg');
        writeVideo(clusterVid,tempI);
        delete('temp.jpg');
    end    
    
    [ idx,ctrs ] = getCentroids( Y{i}, X{i}, 11 );    
    
        centerAll=[centerAll;ctrs];
%     if(ISEMPTY(centerAll)==1)
%         centerAll=ctrs;
%     else
%         centerAll=[centerAll;ctrs];
%     end
    
    plot(ctrs(:,1),ctrs(:,2),'yx',...
        'MarkerSize',12,'LineWidth',2)
    plot(ctrs(:,1),ctrs(:,2),'yo',...
        'MarkerSize',12,'LineWidth',2)
    
    if(MAKE_CENTROID_VID==1)    
        saveas(f3,'temp.jpg');
        tempI=imread('temp.jpg');
        writeVideo(cenVid1,tempI);
        delete('temp.jpg');
    end    
        
    close(f3);
    
    if(MAKE_CENTROID_VID==1)
        f4=figure();
        set(f4,'visible','off');
        imshow(img_real)
        hold on
        plot(ctrs(:,1),ctrs(:,2),'yx',...
            'MarkerSize',12,'LineWidth',2)
        plot(ctrs(:,1),ctrs(:,2),'yo',...
            'MarkerSize',12,'LineWidth',2)
        hold off;
        saveas(f4,'temp.jpg');
        tempI=imread('temp.jpg');
        writeVideo(cenVid2,tempI);
        delete('temp.jpg');
        close(f4);
    end
    
    
    if(MAKE_TRACKS_VID==1)
        
        f5=figure();
        set(f5,'visible','off');
        imshow(img_real)
        hold on
        plot(centerAll(:,1),centerAll(:,2),'m.')
        saveas(f5,'temp.jpg');
        tempI=imread('temp.jpg');
        writeVideo(tracksVid,tempI);
        delete('temp.jpg');
        close(f5);
    end

    
    %pause(.1);
    %}
    
    
    i
end


if(MAKE_GD_VID==1)
    close(gdVid);
end

if(MAKE_LM_VID==1)
    close(lmVid);
end

if(MAKE_CLUSTER_VID==1)
    close(clusterVid);
end

if(MAKE_CENTROID_VID==1)
     close(cenVid1);
     close(cenVid2);
end

if(MAKE_TRACKS_VID==1)
    close(tracksVid);
end

%save it!
save('raw_fly_detections.mat',  'X','Y')

%now, move on to the multi object tracking code!






