function [ myVid, playerDetector ] = initSetup( fileName, ext, PRINT_VID )
    
    if(PRINT_VID==1)
        myVid.MAKE_NO_BG_VID=1;
        myVid.MAKE_GD_VID=1;
        myVid.MAKE_HM_VID=1;
        myVid.MAKE_LM_VID=1;
        myVid.MAKE_CLUSTER_VID=1;
        myVid.MAKE_CENTROID_VID=1;
        myVid.MAKE_TRACKS_VID=1;       
        myVid.MAKE_HM_PIC=1;        
    else
        myVid.MAKE_NO_BG_VID=0;
        myVid.MAKE_GD_VID=0;
        myVid.MAKE_HM_VID=0;
        myVid.MAKE_LM_VID=0;
        myVid.MAKE_CLUSTER_VID=0;
        myVid.MAKE_CENTROID_VID=0;
        myVid.MAKE_TRACKS_VID=0;         
        myVid.MAKE_HM_PIC=0;       
    end

    myVid.WRITE_NO_BG=0;
    myVid.SHOW_PLOTS=0;
    
    minBlobArea=300;
    delay=5;   
    myVid.delay=delay;
    
    base_dir=fileName;
    myVid.base_dir=base_dir;
    mkdir(myVid.base_dir);        
    addBackground(fileName,ext,delay);

    if(myVid.WRITE_NO_BG==1)
        mkdir(strcat(base_dir,'/noBG/'));
    end
        
    myVid.inputVid=VideoReader(strcat(base_dir,'/edited.',ext));  
    myVid.FrameRate=myVid.inputVid.FrameRate;
    myVid.totNumOfFrame = myVid.inputVid.NumberOfFrames;
    
    myVid.new=VideoWriter(strcat(base_dir,'/new.',ext),'MPEG-4');
    myVid.new.FrameRate=myVid.FrameRate;
    open(myVid.new);

    if(myVid.MAKE_NO_BG_VID==1)
        myVid.outVid=VideoWriter(strcat(base_dir,'/noBGVid.',ext),'MPEG-4');
        myVid.outVid.FrameRate=myVid.FrameRate;
        open(myVid.outVid);
    end
    if(myVid.MAKE_GD_VID==1)
        myVid.gdVid=VideoWriter(strcat(base_dir,'/gradient.',ext),'MPEG-4');
        myVid.gdVid.FrameRate=myVid.FrameRate;
        open(myVid.gdVid);
    end
    if(myVid.MAKE_HM_VID==1)
        myVid.hmVid=VideoWriter(strcat(base_dir,'/heatMap.',ext),'MPEG-4');
        myVid.hmVid.FrameRate=myVid.FrameRate;
        open(myVid.hmVid);
    end
    if(myVid.MAKE_LM_VID==1)
        myVid.lmVid=VideoWriter(strcat(base_dir,'/localMins.',ext),'MPEG-4');
        myVid.lmVid.FrameRate=myVid.FrameRate;
        open(myVid.lmVid);
    end
    if(myVid.MAKE_CLUSTER_VID==1)
        myVid.clusterVid=VideoWriter(strcat(base_dir,'/clusters.',ext),'MPEG-4');
        myVid.clusterVid.FrameRate=myVid.FrameRate;
        open(myVid.clusterVid);
    end
    if(myVid.MAKE_TRACKS_VID==1)
        myVid.tracksVid1=VideoWriter(strcat(base_dir,'/tracks.',ext),'MPEG-4');
        myVid.tracksVid1.FrameRate=myVid.FrameRate;
        open(myVid.tracksVid1);
        myVid.tracksVid2=VideoWriter(strcat(base_dir,'/tracks2.',ext),'MPEG-4');
        myVid.tracksVid2.FrameRate=myVid.FrameRate;
        open(myVid.tracksVid2);
    end
    if(myVid.MAKE_CENTROID_VID==1)
        myVid.cenVid1=VideoWriter(strcat(base_dir,'/centroid1.',ext),'MPEG-4');
        myVid.cenVid1.FrameRate=myVid.FrameRate;
        open(myVid.cenVid1);

        myVid.cenVid2=VideoWriter(strcat(base_dir,'/centroid2.',ext),'MPEG-4');
        myVid.cenVid2.FrameRate=myVid.FrameRate;
        open(myVid.cenVid2);
    end

    playerDetector.reader = vision.VideoFileReader(strcat(base_dir,'/edited.',ext));
    playerDetector.detector = vision.ForegroundDetector('NumGaussians', 3, ...
        'NumTrainingFrames', 50, 'MinimumBackgroundRatio', 0.7);
    playerDetector.blobAnalyser = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
        'AreaOutputPort', true, 'CentroidOutputPort', true, ...
        'MinimumBlobArea', minBlobArea); %, 'MaximumBlobArea', 150


end

