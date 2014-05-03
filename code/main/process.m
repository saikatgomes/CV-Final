function [] = process( fileName, ext ,PRINT_VID, numOfClusters, overwriteData)
    warning('off','all');

    
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Start processing :',fileName)); 
    [ myVid, playerDetector ] = initSetup( fileName, ext, PRINT_VID );
    
    base_dir=myVid.base_dir;    
    dataDir=strcat(base_dir,'/data');
    
    if(overwriteData~=1 && ~exist(strcat(dataDir,'/phase1_data.mat'),'file'))
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Starting Phase 1 :',fileName)); 
        phase1(fileName, ext , numOfClusters, myVid, playerDetector);
    else        
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Skipping Phase 1 :',fileName)); 
    end
    
    if(overwriteData~=1 && ~exist(strcat(dataDir,'/phase2_data.mat'),'file'))
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Starting Phase 2 :',fileName)); 
        phase2(base_dir);
    else        
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Skipping Phase 2 :',fileName)); 
    end
    
    %fow now always fo Phase 3
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Starting Phase 3 :',fileName)); 
    phase3(base_dir,myVid);
    
    closeVids(myVid);
    
    movefile(strcat(base_dir,'.',ext),strcat(base_dir,'/original.',ext));   
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Proccessing done on :',fileName));      
    
end

