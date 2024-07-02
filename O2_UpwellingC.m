%fechas a extraer
cd /Volumes/BM_2022_x/Hindcast_1990_2010/means

%% Monthly average

clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
%cd /Volumes/BM_2022_x/Hindcast_1990_2010/means/MLD

cd /Volumes/BM_2022_x/Hindcast_1990_2010/means
dir1=dir('Mean*.nc');
%% from 6 to 3 S
% dates_6_3 = ['2008M5', '2008M6', '2008M10', '2009M3', '2009M4', '2009M6', '2009M7', 
% '2009M8', '2009M9','2010M1','2010M2','2010M3','','','', ];
yrst=1990;
most=1;
yren=2010;
moen=12;
moen0=moen;
[Xv,Yv]=meshgrid(LON(:,1), LAT(1,1:end-1));
[Xu,Yu]=meshgrid(LON(1:end-1,1), LAT(1,:));


ij=0;
for iy=yrst:1:yren
    
    if iy>yrst
        most=1;
    end
    % if iy is equal to yren, then let most is moen0,
    if iy==yren
        moen=moen0;
        % otherwise 12
    else
        moen=12;
    end
    
    for imo=most:1:moen
        ij=ij+1;
        fn=sprintf('Mean_Y%dM%d.nc',iy,imo);
        disp(fn)

        %fn='Mean_Y2008M5.nc';
        
        s_rho=ncread(fn,'s_rho');
        s_w=ncread(fn,'s_w');
        
        zz=get_depths(fn,fn,1,'rho'); %we get the depths using all the rho variables
        
        % 12 S 
        indxlat12 = find(LAT(1,:)>= -15 & LAT(1,:)<=-14);
        indxlon12 = find(LON(:,1)>= -80.5 & LON(:,1)<=-75.5);
        
        start_lon = min(indxlon12);
        count_lon = length(indxlon12);
        start_lat = min(indxlat12);
        count_lat = length(indxlat12);

        start_time = 1;  % Assuming we want to start from the first time step
        count_time = Inf;  % Use Inf to read all time steps
        
        O2 = ncread(fn, 'O2', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time]);
        
        o2=permute(O2,[3 2 1 4]);
        zz1 = zz(:,indxlat12,indxlon12);
        
        jj=0;
        for ii=0:-10:-500
            jj=jj+1;
            O2new(:,:,jj) = vinterp(o2,zz1,ii);
              
            disp(ii)
        end
        
        O2_1415(:,:,ij) = permute(mean(O2new,1,'omitnan'),[2 3 1]);
        
        
    end
end

%% ------------ ENSO Dante ------------------ %
load('ENSO_DANTE_dates.mat');
timeNINO2(16)=[]; indxNINO2(16) = [];

%% ------------- V velocity under ENSO ------------------------ % 
load('UpwellingCenter_crosssection.mat')

V_NINO = mean(Vmean_1415(:,:,indxNINO2),3,'omitnan');
V_NINA = mean(Vmean_1415(:,:,indxNINA2),3,'omitnan');
V_NEUTRO = mean(Vmean_1415(:,:,indxNEUTRO2),3,'omitnan');

%% ------------- MLD ------------------ % 
load('MLD.mat');

MLD_N = squeeze(mean(MLD(indxlon12,indxlat12,:),2));
%% ---- Monthly Nitrogen Anomaly -------------- %

time = generate_monthly_time_vector(1990, 2010)';
[climTN, anomTN] = calculateClimatologyAndAnomalies(O2_1415, time);

%% ---------- Nitrogen under ENSO ----------- %

O2_NINO = mean(O2_1415(:,:,indxNINO2),3,'omitnan');
O2_NINA = mean(O2_1415(:,:,indxNINA2),3,'omitnan');
O2_NEUTRO = mean(O2_1415(:,:,indxNEUTRO2),3,'omitnan');

%--anomalies
O2_NINOa = mean(anomTN(:,:,indxNINO2),3,'omitnan');
O2_NINAa = mean(anomTN(:,:,indxNINA2),3,'omitnan');
O2_NEUTROa = mean(anomTN(:,:,indxNEUTRO2),3,'omitnan');

%---MLD 
MLD_NINO = mean(MLD_N(:,indxNINO2),2);
MLD_NINA = mean(MLD_N(:,indxNINA2),2);
MLD_NEUTRO = mean(MLD_N(:,indxNEUTRO2),2);

%% Values and Anom

Zi=[0:-10:-500]';
distance_km12 = calculate_longitudinal_distance(-14.5,5); %latitude, longitude
disti12 = flip(linspace(0,distance_km12,size(O2_NINO,1)));

figure
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');


subplot(2,3,1); hold on
pcolor(disti12,Zi,O2_NINO'); shading interp; cmocean('haline',24);
caxis([0 220]);
[C h]=contour(disti12, Zi, V_NINO'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, V_NINO'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-MLD_NINO,'linewidth',3,'Color','k');
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-250 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('Dissolved Oxygen 14-15S [NINO]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = 0:20:220;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mm \cdot O \cdot m^{-3}$','interpreter','latex'); % Add your desired label here

subplot(2,3,2); hold on
pcolor(disti12,Zi,O2_NINA'); shading interp; cmocean('haline',24);
[C h]=contour(disti12, Zi, V_NINA'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, V_NINA'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-MLD_NINA,'linewidth',3,'Color','k');
caxis([0 220]);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-250 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('Dissolved Oxygen 14-15S [NINA]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = 0:20:220;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mm \cdot O \cdot m^{-3}$','interpreter','latex'); % Add your desired label here

subplot(2,3,3); hold on
pcolor(disti12,Zi,O2_NEUTRO'); shading interp; cmocean('haline',24);
caxis([0 220]);
[C h]=contour(disti12, Zi, V_NEUTRO'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, V_NEUTRO'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-MLD_NINA,'linewidth',3,'Color','k');
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-250 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('Dissolved Oxygen 14S-15S [NEUTRO]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = 0:20:220;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mm \cdot O \cdot m^{-3}$','interpreter','latex'); % Add your desired label here
%----- Anomalies
subplot(2,3,4); hold on
pcolor(disti12,Zi,O2_NINOa'); shading interp; cmocean('balance',11);
caxis([-5 5]);
[C h]=contour(disti12, Zi, V_NINO'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, V_NINO'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-MLD_NINO,'linewidth',3,'Color','k');
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-250 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('DO anomaly 14-15S [NINO]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -5:1:5;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mm \cdot O \cdot m^{-3}$','interpreter','latex'); % Add your desired label here

subplot(2,3,5); hold on
pcolor(disti12,Zi,O2_NINAa'); shading interp; cmocean('balance',11);
[C h]=contour(disti12, Zi, V_NINA'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, V_NINA'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-MLD_NINA,'linewidth',3,'Color','k');
caxis([-5 5]);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-250 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('DO anomaly 14-15S [NINA]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -5:1:5;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mm \cdot O \cdot m^{-3}$','interpreter','latex'); % Add your desired label here

subplot(2,3,6); hold on
pcolor(disti12,Zi,O2_NEUTROa'); shading interp; cmocean('balance',11);
caxis([-5 5]);
[C h]=contour(disti12, Zi, V_NEUTRO'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, V_NEUTRO'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-MLD_NEUTRO,'linewidth',3,'Color','k');
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-250 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('DO anomaly 14S-15S [NEUTRO]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -5:1:5;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mm \cdot O \cdot m^{-3}$','interpreter','latex'); % Add your desired label here


