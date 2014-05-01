function [ base_dir ] = phase1( fileName, ext , numOfClusters, myVid, playerDetector  )

warning('off','all');

%myVid.SHOW_PLOTS=1; %OVERRIDE!

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
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] processing frame -> ',num2str(frameCount)));
    frame = playerDetector.reader.step();
    
    % Detect foreground.
    mask = playerDetector.detector.step(frame);
    % Apply morphological operations to remove noise and fill in holes.
    mask = imopen(mask, strel('rectangle', [3,3]));
    mask = imclose(mask, strel('rectangle', [15, 15]));
    mask = imfill(mask, 'holes');
    
    M=max(max(mask));
    if(M==0)
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] skipping frame -> ',num2str(frameCount)));
        continue;
    end
    
    writeVideo(myVid.new,frame);
    
    fgImg(:,:,1)=double(frame(:,:,1).*mask);
    fgImg(:,:,2)=double(frame(:,:,2).*mask);
    fgImg(:,:,3)=double(frame(:,:,3).*mask);
    
    imwrite(fgImg,strcat(hostName,'_temp.jpg'));
    img_real = imread(strcat(hostName,'_temp.jpg'));
    img_tmp = double(imread(strcat(hostName,'_temp.jpg'))); %load in the image and convert to double too allow for computations on the image
    img = img_tmp(:,:,1); %reduce to just the first dimension, we don't care about color (rgb) values here.
    
    if(myVid.WRITE_NO_BG==1 && frameCount>delay)
        imwrite(fgImg,strcat(base_dir,'/noBG/',num2str(frameCount-delay),'.jpg'));
    end
    if(myVid.MAKE_NO_BG_VID==1 && frameCount>delay)
        writeVideo(myVid.outVid,fgImg);
    end
    
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] ... building blob.'));
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
        saveas(f1,strcat(hostName,'_temp.jpg'));
        tempI=imread(strcat(hostName,'_temp.jpg'));
        writeVideo(myVid.gdVid,tempI);
        delete(strcat(hostName,'_temp.jpg'));
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
        saveas(f15,strcat(hostName,'_temp.jpg'));
        tempI=imread(strcat(hostName,'_temp.jpg'));
        writeVideo(myVid.hmVid,tempI);
        delete(strcat(hostName,'_temp.jpg'));
        close(f15);
    end
    
    %threshold the image to blobs only: you'll need to decide what your
    %threshold level is..you can use your eyes or a histogram :P
    %blob_ori=blob_img;
    
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
        saveas(f2,strcat(hostName,'_temp.jpg'));
        tempI=imread(strcat(hostName,'_temp.jpg'));
        writeVideo(myVid.lmVid,tempI);
        delete(strcat(hostName,'_temp.jpg'));
        close(f2);
    end
    
    %now we have an image of hills and valleys..some are distinct, some
    %overlap..but you can still see the peak...most of the time.
    %use this GREAT 2-d local max/min finder
    %http://www.mathworks.com/matlabcentral/fileexchange/12275-extrema-m-extrema2-m
    %it find the blob peak indices for this video, there should be ~11
    
    goodFrame=goodFrame+1;
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] ... finding extemas.'));
    %addpath(LIB_PATH);
    [zmax,imax,zmin,imin] = extrema2(blob_img);
    [X{goodFrame},Y{goodFrame}] = ind2sub(size(blob_img),imax);
    %rmpath(LIB_PATH);
    %for plotting
    %%{
    clf
    % % %     subplot(211);
    % % %     imagesc(blob_img)
    % % %         axis off
    % % %     subplot(212)
    
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] ... finding clusters.'));
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
        saveas(f3,strcat(hostName,'_temp.jpg'));
        tempI=imread(strcat(hostName,'_temp.jpg'));
        writeVideo(myVid.clusterVid,tempI);
        delete(strcat(hostName,'_temp.jpg'));
        
        plot(ctrs(:,1),ctrs(:,2),'yx',...
            'MarkerSize',12,'LineWidth',2)
        plot(ctrs(:,1),ctrs(:,2),'yo',...
            'MarkerSize',12,'LineWidth',2)
        
        plot(new_ctrs(:,1),new_ctrs(:,2),'gx',...
            'MarkerSize',12,'LineWidth',2)
        plot(new_ctrs(:,1),new_ctrs(:,2),'go',...
            'MarkerSize',12,'LineWidth',2)
        
        if(myVid.MAKE_CENTROID_VID==1)
            saveas(f3,strcat(hostName,'_temp.jpg'));
            tempI=imread(strcat(hostName,'_temp.jpg'));
            writeVideo(myVid.cenVid1,tempI);
            delete(strcat(hostName,'_temp.jpg'));
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
        saveas(f4,strcat(hostName,'_temp.jpg'));
        tempI=imread(strcat(hostName,'_temp.jpg'));
        writeVideo(myVid.cenVid2,tempI);
        delete(strcat(hostName,'_temp.jpg'));
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
        saveas(f5,strcat(hostName,'_temp.jpg'));
        tempI=imread(strcat(hostName,'_temp.jpg'));
        writeVideo(myVid.tracksVid1,tempI);
        if(frameCount==myVid.totNumOfFrame)
            copyfile(strcat(hostName,'_temp.jpg'),strcat(base_dir,...
                '/tracksTotal.jpg'));
        end
        delete(strcat(hostName,'_temp.jpg'));
        
        close(f5);
        f55=figure();
        if(myVid.SHOW_PLOTS==0)
            set(f5,'visible','off');
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
        saveas(f55,strcat(hostName,'_temp.jpg'));
        tempI=imread(strcat(hostName,'_temp.jpg'));
        writeVideo(myVid.tracksVid2,tempI);
        if(frameCount==myVid.totNumOfFrame)
            copyfile(strcat(hostName,'_temp.jpg'),strcat(base_dir, ...
                '/tracksTotal2.jpg'));
        end
        delete(strcat(hostName,'_temp.jpg'));
        close(f55);
    end
end
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
    %   oneFrame=im2frame(zbuffer_cdata(f6));
    %   oneImg=(oneFrame.cdata);
    %     imwrite(oneImg,strcat(base_dir,'/heatMapTotal.jpg'));
    saveas(f6,strcat(base_dir,'/heatMapTotal.jpg'));
    close(f6);
end

dataDir=strcat(base_dir,'/data');
mkdir(dataDir);
copyfile('index.html',base_dir);
save(strcat(dataDir,'/phase1_data_others.mat'),'centerAll','newCenterAll','normalHM','X','Y','X_new','Y_new');
save(strcat(dataDir,'/phase1_data.mat'),'Y_new','X_new');
end

