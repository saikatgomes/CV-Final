function [] = process( fileName, ext ,PRINT_VID, numOfClusters,...
                        overwriteP1, overwriteP2, overwriteP3)
    warning('off','all');
  
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Start processing :',fileName)); 
    addpath('helper/');
    [ myVid, playerDetector ] = initSetup( fileName, ext, PRINT_VID );
    
    base_dir=myVid.base_dir;    
    dataDir=strcat(base_dir,'/data');
    
    if(overwriteP1==1 || ~exist(strcat(dataDir,'/phase1_data.mat'),'file'))
        display(strcat(datestr(now,'HH:MM:SS'),...
            ' [INFO] Starting Phase 1 :',fileName)); 
        addpath('phase1/');
        phase1(numOfClusters, myVid, playerDetector);
        rmpath('phase1/');
    else        
        display(strcat(datestr(now,'HH:MM:SS'),...
            ' [INFO] Skipping Phase 1 :',fileName)); 
    end
    
    if(overwriteP2==1 || ~exist(strcat(dataDir,'/phase2_data.mat'),'file'))
        display(strcat(datestr(now,'HH:MM:SS'),...
            ' [INFO] Starting Phase 2 :',fileName)); 
        addpath('phase2/');
        phase2(base_dir);
        rmpath('phase2/');
    else        
        display(strcat(datestr(now,'HH:MM:SS'),...
            ' [INFO] Skipping Phase 2 :',fileName)); 
    end
    
    if(overwriteP3==1 || ~exist(strcat(dataDir,'/phase3_data.mat'),'file'))
        display(strcat(datestr(now,'HH:MM:SS'),...
            ' [INFO] Starting Phase 3 :',fileName)); 
        addpath('phase3/');
        phase3(base_dir,myVid);
        rmpath('phase3/');
    else        
        display(strcat(datestr(now,'HH:MM:SS'),...
            ' [INFO] Skipping Phase 3 :',fileName)); 
    end
    
    closeVids(myVid);
    rmpath('helper/');
    copyfile('index.html',base_dir);
    
    movefile(strcat(base_dir,'.',ext),strcat(base_dir,'/original.',ext));   
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Proccessing done on :',fileName));      
    
end

