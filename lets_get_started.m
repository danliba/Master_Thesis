function [mask,LON,LAT,f,path1]=lets_get_started
addpath /Volumes/BM_2022_x/Hindcast_1990_2010
addpath /Volumes/BM_2022_x/CDT-master/cdt

path1='./';
cd /Users/dlizarbe/Documents/DANIEL/croco_tools;
start


%% load
mask=ncread('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Mean_Y2010M12.nc','mask_rho');
LON=ncread('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Mean_Y2010M12.nc','lon_rho'); %lon lat s_rho time
LAT=ncread('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Mean_Y2010M12.nc','lat_rho');
f=ncread('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Mean_Y2010M12.nc','f');
mask(mask==0)=NaN;
end