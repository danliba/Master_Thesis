%% Plotting Nitrogen under CC sensitivity analysis
[mask,LON,LAT,~]=lets_get_started_CC;
mask(mask==0)=NaN;
cd /Volumes/BM_2019_01/climate

indxlon = find(LON(:,1)>= -85 & LON(:,1)<=-75);
loni = LON(indxlon,1);
loncut = find(loni>= -80);

%%
cd /Volumes/BM_2019_01/climate
%paths 
p1 ='/Volumes/BM_2019_01/climate/ref';
p2 = '/Volumes/BM_2019_01/climate/T+';
p3 = '/Volumes/BM_2019_01/climate/wind-';
p4 = '/Volumes/BM_2019_01/climate/wind+';


ref=struct2array(load(fullfile(p1,'PP_flux_Cross_shore.mat'), 'PP_fluxes'));
Tplus=struct2array(load(fullfile(p2,'PP_flux_Cross_shore.mat'), 'PP_fluxes'));
Wminus=struct2array(load(fullfile(p3,'PP_flux_Cross_shore.mat'), 'PP_fluxes'));
Wplus=struct2array(load(fullfile(p4,'PP_flux_Cross_shore.mat'), 'PP_fluxes'));

load('MLD.mat');
%% PP cut
refPP = mean(ref(loncut,:,:),3,'omitnan');
TplusPP = mean(Tplus(loncut,:,:),3,'omitnan');
WminusPP = mean(Wminus(loncut,:,:),3,'omitnan');
WplusPP = mean(Wplus(loncut,:,:),3,'omitnan');

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
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(1,3,1);hold on
pcolor(disti12,Zi,[TplusPP-refPP]'*86400); shading interp; cmocean('balance',17);
caxis([-0.2 0.2]);
[C h]=contour(disti12, Zi,V_ref'.*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color','k');
clabel(C,h,[-50:10:-10],'color','k','fontsize',14);
[C h]=contour(disti12, Zi,V_T'.*100, [-50:10:0],'color',[.5 .5 .5],'linestyle','--','linewidth',2);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-Tplus1,'linewidth',3,'Color',[.5 .5 .5]);
%MLD_NEUTRO
plot(disti12,-ref1,'linewidth',3,'Color','k');
[C h]=contour(disti12, Zi, V_ref', [0:10:50],'w-','linestyle',':','linewidth',2,'Color','k');
clabel(C,h,[-50:10:50],'color','k','fontsize',14);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-50 0]);ylabel('Depth [m]')
xlim([0 200])
box on
title('[T+] - [ref]');
c=colorbar;
ax = gca;
ax.FontSize = 20;
%     ticks = [-2:0.5:2]*10^-6;
%     c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mmol \cdot N \cdot m^{-3} \cdot day^{-1}$','interpreter','latex'); % Add your desired label here

subplot(1,3,2);hold on
pcolor(disti12,Zi,[WminusPP-refPP]'*86400); shading interp; cmocean('balance',17);
caxis([-0.2 0.2]);
[C h]=contour(disti12, Zi,V_ref'.*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color','k');
clabel(C,h,[-50:10:-10],'color','k','fontsize',14);
[C h]=contour(disti12, Zi,V_Wminus'.*100, [-50:10:0],'color',[.5 .5 .5],'linestyle','--','linewidth',2);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-Wminus1,'linewidth',3,'Color',[.5 .5 .5]);
%MLD ref
plot(disti12,-ref1,'linewidth',3,'Color','k');
[C h]=contour(disti12, Zi, V_ref', [0:10:50],'w-','linestyle',':','linewidth',2,'Color','k');
clabel(C,h,[-50:10:50],'color','k','fontsize',14);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-50 0]);ylabel('Depth [m]')
xlim([0 200])
box on
title('[W-] - [ref]');
c=colorbar;
ax = gca;
ax.FontSize = 20;
%     ticks = [-2:0.5:2]*10^-6;
%     c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mmol \cdot N \cdot m^{-3} \cdot day^{-1}$','interpreter','latex'); % Add your desired label here

subplot(1,3,3);hold on
pcolor(disti12,Zi,[WplusPP-refPP]'*86400); shading interp; cmocean('balance',17);
caxis([-0.2 0.2]);
[C h]=contour(disti12, Zi,V_ref'.*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color','k');
clabel(C,h,[-50:10:-10],'color','k','fontsize',14);
[C h]=contour(disti12, Zi,V_Wplus'.*100, [-50:10:0],'color',[.5 .5 .5],'linestyle','--','linewidth',2);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-Wplus1,'linewidth',3,'Color',[.5 .5 .5]);
%MLD ref
plot(disti12,-ref1,'linewidth',3,'Color','k');
[C h]=contour(disti12, Zi, V_ref', [0:10:50],'w-','linestyle',':','linewidth',2,'Color','k');
clabel(C,h,[-50:10:50],'color','k','fontsize',14);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-50 0]);ylabel('Depth [m]')
xlim([0 200])
box on
title('[W+] - [ref]');
c=colorbar;
ax = gca;
ax.FontSize = 20;
%     ticks = [-2:0.5:2]*10^-6;
%     c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mmol \cdot N \cdot m^{-3} \cdot day^{-1}$','interpreter','latex'); % Add your desired label here

