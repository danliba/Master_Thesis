cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/CUTI
clear all; close all; clc;
[mask,LON,LAT,f,path1]=lets_get_started;
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/CUTI

%%
fn='UVEL.nc';

LON=double(ncread(fn,'longitude'));
LAT=double(ncread(fn,'latitude'));
uo=double(ncread(fn,'uo'))*100;

Uvel=mean(uo,4,'omitnan');
%% 
Humboldt_ports;
grey = [0.5 0.5 0.5];

figure
P=get(gcf,'position');
P(3)=P(3)*1;
P(4)=P(4)*2.4;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

pcolor(LON,LAT,Uvel'); shading flat;
hold on
[c,h]=contour(LON,LAT,Uvel',[0:0.5:5],'Color',grey);
%caxis([-5 5])
clabel(c,h);
cmocean('balance',41);
borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 
ax = gca;
ax.FontSize = 20; 
c=colorbar;
c.Label.String='m^{2}/s';
c.Label.FontSize = 20;
hold on
for i = 1:length(Puertos)
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end
title('Long-term mean of ocean [1990-2010] U GEO','fontsize',20); 
caxis([-16, 16]);
ticks = -16:2:16;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String='m/s';
c.Label.FontSize = 18;

