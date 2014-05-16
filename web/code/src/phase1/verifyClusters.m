function [ new_ctrs ] = verifyClusters( ctrs ,minDist)

    %TODO: check the max distance within cluster to eleiminate long chains
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
end

