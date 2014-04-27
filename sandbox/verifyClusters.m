function [ new_ctrs ] = verifyClusters( ctrs ,minDist)

    c=0;
    while(size(ctrs,1)>0)
        sum1=ctrs(1,1);
        sum2=ctrs(1,2);
        subCount=1;
        toRemove(subCount)=1;
        c=c+1;
        
        if(size(ctrs,1)>1)
            for i=2:size(ctrs,1)
                for j=1:length(toRemove)
                   if(pdist([ ctrs(i,:); ctrs(toRemove(j),:)])<minDist)
                        sum1=sum1+ctrs(i,1);
                        sum2=sum2+ctrs(i,2);
                        subCount=subCount+1;
                        toRemove(subCount)=i;
                   end
                end                
            end            
        end
        
        new_ctrs(c,1)=sum1/subCount;
        new_ctrs(c,2)=sum2/subCount;
                
        ctrs = removerows(ctrs,'ind',toRemove');        
        clearvars toRemove;
    end
    





%     A=ctrs';
%     [Y,I]=sort(A(1,:));
%     B=A(:,I);
%     ctrs=B';
%     c=0;
%     sum1=0;
%     sum2=0;
%     subCount=0;
%     for i=1:size(ctrs,1)-1
%         display(strcat('x1=',num2str(ctrs(i,1)),'...x2=',num2str(ctrs(i+1,1))));
%         display(strcat('y1=',num2str(ctrs(i,2)),'...y2=',num2str(ctrs(i+1,2))));
%         
%         if(abs(ctrs(i,1)-ctrs(i+1,1))>minDist && abs(ctrs(i,2)-ctrs(i+1,2))>minDist)
%             if(subCount>0)
%                x=sum1/subCount;
%                y=sum2/subCount;
%                c=c+1;               
%                new_ctrs(c,1)=x;   
%                new_ctrs(c,2)=y;
%             end
%             c=c+1;
%             new_ctrs(c,1)=ctrs(i,1);
%             new_ctrs(c,2)=ctrs(i,2);
%             sum1=0;
%             sum2=0;
%             subCount=0;
%             continue;
%         else
%             subCount=subCount+1;
%             sum1=sum1+ctrs(i,1);
%             sum2=sum2+ctrs(i,2);
%         end
%     end
%     
%     ctrs
%     new_ctrs

end

