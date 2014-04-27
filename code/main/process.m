    function [] = process( fileName, ext ,PRINT_VID,LIB_PATH)
    
    warning('off','all');
            
    hostName=getHostName();
    if(PRINT_VID==1)
        MAKE_NO_BG_VID=1;
        MAKE_GD_VID=1;
        MAKE_HM_VID=1;
        MAKE_LM_VID=1;
        MAKE_CLUSTER_VID=1;
        MAKE_CENTROID_VID=1;
        MAKE_TRACKS_VID=1;        
    else
        MAKE_NO_BG_VID=0;
        MAKE_GD_VID=0;
        MAKE_HM_VID=0;
        MAKE_LM_VID=0;
        MAKE_CLUSTER_VID=0;
        MAKE_CENTROID_VID=0;
        MAKE_TRACKS_VID=0;        
    end
    
    WRITE_NO_BG=0;
    SHOW_PLOTS=1;
    
%     base_dir=strcat(fileName,'_data/');
    base_dir=fileName;
    minBlobArea=300;
    delay=5;   
    
    THRESHOLD=-1.5;
    ishMap=0;
    initialize();
    
    frameCount=0;
    centerAll=[];
    newCenterAll=[];
    i=0;
    
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
        %playerDetector.blobAnalyser
        obj=playerDetector.blobAnalyser;
        
        [area, centroids, bboxes] = obj.step(mask);
        
%         
%         % Perform blob analysis to find connected components.
%         [~, centroids, bboxes] = obj.blobAnalyser.step(mask);
        
        fgImg(:,:,1)=double(frame(:,:,1).*mask);
        fgImg(:,:,2)=double(frame(:,:,2).*mask);
        fgImg(:,:,3)=double(frame(:,:,3).*mask);
        
        imwrite(fgImg,strcat(hostName,'_temp.jpg'));
        img_real = imread(strcat(hostName,'_temp.jpg'));
        img_tmp = double(imread(strcat(hostName,'_temp.jpg'))); %load in the image and convert to double too allow for computations on the image
        img = img_tmp(:,:,1); %reduce to just the first dimension, we don't care about color (rgb) values here.

        if(WRITE_NO_BG==1 && frameCount>delay)
            imwrite(fgImg,strcat(fileName,'_data/noBG/',num2str(frameCount-delay),'.jpg'));
        end
        if(MAKE_NO_BG_VID==1 && frameCount>delay)
            writeVideo(outVid,fgImg);
        end     
               
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] ... building blob.'));
        blob_img = conv2(img,h,'same');
        
        if(MAKE_GD_VID==1)
            f1 = figure();
            if(SHOW_PLOTS==0)
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
            writeVideo(gdVid,tempI);
            delete(strcat(hostName,'_temp.jpg'));
            close(f1);
        end
        
        if(ishMap==0)
            hMap=blob_img;
            ishMap=1;
        else
            hMap=hMap+blob_img;
        end
        
        if(MAKE_HM_VID==1)            
            f15 = figure();
            if(SHOW_PLOTS==0)
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
            writeVideo(hmVid,tempI);
            delete(strcat(hostName,'_temp.jpg'));
            close(f15);
        end

        %threshold the image to blobs only: you'll need to decide what your
        %threshold level is..you can use your eyes or a histogram :P
        %blob_ori=blob_img;    
        
        %idx = find(blob_img >-1.5);
        idx = find(blob_img > THRESHOLD);
        blob_img(idx) = nan ;

        if(MAKE_LM_VID==1)
            f2 = figure();        
            if(SHOW_PLOTS==0)
                set(f2,'visible','off');
            end
            imagesc(blob_img)
            colorbar
            saveas(f2,strcat(hostName,'_temp.jpg'));
            tempI=imread(strcat(hostName,'_temp.jpg'));
            writeVideo(lmVid,tempI);
            delete(strcat(hostName,'_temp.jpg'));
            close(f2);
        end

        %now we have an image of hills and valleys..some are distinct, some
        %overlap..but you can still see the peak...most of the time.
        %use this GREAT 2-d local max/min finder
        %http://www.mathworks.com/matlabcentral/fileexchange/12275-extrema-m-extrema2-m
        %it find the blob peak indices for this video, there should be ~11

        i=i+1;
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] ... finding extemas.'));
        addpath(LIB_PATH);
        [zmax,imax,zmin,imin] = extrema2(blob_img);
        [X{i},Y{i}] = ind2sub(size(blob_img),imax);
        rmpath(LIB_PATH);
        %for plotting
        %%{
        clf
        % % %     subplot(211);
        % % %     imagesc(blob_img)
        % % %         axis off
        % % %     subplot(212)

        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] ... finding clusters.'));
        [ idx,ctrs ] = getCentroids( Y{i}, X{i}, 22 );        
        new_ctrs = verifyClusters(ctrs,35);      
        centerAll=[centerAll;ctrs];
        newCenterAll=[newCenterAll;new_ctrs];
        
        if(exist('newCenterEnd','var')==0 && frameCount>1)            
            newCenterEnd(frameCount-1)=1;
        end
        newCenterEnd(frameCount)=length(newCenterAll);

        if(MAKE_CLUSTER_VID==1)
            f3=figure();
            if(SHOW_PLOTS==0)
                set(f3,'visible','off');
            end
            imshow(img_real)
            hold on
            for j = 1:length(X{i})
                plot(Y{i}(j),X{i}(j),'or')
            end
            axis off
            saveas(f3,strcat(hostName,'_temp.jpg'));
            tempI=imread(strcat(hostName,'_temp.jpg'));
            writeVideo(clusterVid,tempI);
            delete(strcat(hostName,'_temp.jpg'));

% % % % % % %             plot(ctrs(:,1),ctrs(:,2),'yx',...
% % % % % % %                 'MarkerSize',12,'LineWidth',2)
% % % % % % %             plot(ctrs(:,1),ctrs(:,2),'yo',...
% % % % % % %                 'MarkerSize',12,'LineWidth',2)
            
            
            plot(new_ctrs(:,1),new_ctrs(:,2),'gx',...
                'MarkerSize',12,'LineWidth',2)
            plot(new_ctrs(:,1),new_ctrs(:,2),'go',...
                'MarkerSize',12,'LineWidth',2)

            if(MAKE_CENTROID_VID==1)
                saveas(f3,strcat(hostName,'_temp.jpg'));
                tempI=imread(strcat(hostName,'_temp.jpg'));
                writeVideo(cenVid1,tempI);
                delete(strcat(hostName,'_temp.jpg'));
            end
            
            
            plot(centroids(:,1),centroids(:,2),'gx',...
                'MarkerSize',6,'LineWidth',3)
            plot(centroids(:,1),centroids(:,2),'go',...
                'MarkerSize',6,'LineWidth',3)

            close(f3);
        end

        if(MAKE_CENTROID_VID==1)
            f4=figure();
            if(SHOW_PLOTS==0)
                set(f4,'visible','off');
            end
            imshow(img_real)
            hold on

% % % % % % %             plot(ctrs(:,1),ctrs(:,2),'yx',...
% % % % % % %                 'MarkerSize',12,'LineWidth',2)
% % % % % % %             plot(ctrs(:,1),ctrs(:,2),'yo',...
% % % % % % %                 'MarkerSize',12,'LineWidth',2)
            
            
            plot(new_ctrs(:,1),new_ctrs(:,2),'gx',...
                'MarkerSize',12,'LineWidth',2)
            plot(new_ctrs(:,1),new_ctrs(:,2),'go',...
                'MarkerSize',12,'LineWidth',2)
            
            hold off;
            saveas(f4,strcat(hostName,'_temp.jpg'));
            tempI=imread(strcat(hostName,'_temp.jpg'));
            writeVideo(cenVid2,tempI);
            
%             
%             plot(centroids(:,1),centroids(:,2),'bx',...
%                 'MarkerSize',6,'LineWidth',3)
%             plot(centroids(:,1),centroids(:,2),'bo',...
%                 'MarkerSize',6,'LineWidth',3)
            
            delete(strcat(hostName,'_temp.jpg'));
            close(f4);
        end

        if(MAKE_TRACKS_VID==1)
            f5=figure();
            if(SHOW_PLOTS==0)
                set(f5,'visible','off');
            end
            imshow(img_real)
            hold on
            plot(centerAll(:,1),centerAll(:,2),'m.','MarkerSize',4)
            %plot(newCenterAll(:,1),newCenterAll(:,2),'c.','MarkerSize',9)
            for k=1:length(newCenterEnd)-1      
                if(newCenterEnd(k)<1)
                    continue;
                end
                if(newCenterEnd(k+1)==0)
                    continue;
                end
                k
                plotColor=(1- (newCenterEnd(k+1)/totNumOfFrame))
                %theColor=[ plotColor 255 255];
                theColor=[ plotColor 1 1]';
                plot( newCenterAll(newCenterEnd(k):newCenterEnd(k+1),1) , newCenterAll(newCenterEnd(k):newCenterEnd(k+1),2),'o','MarkerFaceColor', theColor,'MarkerSize',8)              
            end
            %plot(newCenterAll(:,1),newCenterAll(:,2),'o','MarkerFaceColor', theColor,'MarkerSize',4)
            saveas(f5,strcat(hostName,'_temp.jpg'));
            tempI=imread(strcat(hostName,'_temp.jpg'));
            writeVideo(tracksVid,tempI);
            delete(strcat(hostName,'_temp.jpg'));
            close(f5);
        end       
    end
    
    M=max(max(hMap));
    m=min(min(hMap));    
    normalHM = (hMap-m)/(M-m);
    
    f6=figure();
    if(SHOW_PLOTS==0)
        set(f6,'visible','off');
    end
    imagesc(normalHM)
    colormap(jet)
    colorbar    
    saveas(f6,strcat(base_dir,'/heatMapTotal.jpg'));
    close(f6);
    
%     f7=figure();
%     if(SHOW_PLOTS==0)
%         set(f7,'visible','off');
%     end
%     imshow(zeros(size(img_real,1),size(img_real,2),3))
%     plot(centerAll(:,1),centerAll(:,2),'m.')
%     saveas(f7,strcat(base_dir,'/steps.jpg'));
%     close(f7);
    
    closeVids();
    
    dataDir=strcat(base_dir,'/data');
    mkdir(dataDir);
    
    save(strcat(dataDir,'/centers.mat'),'centerAll');
    save(strcat(dataDir,'/centers2.mat'),'newCenterAll');
    save(strcat(dataDir,'/heatMap.mat'),'normalHM');  
    save(strcat(dataDir,'/X.mat'),'X'); 
    save(strcat(dataDir,'/Y.mat'),'Y');   
    save(strcat(dataDir,'/players_detected.mat'),  'X','Y')
      
    copyfile('index.html',base_dir);
    movefile(strcat(base_dir,'.',ext),strcat(base_dir,'/original.',ext));
    

    %save it!
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Proccessing done on :',fileName));
    
    
    function initialize()
        mkdir(base_dir);        
        addBackground(fileName,ext,delay);

        if(WRITE_NO_BG==1)
            mkdir(strcat(base_dir,'/noBG/'));
        end

        
        inputVid=VideoReader(strcat(base_dir,'/edited.',ext));
        
        totNumOfFrame = inputVid.NumberOfFrames;
        
        if(MAKE_NO_BG_VID==1)
            outVid=VideoWriter(strcat(base_dir,'/noBGVid.',ext),'MPEG-4');
            outVid.FrameRate=inputVid.FrameRate;
            open(outVid);
        end


        if(MAKE_GD_VID==1)
            gdVid=VideoWriter(strcat(base_dir,'/gradient.',ext),'MPEG-4');
            gdVid.FrameRate=inputVid.FrameRate;
            open(gdVid);
        end

        if(MAKE_HM_VID==1)
            hmVid=VideoWriter(strcat(base_dir,'/heatMap.',ext),'MPEG-4');
            hmVid.FrameRate=inputVid.FrameRate;
            open(hmVid);
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
        
        playerDetector.reader = vision.VideoFileReader(strcat(base_dir,'/edited.',ext));
        playerDetector.detector = vision.ForegroundDetector('NumGaussians', 3, ...
            'NumTrainingFrames', 50, 'MinimumBackgroundRatio', 0.7);
        playerDetector.blobAnalyser = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
            'AreaOutputPort', true, 'CentroidOutputPort', true, ...
            'MinimumBlobArea', minBlobArea); %, 'MaximumBlobArea', 150
        
        hsizeh = 150;  %you will need to iterative test these values two values. the bigger they are, the larger the blob they will find!
        sigmah =6;   %
        h = fspecial('log', hsizeh, sigmah);
        % iteratively (frame by frame) find flies and save the X Y coordinates!
% % % %         X = cell(1,length(imgList)); %detection X coordinate indice
% % % %         Y = cell(1,length(imgList));  %detection Y coordinate indice
        
    end
    
    function closeVids()
        if(MAKE_NO_BG_VID==1)
            close(outVid);
        end
        if(MAKE_GD_VID==1)
            close(gdVid);
        end

        if(MAKE_HM_VID==1)
            close(hmVid);
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
    end

end

