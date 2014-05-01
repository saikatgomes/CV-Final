function [  ] = closeVids( myVid )

    close(myVid.new);
    if(myVid.MAKE_NO_BG_VID==1)
        close(myVid.outVid);
    end
    if(myVid.MAKE_GD_VID==1)
        close(myVid.gdVid);
    end
    if(myVid.MAKE_HM_VID==1)
        close(myVid.hmVid);
    end
    if(myVid.MAKE_LM_VID==1)
        close(myVid.lmVid);
    end
    if(myVid.MAKE_CLUSTER_VID==1)
        close(myVid.clusterVid);
    end
    if(myVid.MAKE_CENTROID_VID==1)
        close(myVid.cenVid1);
        close(myVid.cenVid2);
    end
    if(myVid.MAKE_TRACKS_VID==1)
        close(myVid.tracksVid1);
        close(myVid.tracksVid2);
    end

end

