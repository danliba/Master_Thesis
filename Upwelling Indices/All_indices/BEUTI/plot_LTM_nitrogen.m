%% ----- All time Mean Nitrogen ----- %% 
clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;

cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BEUTI/

load('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BEUTI/Nitrogen.mat');
load('/Volumes/BM_2022_x/Hindcast_1990_2010/means/MLD/MLD.mat');

LTM_NO2 = mean(NO2_mld,3,'omitnan');
LTM_NO3 = mean(NO3_mld,3,'omitnan');
LTM_NH4 = mean(NH4_mld,3,'omitnan');
LTM_TN = mean(Total_N,3,'omitnan');
LTM_MLD = mean(MLD,3,'omitnan');

%% ---- Plot Nitrogen ---- %% 
[~,ylab] = generateYLabels(20,5,5);
[~,xlab] = generateXLabels(90,70,5);

figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(2,2,1)
[c,h]=contourf(LON,LAT,LTM_NO3'.*mask,[0:0.1:30]); 
axis([-90 -70 -20 -5]); caxis([0 14]);cmocean('haline',15); colorbar;
title('LTM NO3 at MLD'); set(h,'LineColor','none');
hold on
[c,h]=contour(LON,LAT,LTM_MLD.*mask,[0:10:100],'k'); 
clabel(c,h);
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
ticks = 0:2:14;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mu mol \cdot m^{-3}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);


subplot(2,2,2)
[c,h]=contourf(LON,LAT,LTM_NO2'.*mask,[0:0.1:30]); 
axis([-90 -70 -20 -5]); caxis([0 14]);cmocean('haline',15); colorbar;
title('LTM NO2 at MLD'); set(h,'LineColor','none');
hold on
[c,h]=contour(LON,LAT,LTM_MLD.*mask,[0:10:100],'k'); 
clabel(c,h);
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
ticks = 0:2:14;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mu mol \cdot m^{-3}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);

subplot(2,2,3)
[c,h]=contourf(LON,LAT,LTM_NH4'.*mask,[0:0.01:1]); 
caxis([0 1]);cmocean('haline',11); colorbar;
title('LTM NH4 at MLD'); set(h,'LineColor','none');
hold on
[c,h]=contour(LON,LAT,LTM_MLD.*mask,[0:10:100],'k'); 
clabel(c,h);
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
ticks = 0:0.2:1;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mu mol \cdot m^{-3}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);

subplot(2,2,4)
[c,h]=contourf(LON,LAT,LTM_TN'.*mask,[0:0.1:30]); 
axis([-90 -70 -20 -5]); caxis([0 14]);cmocean('haline',15); colorbar;
title('LTM Total N at MLD'); set(h,'LineColor','none');
hold on
[c,h]=contour(LON,LAT,LTM_MLD.*mask,[0:10:100],'k'); 
clabel(c,h);
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
ticks = 0:2:14;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mu mol \cdot m^{-3}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);
%%
savefig('Nitrogen_LTM.fig');