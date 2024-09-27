function [reff,refi]=MLD_2_CrossShore(ref,flag)

    [mask,LON,LAT,~]=lets_get_started_CC;
    mask(mask==0)=NaN;
    cd /Volumes/BM_2019_01/climate

    indxlat = find(LAT(1,:)>= -16 & LAT(1,:)<=-5);
    indxlon = find(LON(:,1)>= -85 & LON(:,1)<=-75);

    ref1 = ref(indxlon,indxlat,:); ref1(ref1==0)=NaN;
    for ik=1:1:size(ref1,3)
        REF(:,:,ik) = shift_coast_to_0km_ver2(ref1(:,:,ik)');
    end
    refi = squeeze(mean(REF,2,'omitnan'));%latitudinal mean
    
    if flag ==1
        loni = LON(indxlon,1);
        loncut = find(loni>= -80);
        
        reff = mean(refi(loncut,:),2,'omitnan');
    else
        reff = 0;
    end

end