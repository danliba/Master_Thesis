clear all; close all; clc;
cd /Volumes/BM_2022_x/Hindcast_1990_2010
addpath /Volumes/BM_2022_x/Hindcast_1990_2010
addpath /Volumes/BM_2022_x/CDT-master/cdt


path1='./';
dir1=dir([path1,'croco*.nc']);

yr=1990:2010;
mo=1:12;

jj=0;
for iy=yr(1):1:yr(end)
    
    for imo=mo(1):1:mo(end)
        
        filename=sprintf('croco_avg_Y%dM%d.nc',iy,imo);
        disp(filename)
        
        xl=ncread(filename,'xl');
        %clear xl
       
    end
    
end

xl=ncread('croco_avg_Y2001M10.nc','xl');


