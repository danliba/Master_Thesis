function get_biogeochemistry(in_path)
[mask,LON,LAT,~,~]=lets_get_started_CC;
cd(in_path);

indxlat = find(LAT(1,:)>= -16 & LAT(1,:)<=-5);
indxlon = find(LON(:,1)>= -90 & LON(:,1)<=-70);

loni = LON(indxlon,indxlat);
lati = LAT(indxlon,indxlat);

path1 = in_path;
%% Climate Change Escenarios
%cd /Volumes/BM_2019_01/climate/
%-----ref
%----Nitrogen
load(fullfile(path1,'Nitrogen.mat'))
nNitro_Surf = calculate_URegion2(TN_Surf(indxlon,indxlat,:), loni, lati, mask(indxlon,indxlat));
Ref_Nitro = mean(nNitro_Surf(:),'omitnan')

nNitro_MLD = calculate_URegion2(TN_MLD(indxlon,indxlat,:), loni, lati, mask(indxlon,indxlat));
Ref_Nitro_mld = mean(nNitro_MLD(:),'omitnan')
%---PP flux
load(fullfile(path1,'PP_flux_int.mat'));
PP_fluxes1 = permute(PP_fluxes,[2 1 3]);
PP_ref = get_region_mean(PP_fluxes1,indxlon,indxlat,loni,lati,mask,1)*86400
%--- Biomass
load(fullfile(path1,'Biomass_integrated'));
zoo1 = permute(zoo,[2 1 3]);
phyto1 = permute(phyto,[2 1 3]);

phyto = get_region_mean(phyto1,indxlon,indxlat,loni,lati,mask,1)
zoo = get_region_mean(zoo1,indxlon,indxlat,loni,lati,mask,1)

%--MLD
load(fullfile(path1,'WMLD_MLD.mat'), 'MLD');
mld = get_region_mean(MLD,indxlon,indxlat,loni,lati,mask,1)

%--- chloro
load(fullfile(path1,'Biomass_surface_GOOD.mat'), 'Schla');
chlor = permute(Schla,[2 1 3]);
chloro = get_region_mean(chlor,indxlon,indxlat,loni,lati,mask,1)

end