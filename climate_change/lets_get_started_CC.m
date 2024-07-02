function [mask,LON,LAT,f,path1]=lets_get_started_CC
addpath /Volumes/BM_2022_x/Hindcast_1990_2010
addpath /Volumes/BM_2022_x/CDT-master/cdt

path1='./';
cd /Users/dlizarbe/Documents/DANIEL/croco_tools;
start


%% load
mask=ncread('/Volumes/BM_2019_01/climate/ref/croco_avg_Y2009M12.nc.1','mask_rho');
LON=ncread('/Volumes/BM_2019_01/climate/ref/croco_avg_Y2009M12.nc.1','lon_rho'); %lon lat s_rho time
LAT=ncread('/Volumes/BM_2019_01/climate/ref/croco_avg_Y2009M12.nc.1','lat_rho');
f=ncread('/Volumes/BM_2019_01/climate/ref/croco_avg_Y2009M12.nc.1','f');
mask(mask==0)=NaN;
end