function [  ] = analyzeOne( base_dir )
    
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Start analysis ... ',base_dir));
    dataDir=strcat(base_dir,'data');
    set(0,'DefaultFigureWindowStyle','docked')

    if(~exist(strcat(dataDir,'/phase3_data.mat'),'file'))
%         display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Phase 3 data nor present ... Starting Phase 3'));
        display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Phase 3 data not present ... ERROR!!!'));
%         phase3(base_dir,'');
    else
        load(strcat(base_dir,'/data/phase3_data.mat'));
        load(strcat(base_dir,'/data/phase1_data_others.mat'));
    end
    
    f=figure();
    set(f,'visible','off');
    axes('position', [0 0 1 1])
    imagesc(normalHM)
    axis off
    img=getframe(f);
    [hog_hm_8, hogVisualization] = getHOGFeatures( img.cdata, 8 );
%     plot(hogVisualization);
    [hog_hm_16, hogVisualization] = getHOGFeatures( img.cdata, 16 );
%     plot(hogVisualization);
    [hog_hm_32, hogVisualization] = getHOGFeatures( img.cdata, 32 );
%     plot(hogVisualization);
    [hog_hm_64, hogVisualization] = getHOGFeatures( img.cdata, 64 );
%     plot(hogVisualization);
    [hog_hm_128, hogVisualization] = getHOGFeatures( img.cdata, 128 );
%     plot(hogVisualization);
    close(f);

    f1=figure();
    set(f1,'visible','off');
    axes('position', [0 0 1 1])
    imagesc(normalHM)
    axis off
    img=getframe(f1);
    hold on;
    for i=1:playerCollection.count
        onePlayer=playerCollection.list(i);
        st=onePlayer.startFrame;
        last=onePlayer.lastFrame;

        plot(onePlayer.smoothTrackY_net(1:end,1),onePlayer.smoothTrackX_net(1:end,1),...
            'w.-','markersize',1,'linewidth',5)
    end
    hold off;
    [hog_hm_overlay_8, hogVisualization] = getHOGFeatures( img.cdata, 8 );
%     plot(hogVisualization);
    [hog_hm_overlay_16, hogVisualization] = getHOGFeatures( img.cdata, 16 );
%     plot(hogVisualization);
    [hog_hm_overlay_32, hogVisualization] = getHOGFeatures( img.cdata, 32 );
%     plot(hogVisualization);
    [hog_hm_overlay_64, hogVisualization] = getHOGFeatures( img.cdata, 64 );
%     plot(hogVisualization);
    [hog_hm_overlay_128, hogVisualization] = getHOGFeatures( img.cdata, 128 );
%     plot(hogVisualization);
    close(f1);

    f2=figure();
    set(f2,'visible','off');
    axes('position', [0 0 1 1])
    backImg=zeros(size(normalHM,1),size(normalHM,2),3);
    imagesc(backImg);
    axis off
    hold on;
    for i=1:playerCollection.count
        onePlayer=playerCollection.list(i);
        st=onePlayer.startFrame;
        last=onePlayer.lastFrame;

        plot(onePlayer.smoothTrackY_net(1:end,1),onePlayer.smoothTrackX_net(1:end,1),...
            'w.-','markersize',1,'linewidth',5)
    end
    hold off;
    img=getframe(f2);
    [hog_overlay_8, hogVisualization] = getHOGFeatures( img.cdata, 8 );
%     plot(hogVisualization);
    [hog_overlay_16, hogVisualization] = getHOGFeatures( img.cdata, 16 );
%     plot(hogVisualization);
    [hog_overlay_32, hogVisualization] = getHOGFeatures( img.cdata, 32 );
%     plot(hogVisualization);
    [hog_overlay_64, hogVisualization] = getHOGFeatures( img.cdata, 64 );
%     plot(hogVisualization);
    [hog_overlay_128, hogVisualization] = getHOGFeatures( img.cdata, 128 );
%     plot(hogVisualization);
    close(f2);
    
    save(strcat(dataDir,'/feature_data.mat'), ...
                                'hog_hm_8', ...
                                'hog_hm_16', ...
                                'hog_hm_32', ...
                                'hog_hm_64', ...
                                'hog_hm_128', ...
                                'hog_hm_overlay_8', ...
                                'hog_hm_overlay_16', ...
                                'hog_hm_overlay_32', ...
                                'hog_hm_overlay_64', ...
                                'hog_hm_overlay_128', ...
                                'hog_overlay_8', ...
                                'hog_overlay_16', ...
                                'hog_overlay_32', ...
                                'hog_overlay_64', ...
                                'hog_overlay_128' ...
                                );
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] Done analysis ... ',base_dir));
end

