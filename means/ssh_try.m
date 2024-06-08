cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/CUTI
clear all; close all; clc;
[mask,LON,LAT,path1]=lets_get_started;
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/CUTI

%%
fn='SSH_n_copernicus.nc';

LONSSH=double(ncread(fn,'longitude'));
LATSSH=double(ncread(fn,'latitude'));
ssh=double(ncread(fn,'zos'))*100;

SSH=mean(ssh,3,'omitnan');
%% 
[Xu,Yu]=meshgrid(LONSSH, LATSSH);
SSH_cmems = interp2(Xu, Yu, SSH', LON', LAT', 'linear')'; %m
%%
save('SSH_copernicus.mat','Xu','Yu','SSH_cmems');
%% 
Humboldt_ports;

figure
P=get(gcf,'position');
P(3)=P(3)*1.2;
P(4)=P(4)*2.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

pcolor(LON,LAT,SSH'); shading flat;
hold on
[c,h]=contour(LON,LAT,SSH',[-30:2:30],'k');
clabel(c,h);
caxis([-30 30]);
cmocean('delta'); 
borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 
ax = gca;
ax.FontSize = 18; 
c=colorbar;
c.Label.String='cm';
c.Label.FontSize = 20;
hold on
for i = 1:length(Puertos)
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end
title('Long-term mean of ocean (1990-2010) SSH','fontsize',16); 