
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

%base_dir = 'E:\Dropbox\Student_dave\flies_SD_frames\duplicates_removed\';
%base_dir = 'maddenNew/';
%base_dir = 'packers/';
base_dir = '../data/frames/packers_nobg/';


cd(base_dir);

%% get listing of frames so that you can cycle through them easily.
f_list =  dir('*jpg');
%obj.reader = vision.VideoFileReader('*jpg');


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
X = cell(1,length(f_list)); %detection X coordinate indice
Y = cell(1,length(f_list));  %detection Y coordinate indice


for i = 2:length(f_list)-1
%while ~isDone(obj.reader)img
    display(f_list(i).name);
    img_real = (imread(f_list(i).name)); %just for plottin purposes
    %img_real = (imread(frame.name)); %just for plottin purposes
    img_tmp = double(imread(f_list(i).name)); %load in the image and convert to double too allow for computations on the image
    img = img_tmp(:,:,1); %reduce to just the first dimension, we don't care about color (rgb) values here.
    imshow(int8(img))
% % % %     img = (img > 100);
% % % %     img = (img * 255);
% % % %     imshow(int8(img))
%untitled.jpg % % %     
% % % %                 
% % % %                 img_tmp = double(imread(f_list(i-1).name));
% % % %                 img1 = img_tmp(:,:,1); 
% % % %                 img_tmp = double(imread(f_list(i+1).name));
% % % %                 img2 = img_tmp(:,:,1);
% % % %                 
% % % %     img1 = (img1 > 100);
% % % %     img1 = (img1 * 255);
% % % %     
% % % %     img2 = (img2 > 100);
% % % %     img2 = (img2 * 255);
% % % %                 
% % % %        for x=1:size(img,1)
% % % %             for y=1:size(img,2)
% % % %                 
% % % %                 if(img1(x,y)==img(x,y) && img(x,y)==img2(x,y))
% % % %                     img(x,y)=0;
% % % %                 end    
% % % %                 
% % % %                 
% % % %             end
% % % %        end   
% % % %     imshow(int8(img))
       
       
    %do the blob filter!
    blob_img = conv2(img,h,'same');
    %blob_img = conv2(img,h,'valid');
    imagesc(blob_img)
    colormap(jet)
%     imagesc(blob_img2)
%     colormap(jet)
    
% % % %        for x=1:size(blob_img,1)
% % % %             for y=1:size(blob_img,2)
% % % %                 
% % % %                 if(blob_img1(x,y)==blob_img(x,y) && blob_img(x,y)==blob_img2(x,y))
% % % %                     blob_img(x,y)=0;
% % % %                 end                   
% % % %             end
% % % %        end   
% % % %     
    
% % % %     colormap(jet)
% % % %     imagesc(blob_img)
% % % %     colormap(jet)
    
    %threshold the image to blobs only: you'll need to decide what your
    %threshold level is..you can use your eyes or a histogram :P
    blob_ori=blob_img;
    
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
    
    %now we have an image of hills and valleys..some are distinct, some
    %overlap..but you can still see the peak...most of the time.
    %use this GREAT 2-d local max/min finder 
    %http://www.mathworks.com/matlabcentral/fileexchange/12275-extrema-m-extrema2-m
    %it find the blob peak indices for this video, there should be ~11
    [zmax,imax,zmin,imin] = extrema2(blob_img);
    [X{i},Y{i}] = ind2sub(size(blob_img),imax);
    
    %for plotting
    %%{
    clf
% % %     subplot(211);   
% % %     imagesc(blob_img)
% % %         axis off
% % %     subplot(212)
    imshow(img_real)
    hold on
    for j = 1:length(X{i})
        plot(Y{i}(j),X{i}(j),'or')
    end
    axis off
    pause(.1);
    %}
    
    
    i
end

%save it!
save('raw_fly_detections.mat',  'X','Y')

%now, move on to the multi object tracking code!






