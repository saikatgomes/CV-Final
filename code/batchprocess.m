%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Saikat R. Gomes
%% Email: saikat@cs.wisc.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = batchprocess( mainDir ,outDir, createVid, ...
                            overwriteP1, overwriteP2, overwriteP3, ...
                            seed, emailAddress, emailPass)
    
    myaddress = emailAddress;
    mypassword = emailPass;
    setpref('Internet','E_mail',myaddress);
    setpref('Internet','SMTP_Server','smtp.gmail.com');
    setpref('Internet','SMTP_Username',myaddress);
    setpref('Internet','SMTP_Password',mypassword);
    props = java.lang.System.getProperties;
    props.setProperty('mail.smtp.auth','true');
    props.setProperty('mail.smtp.socketFactory.class', ...
        'javax.net.ssl.SSLSocketFactory');
    props.setProperty('mail.smtp.socketFactory.port','465');

    addpath('helper/');
    hostName=getHostName();
    rmpath('helper/');
    d = dir(mainDir);
    isub = [d(:).isdir];
    folderName = {d(isub).name}';
    folderName(ismember(folderName,{'.','..'})) = [];
    numOfClusters=33;
    
    for i=1:length(folderName)
        fPath=fullfile(strcat(mainDir,folderName{i}),'/*mp4');
        fileName  =  dir(fPath);
        fileName  = {fileName.name}';
        myResult = zeros(length(fileName),1);
        success=0;
        fail=0;

        for j=1:length(fileName)
            fullFileName=strcat(mainDir,folderName{i},'/',fileName{j});
            lockFileName=strcat(fullFileName,'.LOCK');
            if(exist(lockFileName,'file')==2)
                display(strcat(datestr(now,'HH:MM:SS'),...
                    ' [INFO] Skipping >[',fullFileName,'] as lock file found' ));
                continue;
            else
                fclose(fopen(lockFileName, 'w'));
            end
            display(strcat(datestr(now,'HH:MM:SS'),...
                ' [INFO] proccessing >',fullFileName));
            fName=fullFileName(1:length(fullFileName)-4);
            try
                startTime=datestr(now,'HH:MM:SS');
                process(fName,'mp4',createVid,numOfClusters,...
                    overwriteP1,overwriteP2,overwriteP3);
                delete(lockFileName);
                endTime=datestr(now,'HH:MM:SS');
                myResult(j,1)=1;
                success=success+1;
                fNum=seed+success;
                movefile(fName,strcat(mainDir,folderName{i},'/',...
                            folderName{i},'_',datestr(now,'HHMMSS'),...
                            '_',num2str(fNum)),'f');
                msg=[strcat('File.....',fullFileName),10,...
                            strcat('Host.....',hostName),10,...
                            strcat('Start....',startTime),10,...
                            strcat('End......',endTime)];                        
                sendmail('saikatgomes@gmail.com', 'TESTBOT: Success', msg);
            catch ME   
                mkdir(strcat('error/',folderName{i},'/'));
                movefile(fullFileName,strcat('error/',...
                    folderName{i},'/',fileName{j}));
                myResult(j,1)=0;
                delete(lockFileName);  
                fail=fail+1;
                
                msg=[strcat('File.....',fullFileName),10,...
                            strcat('Host.....',hostName),10,...
                            strcat('Msg.....',ME.message),10,...
                            strcat('Idf......',ME.identifier)];                                     
                
                sendmail('saikatgomes@gmail.com', 'TESTBOT: Fail',msg);
                display(strcat(datestr(now,'HH:MM:SS'),...
                    ' [ERROR] FAILED proccessing ',fullFileName));
            end
        end    
              
        msg=[strcat('Folder.....',folderName{i}),10,...
                    strcat('Host.....',hostName),10,...
                    strcat('Success..',num2str(success)),10,...
                    strcat('fail.....',num2str(fail))];
       	sendmail('saikatgomes@gmail.com', strcat('TESTBOT: Folder: [',...
            folderName{i},'] done'),msg);
        
        copyfile(strcat(mainDir,folderName{i}),outDir,'f');

    end
end

