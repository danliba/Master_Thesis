clear all; close all; clc;
cd /Users/dlizarbe/Documents/DANIEL/depths
[mask,LON,LAT,path1]=lets_get_started;
%% 
cd /Users/dlizarbe/Documents/DANIEL/2001_2010

load('MLD_W');
Wmld_mean=mean(Wmld,3,'omitnan').*86400;
%Wmld_mean=mean(Wmld,3,'omitnan');
%wind_mean=mean(wind,3,'omitnan');
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;

vwind=double(ncread('/Volumes/BM_2022_x/Hindcast_1990_2010/inout/Wind_average.nc','vwnd'));
uwind=double(ncread('/Volumes/BM_2022_x/Hindcast_1990_2010/inout/Wind_average.nc','uwnd'));


load('Mean_199709_2010_chlor')

%% 


U = interp2(Xu, Yu, U', LON', LAT', 'linear')';
%regrid vwind
V = interp2(Xv, Yv, V', LON', LAT', 'linear')';
%% 

% latlab={'35S','30S','25S','20S','15S','10S','5S','0','5N','10N'};
% lonlab={'-70','','','','','','','','','','',''};

figure
P=get(gcf,'position');
P(3)=P(3)*1.2;
P(4)=P(4)*2.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

pcolor(LON',LAT',Wmld_mean.*mask'); shading interp; colorbar;
title('Long term mean ocean (2002-2010) W velocity at MLD','fontsize',16); 
cmocean('balance',13);
hold on
caxis([-1.6 1.6]);
hold on
[c,h]=contour(LON',LAT',wind_mean.*mask',[0:0.5:8],'k:'); shading flat;
clabel(c,h);
[c,h]=contour(lon,lat,chloro',[0.5 2 5 10],'g','linewidth',2);
clabel(c,h);
xlim([-90 -70]); 

ax = gca;
ax.FontSize = 16; 
c=colorbar;
c.Label.String='m/day';
%% 
figure
P=get(gcf,'position');
P(3)=P(3)*1.2;
P(4)=P(4)*2.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(LON',LAT',Wmld_mean.*mask',[-3:0.2:2]);colorbar;
set(h,'LineColor','none');
title('Long-term mean of ocean (2002-2010) W velocity at MLD','fontsize',16); 
cmocean('balance',13);
caxis([-1.6 1.6]);
hold on
[c,h]=contour(LON',LAT',wind_mean.*mask',[0:0.5:8],'k:','linewidth',1.5); 
clabel(c,h);
[c,h]=contour(lon,lat,chloro',[0.5 2 5 10],'g','linewidth',2);
clabel(c,h);
borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 

ax = gca;
ax.FontSize = 16; 
c=colorbar;
c.Label.String='m/day';
%% 
load('/Users/dlizarbe/Documents/DANIEL/winds/Ekman_winds.mat')

[LONi,LATi]=meshgrid(loni,lati);
%% 
figure
P=get(gcf,'position');
P(3)=P(3)*2.4;
P(4)=P(4)*2.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(1,2,1)
[c,h]=contourf(LON',LAT',Wmld_mean.*mask',[-3:0.2:3]);colorbar;
set(h,'LineColor','none');
title('Long-term mean of ocean (2002-2010) W velocity at MLD','fontsize',16); 
cmocean('balance',13);
caxis([-1.6 1.6]);
hold on
quiversc(loni,lati,U_mean',V_mean','k');hold on;
[c,h]=contour(lon,lat,chloro',[0.5 2 5 10],'g','linewidth',2);
clabel(c,h);
borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 
ax = gca;
ax.FontSize = 16; 
c=colorbar;
c.Label.String='m/day';

subplot(1,2,2)
[c,h]=contourf(loni,lati,wE_mean.*86400,[-3:0.2:3]); colorbar; 
cmocean('balance',13); set(h,'LineColor','none');
title('Long-term mean of ocean (1999-2010) Ekman transport velocity','fontsize',16); 
hold on; 
quiversc(loni,lati,U_mean',V_mean','k');hold on;
borders('countries','facecolor','white');
[c,h]=contour(lon,lat,chloro',[0.5 2 5 10],'g','linewidth',2);
clabel(c,h);
caxis([-1.6 1.6]);
axis([-90 -70 -33 10]); 
ax = gca;
ax.FontSize = 16; 
c=colorbar;
c.Label.String='m/day';