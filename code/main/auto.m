
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

mainDir='../../data/';

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
            process(fName,'mp4');
            sendmail('saikatgomes@gmail.com', 'TESTBOT: Success', strcat('Success: ',fullFileName));
        catch ME
            sendmail('saikatgomes@gmail.com', 'TESTBOT: Fail', strcat('error: ', ...
                ME.message,'.......... iden: ',ME.identifier,' ............... file',fullFileName));
            display(strcat(datestr(now,'HH:MM:SS'),' [ERROR] FAILED proccessing ',fullFileName));
        end
    end
    
    
end

