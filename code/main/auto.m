
myaddress = 'cs766vision@gmail.com';
mypassword = 'moneyball123';

setpref('Internet','E_mail',myaddress);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',myaddress);
setpref('Internet','SMTP_Password',mypassword);

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', ...
    'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

mainDir='../../sandbox/data98/';
hostName=getHostName();
k=22;
createVid=0; %1=yes,0=no
overwriteP1=0; %1=yes,0=no
overwriteP2=0; %1=yes,0=no
overwriteP3=1; %1=yes,0=no

d = dir(mainDir);
isub = [d(:).isdir];
folderName = {d(isub).name}';
folderName(ismember(folderName,{'.','..'})) = [];

for i=1:length(folderName)
    fPath=fullfile(strcat(mainDir,folderName{i}),'/*mp4');
    fileName  =  dir(fPath);
    fileName  = {fileName.name}';
    
    for j=1:length(fileName)
        fullFileName=strcat(mainDir,folderName{i},'/',fileName{j});
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] proccessing >',fullFileName));
        fName=fullFileName(1:length(fullFileName)-4);
        try
            startTime=datestr(now,'HH:MM:SS');
            process(fName,'mp4',createVid,k,overwriteP1,overwriteP2,overwriteP3);
            endTime=datestr(now,'HH:MM:SS');
            sendmail('saikatgomes@gmail.com', 'TESTBOT: Success', ...
                strcat('Success: ',fullFileName,' @ ',hostName,' ____ START:',startTime,' _____ END:',endTime));
        catch ME
            sendmail('saikatgomes@gmail.com', 'TESTBOT: Fail', strcat('error: ', ...
                ME.message,'.......... iden: ',ME.identifier,' ............... file',fullFileName,' @ ',hostName));
            display(strcat(datestr(now,'HH:MM:SS'),' [ERROR] FAILED proccessing ',fullFileName));
        end
    end
    
    
end

