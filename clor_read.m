%%  chlorophyll
clear all; close all; clc;
%cd /Users/dlizarbe/Documents/DANIEL/2001_2010
%[mask,LON,LAT,path1]=lets_get_started;
cd /Users/dlizarbe/Documents/DANIEL/Chlor

%% load variables 
fn='chlor_lessgaps.nc';

chl=double(ncread(fn,'CHL'));
lat=double(ncread(fn,'latitude'));
lon=double(ncread(fn,'longitude'));
time=double(ncread(fn,'time'))./(60*24*60);
[yr,mo,da,hr,mi,se]=datevec(double(time)+datenum(1970,1,1,0,0,0));


figure
pcolor(lon,lat,chl(:,:,1)');shading flat; colormap jet;
caxis([0 10])
%% 0.5 2 5 10
chloro=mean(chl,3,'omitnan');

figure
P=get(gcf,'position');
P(3)=P(3)*1;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

pcolor(lon,lat,chloro');shading flat; colormap parula;
caxis([0 10]); colorbar;
hold on
[c,h]=contour(lon,lat,chloro',[0.5 2 5 10],'k:');
clabel(c,h);
xlim([-90 -70]); title('Less Gaps');
%% 
save('Mean_199709_2010_chlor.mat','lon','lat','chloro');