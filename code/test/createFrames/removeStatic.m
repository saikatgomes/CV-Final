function [] = removeStatic()
    %does not work!!!!
    vName='data/2a';
    ext='mp4';
    obj.reader = vision.VideoFileReader(strcat(vName,'.',ext));
        
    frame0 = obj.reader.step();
    X=size(frame0,1);
    Y=size(frame0,2);
    deltaMap=zeros(X, Y);
    fcount=1;
    mkdir(strcat(vName,'Edited'));
    while ~isDone(obj.reader)
        fcount=fcount+1;
        frame = obj.reader.step();
        for x=1:X
           for y=1:Y
               if(deltaMap(x,y)==1)
                   continue;
               end
               
              if(frame0(X,Y,1)~=frame(X,Y,1) || ... 
                  frame0(X,Y,2)~=frame(X,Y,2) || ...
                  frame0(X,Y,3)~=frame(X,Y,3))
                    deltaMap(x,y)=1;
              end
           end
        end
        frame0=frame;
        fcount
    end 
    imwrite(int8(deltaMap),strcat(vName,'/',num2str(fcount),'.jpg'));   
end
