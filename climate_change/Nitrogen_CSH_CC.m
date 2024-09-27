%% Plotting Nitrogen under CC sensitivity analysis
[mask,LON,LAT,~]=lets_get_started_CC;
mask(mask==0)=NaN;
cd /Volumes/BM_2019_01/climate
%%
cd /Volumes/BM_2019_01/climate
%paths 
p1 ='/Volumes/BM_2019_01/climate/ref';
p2 = '/Volumes/BM_2019_01/climate/T+';
p3 = '/Volumes/BM_2019_01/climate/wind-';
p4 = '/Volumes/BM_2019_01/climate/wind+';


ref=struct2array(load(fullfile(p1,'Cross_shore_N_composit_5_16.mat'), 'Total_N1415'));
Tplus=struct2array(load(fullfile(p2,'Cross_shore_N_composit_5_16.mat'), 'Total_N1415'));
Wminus=struct2array(load(fullfile(p3,'Cross_shore_N_composit_5_16.mat'), 'Total_N1415'));
Wplus=struct2array(load(fullfile(p4,'Cross_shore_N_composit_5_16.mat'), 'Total_N1415'));

load('MLD.mat');

%% ------------ ENSO Dante ------------------ %
load('ENSO_DANTE_dates.mat');
timeNINO2(16)=[]; indxNINO2(16) = [];
load('NINO9798.mat');

indxlon = find(LON(:,1)>= -85 & LON(:,1)<=-75);
loni = LON(indxlon,1);
loncut = find(loni>= -80);
%% Nitrogen cut
refN = mean(ref(loncut,:,:),3,'omitnan');
TplusN = mean(Tplus(loncut,:,:),3,'omitnan');
WminusN = mean(Wminus(loncut,:,:),3,'omitnan');
WplusN = mean(Wplus(loncut,:,:),3,'omitnan');

%% ------------- V velocity under CC ------------------------ % 
V_ref=struct2array(load(fullfile(p1,'CSH_CC_V.mat'),'Mean_V'));
V_T=struct2array(load(fullfile(p2,'CSH_CC_V.mat'),'Mean_V'));
V_Wminus=struct2array(load(fullfile(p3,'CSH_CC_V.mat'),'Mean_V'));
V_Wplus=struct2array(load(fullfile(p4,'CSH_CC_V.mat'),'Mean_V'));

%V_NINO97_98 = mean(Vmean_1415(loncut,:,EN9798_index),3,'omitnan');

%% ---------- MLD under CC ----------- %
%---MLD 
load('MLD_CC_SA.mat');
%% --------- plotting
Zi=[0:-10:-500]';
distance_km12 = calculate_longitudinal_distance(-12,5); %latitude, longitude
disti12 = flip(linspace(0,distance_km12,size(V_ref,1)));

figure
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*1.8;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(2,4,1); hold on
pcolor(disti12,Zi,refN'); shading interp; cmocean('haline',16);
caxis([0 35]);
[C h]=contour(disti12, Zi, V_ref'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, V_ref'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-ref1,'linewidth',3,'Color','w');
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-200 0]);ylabel('Depth [m]')
xlim([0 200])
box on
title('T.Nitrogen [ref]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = 0:5:35;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mmol \cdot N \cdot m^{-3}$','interpreter','latex'); % Add your desired label here

subplot(2,4,2); hold on
pcolor(disti12,Zi,TplusN'); shading interp; cmocean('haline',16);
caxis([0 35]);
[C h]=contour(disti12, Zi, V_T'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, V_T'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-Tplus1,'linewidth',3,'Color','w');
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-200 0]);%ylabel('Depth [m]')
xlim([0 200])
box on
title('T.Nitrogen [T+]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = 0:5:35;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mmol \cdot N \cdot m^{-3}$','interpreter','latex'); % Add your desired label here

subplot(2,4,3); hold on
pcolor(disti12,Zi,WminusN'); shading interp; cmocean('haline',16);
[C h]=contour(disti12, Zi, V_Wminus'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, V_Wminus'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
caxis([0 35]);
plot(disti12,-Wminus1,'linewidth',3,'Color','w');
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-200 0]);%ylabel('Depth [m]')
xlim([0 200])
box on
title('T.Nitrogen [W-]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = 0:5:35;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mmol \cdot N \cdot m^{-3}$','interpreter','latex'); % Add your desired label here


subplot(2,4,4); hold on
pcolor(disti12,Zi,WplusN'); shading interp; cmocean('haline',16);
caxis([0 35]);
[C h]=contour(disti12, Zi, V_Wplus'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, V_Wplus'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-Wplus1,'linewidth',3,'Color','w');
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-200 0]);%ylabel('Depth [m]')
xlim([0 200])
box on
title('T.Nitrogen [W +]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = 0:5:35;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mmol \cdot N \cdot m^{-3}$','interpreter','latex'); % Add your desired label here

subplot(2,4,6); hold on
pcolor(disti12,Zi,(TplusN-refN)'); shading interp; cmocean('balance',13);
caxis([-3 3]);
[C h]=contour(disti12, Zi, V_ref'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:0],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-ref1,'linewidth',3,'Color','w');
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-200 0]);ylabel('Depth [m]')
xlim([0 200])
box on
title('[T +] - [ref]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -3:1:3;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mmol \cdot N \cdot m^{-3}$','interpreter','latex'); % Add your desired label here


subplot(2,4,7); hold on
pcolor(disti12,Zi,(WminusN-refN)'); shading interp; cmocean('balance',13);
caxis([-3 3]);
[C h]=contour(disti12, Zi, V_ref'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:0],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-ref1,'linewidth',3,'Color','w');
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-200 0]);%ylabel('Depth [m]')
xlim([0 200])
box on
title('[W -] - [ref]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -3:1:3;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mmol \cdot N \cdot m^{-3}$','interpreter','latex'); % Add your desired label here

subplot(2,4,8); hold on
pcolor(disti12,Zi,(WplusN-refN)'); shading interp; cmocean('balance',13);
caxis([-3 3]);
[C h]=contour(disti12, Zi, V_ref'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:0],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-ref1,'linewidth',3,'Color','w');
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-200 0]);%ylabel('Depth [m]')
xlim([0 200])
box on
title('[W +] - [ref]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -3:1:3;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mmol \cdot N \cdot m^{-3}$','interpreter','latex'); % Add your desired label here

