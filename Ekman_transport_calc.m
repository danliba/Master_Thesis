%% winds
clear all; close all; clc;
cd /Users/dlizarbe/Documents/DANIEL/winds;
%% 
fn='winds.nc';

v=double(ncread(fn,'northward_wind'));
u=double(ncread(fn,'eastward_wind'));
loni=double(ncread(fn,'longitude'));
lati=double(ncread(fn,'latitude'));
time=double(ncread(fn,'time'))./86400;
[yr,mo,da,hr,mi,se]=datevec(double(time)+datenum(1970,1,1,0,0,0));

load('/Users/dlizarbe/Documents/DANIEL/2001_2010/Mean_199709_2010_chlor')

quiversc(loni,lati,u(:,:,1)',v(:,:,1)');
%% We calculate the windstress
pa=1.23; cdd=0.0013;
ty=pa.*cdd.*v(:,:,1).^2;
tx=pa.*cdd.*u(:,:,1).^2;

w=sqrt(u(:,:,1).^2 + v(:,:,1).^2);
w(w==0)=NaN;

figure
pcolor(loni,lati,w');shading flat; colorbar
hold on;
quiversc(loni,lati,u(:,:,1)',v(:,:,1)');
%% ekman
% pw=1025; %seawater density
% rot=7.2921e-5;
% %f=-0.63593*10^-4; %coriolis negative Southern Hemisphere
% f = 2*rot.*sind(lati); 
% 
% Ue=ty./pw.*f;
% Ve=-tx./pw.*f;
% 
% We=sqrt(Ue.^2 + Ve.^2);
% 
% figure
% pcolor(loni,lati,Ue');shading flat; colorbar
% hold on;
% quiversc(loni,lati,u(:,:,1)',v(:,:,1)');
%%  another way 
[LON,LAT]=meshgrid(loni,lati);

parfor ii=1:1:length(time)
    [UE,VE,wE,dE] = ekman(LAT,LON,u(:,:,ii)',v(:,:,ii)');
    wE_c(:,:,ii)=wE;
end
% figure
% pcolor(loni,lati,dE); shading flat;
% caxis([0 150]); hold on; borders('countries','facecolor','white');
% colorbar;axis([-90 -70 -33 10]); title('Ekman Layer Depth');
wE_mean=mean(wE_c,3,'omitnan');
U_mean=mean(u,3,'omitnan');
V_mean=mean(v,3,'omitnan');

save('Ekman_winds.mat','wE_mean','U_mean','V_mean','loni','lati');
%% 
figure
P=get(gcf,'position');
P(3)=P(3)*1.2;
P(4)=P(4)*2.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(loni,lati,wE_mean.*86400,[-3:0.2:2]);shading flat; colorbar; 
cmocean('balance',13); set(h,'LineColor','none');
title('Long-term mean of ocean (1999-2010) Ekman transport velocity','fontsize',16); 

hold on; 
quiversc(loni,lati,U_mean',V_mean','k');hold on;
%quiver([-73 -63],[5 5],[1 1],[1 1],1);
borders('countries','facecolor','white');
[c,h]=contour(lon,lat,chloro',[0.5 2 5 10],'g','linewidth',2);
clabel(c,h);
caxis([-1.6 1.6]);
%caxis([-50*10.^-7 50*10.^-7])
axis([-90 -70 -33 10]); 
ax = gca;
ax.FontSize = 16; 
c=colorbar;
c.Label.String='m/day';

%caxis([-50 50])
%% 
