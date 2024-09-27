%this functions gets the region mean
function Region_mean=get_region_mean(TN_Surf,indxlon,indxlat,loni,lati,mask,flag)

if flag ==1
    nNitro_Surf = calculate_URegion2(TN_Surf(indxlon,indxlat,:), loni, lati, mask(indxlon,indxlat));
    Region_mean = mean(nNitro_Surf(:),'omitnan');
end
if flag == 2
    nNitro_Surf = calculate_URegion2(TN_Surf, loni, lati, mask(indxlon,indxlat));
    Region_mean = mean(nNitro_Surf(:),'omitnan');
end
end
