%% V cross shore
load('/Volumes/BM_2019_01/climate/ref/CSH_CC_V.mat');%ref
ref = Mean_V;
T_plus = struct2array(load('/Volumes/BM_2019_01/climate/T+/CSH_CC_V.mat','Mean_V'));
W_minus = struct2array(load('/Volumes/BM_2019_01/climate/wind-/CSH_CC_V.mat','Mean_V'));
W_plus = struct2array(load('/Volumes/BM_2019_01/climate/wind+/CSH_CC_V.mat','Mean_V'));

%% Differences 

T1 = T_plus - ref; %T+
W1 = W_minus - ref; %wind-
W2 = W_plus - ref; %wind+

%% Plot 
figure
P=get(gcf,'position');
P(3)=P(3)*4;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

%reference
subplot(2,4,1);hold on
pcolor(disti12,Zi,ref'*100); shading interp; cmocean('balance',18);
caxis([-10 10]);
[C h]=contour(disti12, Zi,ref'.*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, ref', [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-200 0]);ylabel('Depth [m]')
xlim([0 200])
box on
title('[Ref]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, 'cm/s'); % Add your desired label here

%T+
subplot(2,4,2);hold on
pcolor(disti12,Zi,T_plus'*100); shading interp; cmocean('balance',18);
caxis([-10 10]);
[C h]=contour(disti12, Zi,T_plus'.*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, ref', [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-200 0]);%ylabel('Depth [m]')
xlim([0 200])
box on
title('[T+]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, 'cm/s'); % Add your desired label here

%wind -
subplot(2,4,3);hold on
pcolor(disti12,Zi,W_minus'*100); shading interp; cmocean('balance',18);
caxis([-10 10]);
[C h]=contour(disti12, Zi,W_minus'.*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, ref', [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-200 0]);%ylabel('Depth [m]')
xlim([0 200])
box on
title('[W -]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, 'cm/s'); % Add your desired label here

%wind + 
subplot(2,4,4);hold on
pcolor(disti12,Zi,W_plus'*100); shading interp; cmocean('balance',18);
caxis([-10 10]);
[C h]=contour(disti12, Zi,W_plus'.*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, ref', [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-200 0]);%ylabel('Depth [m]')
xlim([0 200])
box on
title('[W +]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, 'cm/s'); % Add your desired label here

% T_plus - ref
subplot(2,4,6);hold on
pcolor(disti12,Zi,[T_plus - ref]'*100); shading interp; cmocean('balance',11);
caxis([-5 5]);
[C h]=contour(disti12, Zi,ref'.*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, ref', [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-200 0]);ylabel('Depth [m]')
xlim([0 200])
box on
title('[T+] - [Ref]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -5:1:5;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, 'cm/s'); % Add your desired label here

% [Wind -] - [ref]
subplot(2,4,7);hold on
pcolor(disti12,Zi,[W_minus - ref]'*100); shading interp; cmocean('balance',11);
caxis([-5 5]);
[C h]=contour(disti12, Zi,ref'.*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, ref', [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-200 0]);%ylabel('Depth [m]')
xlim([0 200])
box on
title('[W-] - [Ref]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -5:1:5;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, 'cm/s'); % Add your desired label here

% [Wind -] - [ref]
subplot(2,4,8);hold on
pcolor(disti12,Zi,[W_plus - ref]'*100); shading interp; cmocean('balance',11);
caxis([-5 5]);
[C h]=contour(disti12, Zi,ref'.*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, ref', [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-200 0]);%ylabel('Depth [m]')
xlim([0 200])
box on
title('[W+] - [Ref]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -5:1:5;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, 'cm/s'); % Add your desired label here
