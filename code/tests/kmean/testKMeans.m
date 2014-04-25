%rng('default') % For reproducibility
X = [randn(100,2)+ones(100,2);...
    randn(100,2)-ones(100,2)];
%X=[ 4 4 ; 3 3 ; 2 2; 5 1; 11 3; 12 5; 10 7];
opts = statset('Display','final');
[idx,ctrs] = kmeans(X,4,'Distance','city',...
    'Replicates',5,'Options',opts);
plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',12)
hold on
plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',12)
hold on
plot(X(idx==3,1),X(idx==3,2),'g.','MarkerSize',12)
hold on
plot(X(idx==4,1),X(idx==4,2),'c.','MarkerSize',12)

plot(ctrs(:,1),ctrs(:,2),'kx',...
    'MarkerSize',12,'LineWidth',2)
plot(ctrs(:,1),ctrs(:,2),'ko',...
    'MarkerSize',12,'LineWidth',2)

legend('Cluster 1','Cluster 2','Centroids',...
    'Location','NW')
hold off

% x = gallery('uniformdata',[1 10],0);
% y = gallery('uniformdata',[1 10],1);
figure()
x = ctrs(:,1);
y = ctrs(:,2);
voronoi(x,y)

[v,c]=voronoin(ctrs);
ctrs