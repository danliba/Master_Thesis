%We will test how Nitrogen is a limiting nutrient in the Phytoplankton assimilating

%--------- Nitrogen
%---Small phytoplankton
%NFlux_NO2limitP1
%NFlux_NO3limitP1
%NFlux_NH4limitP1

%---Large Phytoplankton
%NFlux_NO2limitP2
%NFlux_NO3limitP2
%NFlux_NH4limitP2


%-------- Light 
%NFlux_lightlimitP1
%NFlux_lightlimitP2


%-------- Temperature
%NFlux_templimitP1
%NFlux_templimitP2 

%% read 

clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
cd /Volumes/BM_2022_x/Hindcast_1990_2010/flux

indxlat = find(LAT(1,:)>= -16 & LAT(1,:)<=-5);
indxlon = find(LON(:,1)>= -85 & LON(:,1)<=-75);

lati=LAT(1,indxlat); loni = LON(indxlon,1);
[LONi,LATi]=meshgrid(loni,lati);

%% 
hdir = dir('diabio_avg*');
yrst=1990;
most=1;
yren=2010;
moen=12;
moen0=moen;
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
        fn=hdir(ij).name;
        disp(fn)
        
        %fn = 'diabio_avg_Y1990M01.nc';
        indxlat = find(LAT(1,:)>= -16 & LAT(1,:)<=-5);
        indxlon = find(LON(:,1)>= -85 & LON(:,1)<=-75);
        
        start_lon = min(indxlon);
        count_lon = length(indxlon);
        start_lat = min(indxlat);
        count_lat = length(indxlat);
        
        start_time = 1;  % Assuming we want to start from the first time step
        count_time = Inf;  % Use Inf to read all time steps
        
        %---- depths
        zz=get_depths(fn,fn,1,'rho'); %we get the depths using all the rho variables
        
        %--- small phyto
        NO3P1=double(ncread(fn,'NFlux_NO3limitP1', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time]));
        NO2P1=double(ncread(fn,'NFlux_NO2limitP1',[start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time]));
        NH4P1=double(ncread(fn,'NFlux_NH4limitP1', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time]));
        %--- large phyto
        NO3P2=double(ncread(fn,'NFlux_NO3limitP2', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time]));
        NO2P2=double(ncread(fn,'NFlux_NO2limitP2', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time]));
        NH4P2=double(ncread(fn,'NFlux_NH4limitP2', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time]));
        
        NitroP1 = NO3P1+NO2P1+NH4P1;
        NitroP2 = NO3P2+NO2P2+NH4P2;
        
        NP1=permute(NitroP1,[3 2 1 4]);
        NP2=permute(NitroP2,[3 2 1 4]);
        
        zz1 = zz(:,indxlat,indxlon);
        
        jj=0;
        for ii=0:-10:-300
            jj=jj+1;
            NP11 = vinterp(NP1,zz1,ii); NP11(NP11==0)=NaN;
            NP1new(:,:,jj) = shift_coast_to_0km_ver2(NP11);
            
             NP22= vinterp(NP2,zz1,ii);NP22(NP22==0)=NaN;
             NP2new(:,:,jj) = shift_coast_to_0km_ver2(NP22);
            
            disp(ii)
        end
        %permute(mean(O2new,1,'omitnan'),[2 3 1]);
        NP1L(:,:,ij) = permute(mean(NP1new,1,'omitnan'),[2 3 1]);
        NP2L(:,:,ij) = permute(mean(NP2new,1,'omitnan'),[2 3 1]);
        
    end
end
%% save
save('Limitation_Nflux.mat','NP1L','NP2L');
NPL = NP2L + NP1L;
%% 
% figure
% for ii=32:-1:1
%     pcolor(LON,LAT,NitroP2(:,:,ii).*mask+NitroP1(:,:,ii).*mask); shading flat;colorbar;
%     title(['Sigma Layer ' num2str(ii)]) 
%     pause(1)
%     clf
% end
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
MLD_N = squeeze(mean(MLD(indxlon,indxlat,:),2));

%% ---- Monthly Nitrogen Anomaly -------------- %

time = generate_monthly_time_vector(1990, 2010)';
[climTN, anomTN] = calculateClimatologyAndAnomalies(NPL, time);

%% ---------- Nitrogen under ENSO ----------- %

NPL_NINO = mean(NPL(:,:,indxNINO2),3,'omitnan');
NPL_NINA = mean(NPL(:,:,indxNINA2),3,'omitnan');
NPL_NEUTRO = mean(NPL(:,:,indxNEUTRO2),3,'omitnan');

%--anomalies
NPL_NINOa = mean(anomTN(:,:,indxNINO2),3,'omitnan');
NPL_NINAa = mean(anomTN(:,:,indxNINA2),3,'omitnan');
NPL_NEUTROa = mean(anomTN(:,:,indxNEUTRO2),3,'omitnan');

%---MLD 
MLD_NINO = mean(MLD_N(:,indxNINO2),2);
MLD_NINA = mean(MLD_N(:,indxNINA2),2);
MLD_NEUTRO = mean(MLD_N(:,indxNEUTRO2),2);

%% PLOT
%% Values and Anom

Zi2=[0:-10:-300]';
Zi=[0:-10:-500]';

distance_km12 = calculate_longitudinal_distance(-14.5,5); %latitude, longitude
disti12 = flip(linspace(0,distance_km12,size(NPL_NINO,1)));

figure
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');


subplot(2,3,1); hold on
pcolor(disti12,Zi2,NPL_NINO'); shading interp; cmocean('haline',24);
caxis([0 1.6]);
[C h]=contour(disti12, Zi, V_NINO'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, V_NINO'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-MLD_NINO,'linewidth',3,'Color','k');
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-250 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('Lim Phyto assimilation N 14-15S [NINO]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = 0:0.2:1.6;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mm \cdot N \cdot m^{-3} \cdot s^{-1}$','interpreter','latex'); % Add your desired label here

subplot(2,3,2); hold on
pcolor(disti12,Zi2,NPL_NINA'); shading interp; cmocean('haline',24);
[C h]=contour(disti12, Zi, V_NINA'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, V_NINA'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-MLD_NINA,'linewidth',3,'Color','k');
caxis([0 1.6]);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-250 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('Lim Phyto assimilation N 14-15S [NINA]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = 0:0.2:1.6;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mm \cdot N \cdot m^{-3} \cdot s^{-1}$','interpreter','latex'); % Add your desired label here

subplot(2,3,3); hold on
pcolor(disti12,Zi2,NPL_NEUTRO'); shading interp; cmocean('haline',24);
caxis([0 1.6]);
[C h]=contour(disti12, Zi, V_NEUTRO'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, V_NEUTRO'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-MLD_NINA,'linewidth',3,'Color','k');
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-250 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('Lim Phyto assimilation N 14-15S [NEUTRO]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = 0:0.2:1.6;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mm \cdot N \cdot m^{-3} \cdot s^{-1}$','interpreter','latex'); % Add your desired label here
%----- Anomalies
subplot(2,3,4); hold on
pcolor(disti12,Zi2,NPL_NINOa'); shading interp; cmocean('balance',11);
caxis([-0.02 0.02]);
[C h]=contour(disti12, Zi, V_NINO'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, V_NINO'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-MLD_NINO,'linewidth',3,'Color','k');
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-250 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('LPA N anomaly 14-15S [NINO]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -0.02:0.005:0.02;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mm \cdot N \cdot m^{-3} \cdot s^{-1}$','interpreter','latex'); % Add your desired label here

subplot(2,3,5); hold on
pcolor(disti12,Zi2,NPL_NINAa'); shading interp; cmocean('balance',11);
[C h]=contour(disti12, Zi, V_NINA'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, V_NINA'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-MLD_NINA,'linewidth',3,'Color','k');
caxis([-0.02 0.02]);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-250 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('LPA N anomaly 14-15S [NINA]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -0.02:0.005:0.02;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mm \cdot N \cdot m^{-3} \cdot s^{-1}$','interpreter','latex'); % Add your desired label here

subplot(2,3,6); hold on
pcolor(disti12,Zi2,NPL_NEUTROa'); shading interp; cmocean('balance',11);
caxis([-0.02 0.02]);
[C h]=contour(disti12, Zi, V_NEUTRO'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, V_NEUTRO'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-MLD_NEUTRO,'linewidth',3,'Color','k');
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-250 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('LPA N anomaly 14-15S [NINO]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -0.02:0.005:0.02;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mm \cdot N \cdot m^{-3} \cdot s^{-1}$','interpreter','latex'); % Add your desired label here


