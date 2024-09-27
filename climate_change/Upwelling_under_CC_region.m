clear all; close all; clc;
%% ---- plot of the Study Regio ----- %%
[mask,LON,LAT,f,path1]=lets_get_started_CC;
mask(mask==0)=NaN;
cd /Volumes/BM_2019_01/climate

%% 
p1 ='/Volumes/BM_2019_01/climate/ref';
p2 = '/Volumes/BM_2019_01/climate/T+';
p3 = '/Volumes/BM_2019_01/climate/wind-';
p4 = '/Volumes/BM_2019_01/climate/wind+';

ref=mean(struct2array(load(fullfile(p1,'WMLD_MLD.mat'), 'WMLD')),3,'omitnan');
Tplus=mean(struct2array(load(fullfile(p2,'WMLD_MLD.mat'), 'WMLD')),3,'omitnan');
Wminus=mean(struct2array(load(fullfile(p3,'WMLD_MLD.mat'), 'WMLD')),3,'omitnan');
Wplus=mean(struct2array(load(fullfile(p4,'WMLD_MLD.mat'), 'WMLD')),3,'omitnan');
load('MLD_W_1990_2010.mat');

%% EN 
load('NINO9798.mat');
noNINOIndex = cat(1,[1:87]',[107:252]');

wmld = permute(Wmld,[2 1 3]);
EN9798 = mean(wmld(:,:,EN9798_index),3,'omitnan');
Neutro = mean(wmld(:,:,noNINOIndex),3,'omitnan');
%% 
arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
%arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/SST/BK111km.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;
Humboldt_ports;

%%
[~,ylab] = generateYLabels(20,5,5);
[~,xlab] = generateXLabels(84,70,4);

figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

%--------------------ref
subplot(2,2,1)
[c,h]=contourf(LON,LAT,ref'.*mask.*86400,[-10:0.1:10]);
axis([-84 -72 -20 -5]); caxis([-2 2]);cmocean('balance',9); colorbar;
title('Reference');
set(h,'LineColor','none');
hold on
for i = 1:4
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end
hold on
plot(lonb1,latb1,'k','linewidth',4);

ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
   ticks = -2:0.5:2;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-16 -5]);
set(gca,'xtick',[-84:4:-72],'xticklabel',xlab,'xlim',[-84 -72]);

%---------------------Tplus
subplot(2,2,2)
[c,h]=contourf(LON,LAT,Tplus'.*mask.*86400,[-10:0.1:10]);
axis([-84 -72 -20 -5]); caxis([-2 2]);cmocean('balance',9); colorbar;
title('T +');
set(h,'LineColor','none');
hold on
for i = 1:4
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end
hold on
plot(lonb1,latb1,'k','linewidth',4);

ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
   ticks = -2:0.5:2;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-16 -5]);
set(gca,'xtick',[-84:4:-72],'xticklabel',xlab,'xlim',[-84 -72]);

%---------------------Wind plus
subplot(2,2,4)
[c,h]=contourf(LON,LAT,Wplus'.*mask.*86400,[-10:0.1:10]);
axis([-84 -72 -20 -5]); caxis([-2 2]);cmocean('balance',9); colorbar;
title('Wind +');
set(h,'LineColor','none');
hold on
for i = 1:4
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end
hold on
plot(lonb1,latb1,'k','linewidth',4);

ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
   ticks = -2:0.5:2;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-16 -5]);
set(gca,'xtick',[-84:4:-72],'xticklabel',xlab,'xlim',[-84 -72]);

%---------------------Wind minus
subplot(2,2,3)
[c,h]=contourf(LON,LAT,Wminus'.*mask.*86400,[-10:0.1:10]);
axis([-84 -72 -20 -5]); caxis([-2 2]);cmocean('balance',9); colorbar;
title('Wind -');
set(h,'LineColor','none');
hold on
for i = 1:4
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end
hold on
plot(lonb1,latb1,'k','linewidth',4);

ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
   ticks = -2:0.5:2;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-16 -5]);
set(gca,'xtick',[-84:4:-72],'xticklabel',xlab,'xlim',[-84 -72]);
%% anomalies


figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

%--------------------EN
subplot(2,2,4)
[c,h]=contourf(LON,LAT,[EN9798 - Neutro].*mask.*86400,[-10:0.1:10]);
axis([-84 -72 -20 -5]); caxis([-2 2]);cmocean('balance',9); colorbar;
title('EN 1997/98');
set(h,'LineColor','none');
hold on
for i = 1:4
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end
hold on
plot(lonb1,latb1,'k','linewidth',4);

ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
   ticks = -2:0.5:2;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-16 -5]);
set(gca,'xtick',[-84:4:-72],'xticklabel',xlab,'xlim',[-84 -72]);

%---------------------Tplus
subplot(2,2,1)
[c,h]=contourf(LON,LAT,[Tplus-ref]'.*mask.*86400,[-10:0.1:10]);
axis([-84 -72 -20 -5]); caxis([-2 2]);cmocean('balance',9); colorbar;
title('[T +] - [ref]');
set(h,'LineColor','none');
hold on
for i = 1:4
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end
hold on
plot(lonb1,latb1,'k','linewidth',4);

ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
   ticks = -2:0.5:2;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-16 -5]);
set(gca,'xtick',[-84:4:-72],'xticklabel',xlab,'xlim',[-84 -72]);

%---------------------Wind plus
subplot(2,2,3)
[c,h]=contourf(LON,LAT,[Wplus-ref]'.*mask.*86400,[-10:0.1:10]);
axis([-84 -72 -20 -5]); caxis([-2 2]);cmocean('balance',9); colorbar;
title('[Wind +] - [ref]');
set(h,'LineColor','none');
hold on
for i = 1:4
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end
hold on
plot(lonb1,latb1,'k','linewidth',4);

ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
   ticks = -2:0.5:2;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-16 -5]);
set(gca,'xtick',[-84:4:-72],'xticklabel',xlab,'xlim',[-84 -72]);

%---------------------Wind minus
subplot(2,2,2)
[c,h]=contourf(LON,LAT,[Wminus-ref]'.*mask.*86400,[-10:0.1:10]);
axis([-84 -72 -20 -5]); caxis([-2 2]);cmocean('balance',9); colorbar;
title('[Wind -] - [ref]');
set(h,'LineColor','none');
hold on
for i = 1:4
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end
hold on
plot(lonb1,latb1,'k','linewidth',4);

ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
   ticks = -2:0.5:2;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-16 -5]);
set(gca,'xtick',[-84:4:-72],'xticklabel',xlab,'xlim',[-84 -72]);