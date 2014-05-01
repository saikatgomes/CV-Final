function [] = process( fileName, ext ,PRINT_VID, numOfClusters)
    warning('off','all');

    [ myVid, playerDetector ] = initSetup( fileName, ext, PRINT_VID );
    base_dir = phase1(fileName, ext , numOfClusters, myVid, playerDetector);
    
    phase2(base_dir);
    phase3(base_dir,myVid);
    
    closeVids(myVid);
    
    movefile(strcat(base_dir,'.',ext),strcat(base_dir,'/original.',ext));   
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Proccessing done on :',fileName));      
    
end

