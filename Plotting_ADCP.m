clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
cd /Users/dlizarbe/Documents/DANIEL/DanielLizarbe/IMARPE;
%% 
% IMARPE ==================================================================
% load two IMARPE sections and cut off columns and rows with only nans
load('ADCP_Section_3S_6S.mat')
X = Dist(1:end-2);
Valong36 = Valongshore(1:end-2,4:end);

load('ADCP_Section_12S.mat')
Valong12 = Valongshore(1:end-2,4:end);

clear Dist Valongshore pathd
Z = Z(4:end);
%%
figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(1,2,2);hold on
contourf(X, Z, Valong12',[-50:1:50],'linestyle','none');
[C h]=contour(X, Z, Valong12', [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(X, Z, Valong12', [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
set(gca, 'xdir', 'reverse','ytick',[0:100:1000],'xtick',[0:50:1000],'ydir', 'reverse','fontsize',14)
xlabel('Distance [km]')
ylabel('Depth [m]')
ylim([0 Z(end)])
xlim([0 180])
box on
title('ADCP Section 12S');
cmocean('balance',11) 
colorbar
caxis([-10 10]);
ax = gca;
ax.FontSize = 20;
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));


subplot(1,2,1);hold on
contourf(X, Z, Valong36',[-50:1:50],'linestyle','none');
[C h]=contour(X, Z, Valong36', [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(X, Z, Valong36', [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
set(gca, 'xdir', 'reverse','ytick',[0:100:1000],'xtick',[0:50:1000],'ydir', 'reverse','fontsize',14)
xlabel('Distance [km]')
ylabel('Depth [m]')
ylim([0 Z(end)])
xlim([0 180])
box on
title('ADCP Section 3S-6S');
cmocean('balance',11) 
caxis([-10 10]);
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));

