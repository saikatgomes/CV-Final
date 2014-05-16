%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Saikat R. Gomes
%% Email: saikat@cs.wisc.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ ] = phase1(numOfClusters, myVid, playerDetector  )

warning('off','all');

base_dir=myVid.base_dir;
delay=myVid.delay;
hostName=getHostName();
THRESHOLD=-1.5;
ishMap=0;
frameCount=0;
centerAll=[];
newCenterAll=[];
goodFrame=0;
hsizeh = 150;
sigmah =6;
h = fspecial('log', hsizeh, sigmah);

while ~isDone(playerDetector.reader)
    
    frameCount=frameCount+1;
    frame = playerDetector.reader.step();
    
    % Detect foreground.
    mask = playerDetector.detector.step(frame);
    % Apply morphological operations to remove noise and fill in holes.
    mask = imopen(mask, strel('rectangle', [3,3]));
    mask = imclose(mask, strel('rectangle', [15, 15]));
    mask = imfill(mask, 'holes');
    
    M=max(max(mask));
    if(M==0)
%         display(strcat(datestr(now,'HH:MM:SS'),' [INFO] skipping frame -> ',num2str(frameCount)));
        continue;
    end
    
    writeVideo(myVid.new,frame);
    
    fgImg(:,:,1)=double(frame(:,:,1).*mask);
    fgImg(:,:,2)=double(frame(:,:,2).*mask);
    fgImg(:,:,3)=double(frame(:,:,3).*mask);
    
    imwrite(fgImg,strcat(hostName,'_temp.jpg'));
    img_real = imread(strcat(hostName,'_temp.jpg'));
    %load in the image and convert to double too allow for computations on the image
    img_tmp = double(imread(strcat(hostName,'_temp.jpg'))); 
    %reduce to just the first dimension, we don't care about color (rgb) values here.
    img = img_tmp(:,:,1); 
    
    if(myVid.WRITE_NO_BG==1 && frameCount>delay)
        imwrite(fgImg,strcat(base_dir,'/noBG/',num2str(frameCount-delay),'.jpg'));
    end
    if(myVid.MAKE_NO_BG_VID==1 && frameCount>delay)
        writeVideo(myVid.outVid,fgImg);
    end
    
    %display(strcat(datestr(now,'HH:MM:SS'),' [INFO] ... building blob.'));
    blob_img = conv2(img,h,'same');
    
    if(myVid.MAKE_GD_VID==1)
        f1 = figure();
        if(myVid.SHOW_PLOTS==0)
            set(f1,'visible','off');
        end
        imagesc(blob_img)
        colormap(jet)
        colorbar
        M=max(max(blob_img));
        m=min(min(blob_img));
        normalHM = (blob_img-m)/(M-m);
        imagesc(normalHM)
        colormap(jet)
        colorbar
        writeVideo(myVid.gdVid,getframe(f1));
        close(f1);
    end
    
    if(ishMap==0)
        hMap=blob_img;
        ishMap=1;
    else
        hMap=hMap+blob_img;
    end
    
    if(myVid.MAKE_HM_VID==1)
        f15 = figure();
        if(myVid.SHOW_PLOTS==0)
            set(f15,'visible','off');
        end
        imagesc(hMap)
        colormap(jet)
        colorbar
        M=max(max(hMap));
        m=min(min(hMap));
        normalHM = (hMap-m)/(M-m);
        imagesc(normalHM)
        colormap(jet)
        colorbar
        writeVideo(myVid.hmVid,getframe(f15));
        close(f15);
    end
    
    %threshold the image to blobs only:    
    %idx = find(blob_img >-1.5);
    idx = find(blob_img > THRESHOLD);
    blob_img(idx) = nan ;
    
    if(myVid.MAKE_LM_VID==1)
        f2 = figure();
        if(myVid.SHOW_PLOTS==0)
            set(f2,'visible','off');
        end
        imagesc(blob_img)
        colorbar
        writeVideo(myVid.lmVid,getframe(f2));
        close(f2);
    end
    
    %http://www.mathworks.com/matlabcentral/fileexchange/12275-extrema-m-extrema2-m    
    goodFrame=goodFrame+1;
%     display(strcat(datestr(now,'HH:MM:SS'),' [INFO] ... finding extemas.'));
    [zmax,imax,zmin,imin] = extrema2(blob_img);
    [X{goodFrame},Y{goodFrame}] = ind2sub(size(blob_img),imax);
    clf
    
%     display(strcat(datestr(now,'HH:MM:SS'),' [INFO] ... finding clusters.'));
    [ idx,ctrs  ,SUMD, DistMat ] = getCentroids( Y{goodFrame}, X{goodFrame},numOfClusters );
    new_ctrs = verifyClusters(ctrs,35);
    centerAll=[centerAll;ctrs];
    newCenterAll=[newCenterAll;new_ctrs];
    X_new{goodFrame}=new_ctrs(:,1);
    Y_new{goodFrame}=new_ctrs(:,2);
    
    if(exist('newCenterEnd','var')==0 && frameCount>1)
        newCenterEnd(frameCount-1)=1;
    end
    newCenterEnd(frameCount)=length(newCenterAll);
    
    if(myVid.MAKE_CLUSTER_VID==1)
        f3=figure();
        if(myVid.SHOW_PLOTS==0)
            set(f3,'visible','off');
        end
        imshow(img_real)
        hold on
        for j = 1:length(X{goodFrame})
            plot(Y{goodFrame}(j),X{goodFrame}(j),'or')
        end
        axis off
        writeVideo(myVid.clusterVid,getframe(f3));
        
        plot(ctrs(:,1),ctrs(:,2),'yx',...
            'MarkerSize',12,'LineWidth',2)
        plot(ctrs(:,1),ctrs(:,2),'yo',...
            'MarkerSize',12,'LineWidth',2)
        
        plot(new_ctrs(:,1),new_ctrs(:,2),'gx',...
            'MarkerSize',12,'LineWidth',2)
        plot(new_ctrs(:,1),new_ctrs(:,2),'go',...
            'MarkerSize',12,'LineWidth',2)
        
        if(myVid.MAKE_CENTROID_VID==1)
            writeVideo(myVid.cenVid1,getframe(f3));
        end
        close(f3);
    end
    
    if(myVid.MAKE_CENTROID_VID==1)
        f4=figure();
        if(myVid.SHOW_PLOTS==0)
            set(f4,'visible','off');
        end
        imshow(img_real)
        hold on
        
        plot(new_ctrs(:,1),new_ctrs(:,2),'gx',...
            'MarkerSize',12,'LineWidth',2)
        plot(new_ctrs(:,1),new_ctrs(:,2),'go',...
            'MarkerSize',12,'LineWidth',2)
        
        hold off;
        writeVideo(myVid.cenVid2,getframe(f4));
        close(f4);
    end
    
    if(myVid.MAKE_TRACKS_VID==1)
        f5=figure();
        if(myVid.SHOW_PLOTS==0)
            set(f5,'visible','off');
        end
        imshow(img_real)
        hold on
        plot(centerAll(:,1),centerAll(:,2),'m.','MarkerSize',4)
        for k=1:length(newCenterEnd)-1
            if(newCenterEnd(k)<1)
                continue;
            end
            if(newCenterEnd(k+1)==0)
                continue;
            end
            half=myVid.totNumOfFrame/2;
            if (k<half)
                R=(1- (k/half));
                G=1;
            else
                R=0;
                G=(1- ((k-half)/half));
            end
            theColor=[ R G 1];
            plot( newCenterAll(newCenterEnd(k):newCenterEnd(k+1),1) , ...
                newCenterAll(newCenterEnd(k):newCenterEnd(k+1),2),'o', ...
                'MarkerFaceColor', theColor,'MarkerEdgeColor','none',...
                'MarkerSize',2)
        end
        writeVideo(myVid.tracksVid1,getframe(f5));
        if(frameCount==myVid.totNumOfFrame)
            saveas(f5,strcat(base_dir,'/tracksTotal.jpg'));
        end
        
        close(f5);
        f55=figure();
        if(myVid.SHOW_PLOTS==0)
            set(f55,'visible','off');
        end
        imshow(frame)
        hold on
        plot(centerAll(:,1),centerAll(:,2),'m.','MarkerSize',4)
        for k=1:length(newCenterEnd)-1
            if(newCenterEnd(k)<1)
                continue;
            end
            if(newCenterEnd(k+1)==0)
                continue;
            end
            half=myVid.totNumOfFrame/2;
            if (k<half)
                R=(1- (k/half));
                G=1;
            else
                R=0;
                G=(1- ((k-half)/half));
            end
            theColor=[ R G 1];
            plot( newCenterAll(newCenterEnd(k):newCenterEnd(k+1),1) , ...
                newCenterAll(newCenterEnd(k):newCenterEnd(k+1),2),'o', ...
                'MarkerFaceColor', theColor,'MarkerEdgeColor','none',...
                'MarkerSize',2)
        end
        writeVideo(myVid.tracksVid2,getframe(f55));
        if(frameCount==myVid.totNumOfFrame)
            saveas(f55,strcat(base_dir,'/tracksTotal.jpg'));
        end
        close(f55);
    end
end


close(myVid.new);
    
M=max(max(hMap));
m=min(min(hMap));
normalHM = (hMap-m)/(M-m);

if(myVid.MAKE_HM_PIC==1)
    f6=figure();
    if(myVid.SHOW_PLOTS==0)
        set(f6,'visible','off');
    end
    imagesc(normalHM)
    colormap(jet)
    colorbar
    saveas(f6,strcat(base_dir,'/heatMapTotal.jpg'));
    close(f6);
end

dataDir=strcat(base_dir,'/data');
mkdir(dataDir);
save(strcat(dataDir,'/phase1_data_others.mat'),'centerAll','newCenterAll','normalHM','X','Y','X_new','Y_new');
save(strcat(dataDir,'/phase1_data.mat'),'Y_new','X_new');
end

