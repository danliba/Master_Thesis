%% Now lets calculatew the ekman pump
addpath  /Users/dlizarbe/Documents/DANIEL/2001_2010
clear all; close all; clc;
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
%% 
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
hdir=dir('M*.nc');
[Xu,Yu]=meshgrid(LON(1:end-1,1), LAT(1,:));
[Xv,Yv]=meshgrid(LON(:,1), LAT(1,1:end-1));
%MeanWind_Y2010M4
yr=1990:1:2010;
mo=1:1:12;

jj=0;
for iy=yr(1):1:yr(end)
    
    for imo=mo(1):1:mo(end)
        fn=sprintf('MeanWind_Y%dM%d.nc',iy,imo);
        disp(fn)
        %winds
        uwind=double(ncread(fn,'uwnd'));
        vwind=double(ncread(fn,'vwnd'));
        
        %regrid uwind
        U = interp2(Xu, Yu, uwind', LON', LAT', 'linear')';
        %regrid vwind
        V = interp2(Xv, Yv, vwind', LON', LAT', 'linear')';
        
        [~,~,wE] = ekman(LAT,LON,U,V);
        
        jj=jj+1;
        Ekman_We(:,:,jj)=wE;
    end
end
%% 
Mean_We=mean(Ekman_We,3,'omitnan');

figure
[c,h]=contourf(LON,LAT,Mean_We.*86400.*mask,[-10:0.2:2]);shading flat; colorbar;
cmocean('balance',13); set(h,'LineColor','none');
title('Ekman Pump','fontsize',16);
caxis([-1.6 1.6]);
%% 
U=double(ncread('Wind_average.nc','uwnd'));
V=double(ncread('Wind_average.nc','vwnd'));

U = interp2(Xu, Yu, U', LON', LAT', 'linear')';
%regrid vwind
V = interp2(Xv, Yv, V', LON', LAT', 'linear')';

Humboldt_ports
load('Mean_199709_2010_chlor');

%% save

save('Ekman_We_wind.mat','Ekman_We','Mean_We','LON','LAT','mask','U','V','lon','lat','chloro');

