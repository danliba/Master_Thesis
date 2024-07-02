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

indxlat = find(LAT(1,:)>= -16 & LAT(1,:)<=-5);
indxlon = find(LON(:,1)>= -85 & LON(:,1)<=-75);

lati=LAT(1,indxlat); loni = LON(indxlon,1);
[LONi,LATi]=meshgrid(loni,lati);

%% from 6 to 3 S
% dates_6_3 = ['2008M5', '2008M6', '2008M10', '2009M3', '2009M4', '2009M6', '2009M7', 
% '2009M8', '2009M9','2010M1','2010M2','2010M3','','','', ];
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
        fn=sprintf('Mean_Y%dM%d.nc',iy,imo);
        disp(fn)

        %fn='Mean_Y2008M5.nc';
        
        s_rho=ncread(fn,'s_rho');
        s_w=ncread(fn,'s_w');
        
        zz=get_depths(fn,fn,1,'rho'); %we get the depths using all the rho variables
        
        % 12 S 
        indxlat12 = find(LAT(1,:)>= -16 & LAT(1,:)<=-5);
        indxlon12 = find(LON(:,1)>= -85 & LON(:,1)<=-75);
        
        start_lon = min(indxlon12);
        count_lon = length(indxlon12);
        start_lat = min(indxlat12);
        count_lat = length(indxlat12);

        start_time = 1;  % Assuming we want to start from the first time step
        count_time = Inf;  % Use Inf to read all time steps
        
        NO3 = ncread(fn, 'NO3', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time]);
        NO2 = ncread(fn,'NO2', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time]);
        NH4 = ncread(fn,'NH4', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time]);
        
        no3=permute(NO3,[3 2 1 4]);
        no2=permute(NO2,[3 2 1 4]);
        nh4=permute(NH4,[3 2 1 4]);
        zz1 = zz(:,indxlat12,indxlon12);
        
        jj=0;
        for ii=0:-10:-500
            jj=jj+1;
            NO3_2 = vinterp(no3,zz1,ii); NO3_2(NO3_2==0)=NaN;
            NO3new(:,:,jj) = shift_coast_to_0km_ver2(NO3_2);
            
            NO2_1 = vinterp(no2,zz1,ii);  NO2_1(NO2_1==0)=NaN;
            NO2new(:,:,jj) = shift_coast_to_0km_ver2(NO2_1);
             
            NH4_1 = vinterp(nh4,zz1,ii); NH4_1(NH4_1==0)=NaN;
            NH4new(:,:,jj) = shift_coast_to_0km_ver2(NH4_1);
            
            disp(ii)
        end
        
        NO3_1415(:,:,ij) = permute(mean(NO3new,1,'omitnan'),[2 3 1]);
        NO2_1415(:,:,ij) = permute(mean(NO2new,1,'omitnan'),[2 3 1]);
        NH4_1415(:,:,ij) = permute(mean(NH4new,1,'omitnan'),[2 3 1]);
        
        
    end
end

%% 
Total_N1415= NO3_1415 + NO2_1415 + NH4_1415;
save('Cross_shore_composit_5_16.mat','Total_N1415','NO3_1415','NO2_1415','NH4_1415');
%% 
%% ------------ ENSO Dante ------------------ %
load('ENSO_DANTE_dates.mat');
timeNINO2(16)=[]; indxNINO2(16) = [];

load('NINO9798.mat');
%% ------------- V velocity under ENSO ------------------------ % 
load('5_16S_composite_cross_section.mat')

V_NINO = mean(Vmean_1415(loncut,:,indxNINO2),3,'omitnan');
V_NINA = mean(Vmean_1415(loncut,:,indxNINA2),3,'omitnan');
V_NEUTRO = mean(Vmean_1415(loncut,:,indxNEUTRO2),3,'omitnan');
V_NINO97_98 = mean(Vmean_1415(loncut,:,EN9798_index),3,'omitnan');

%% ------------- MLD ------------------ % 
load('MLD.mat');
%NO3_2(NO3_2==0)=NaN;
%NO3new(:,:,jj) = shift_coast_to_0km_ver2(NO3_2);

MLD_N1 = MLD(indxlon12,indxlat12,:); MLD_N1(MLD_N1==0)=NaN;
for ik=1:1:size(MLD_N1,3)
    MLD_new(:,:,ik) = shift_coast_to_0km_ver2(MLD_N1(:,:,ik)');
end
MLD_N = squeeze(mean(MLD_new,2,'omitnan'));%latitudinal mean
%% ---- Monthly Nitrogen Anomaly -------------- %

time = generate_monthly_time_vector(1990, 2010)';
[climTN, anomTN] = calculateClimatologyAndAnomalies(Total_N1415, time);

loncut = find(loni>= -80);
%% ---------- Nitrogen under ENSO ----------- %

N_NINO = mean(Total_N1415(loncut,:,indxNINO2),3,'omitnan');
N_NINA = mean(Total_N1415(loncut,:,indxNINA2),3,'omitnan');
N_NEUTRO = mean(Total_N1415(loncut,:,indxNEUTRO2),3,'omitnan');
N_NINO9798 = mean(Total_N1415(loncut,:,EN9798_index),3,'omitnan');

%--anomalies
N_NINOa = mean(anomTN(loncut,:,indxNINO2),3,'omitnan');
N_NINAa = mean(anomTN(loncut,:,indxNINA2),3,'omitnan');
N_NEUTROa = mean(anomTN(loncut,:,indxNEUTRO2),3,'omitnan');

%---MLD 
MLD_NINO = mean(MLD_N(loncut,indxNINO2),2);
MLD_NINA = mean(MLD_N(loncut,indxNINA2),2);
MLD_NEUTRO = mean(MLD_N(loncut,indxNEUTRO2),2);
%EN9798_index
MLD_NINO9798 = mean(MLD_N(loncut,EN9798_index),2);

%% 
figure;hold on; 
plot(disti12,-MLD_NINA,'linewidth',3); 
plot(disti12,-MLD_NINO,'linewidth',3); 
plot(disti12,-MLD_NEUTRO,'linewidth',3);
plot(disti12,-MLD_NINO9798,'linewidth',2,'Color','r','linestyle','--'); 

set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
xlim([0 300]); title('Mixed Layer Depth [5-16S]');
legend('Nina','Nino','Neutral','Nino 97/98');
ax = gca;
ax.FontSize = 20;
box on;
grid on
%% Values and Anom

Zi=[0:-10:-500]';
distance_km12 = calculate_longitudinal_distance(-12,5); %latitude, longitude
disti12 = flip(linspace(0,distance_km12,size(N_NINO,1)));

figure
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');


subplot(2,3,1); hold on
pcolor(disti12,Zi,N_NINO'); shading interp; cmocean('haline',16);
caxis([0 35]);
[C h]=contour(disti12, Zi, V_NINO'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, V_NINO'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-MLD_NINO,'linewidth',3,'Color','k');
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-250 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('Total Nitrogen 5-16S [NINO]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = 0:5:35;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mm \cdot N \cdot m^{-3}$','interpreter','latex'); % Add your desired label here

subplot(2,3,2); hold on
pcolor(disti12,Zi,N_NINA'); shading interp; cmocean('haline',16);
[C h]=contour(disti12, Zi, V_NINA'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, V_NINA'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-MLD_NINA,'linewidth',3,'Color','k');
caxis([0 35]);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-250 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('Total Nitrogen 5-16S [NINA]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = 0:5:35;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mm \cdot N \cdot m^{-3}$','interpreter','latex'); % Add your desired label here

subplot(2,3,3); hold on
pcolor(disti12,Zi,N_NEUTRO'); shading interp; cmocean('haline',16);
caxis([0 35]);
[C h]=contour(disti12, Zi, V_NEUTRO'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, V_NEUTRO'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-MLD_NINA,'linewidth',3,'Color','k');
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-250 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('Total Nitrogen 5-16S [NEUTRO]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = 0:5:35;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mm \cdot N \cdot m^{-3}$','interpreter','latex'); % Add your desired label here
%----- Anomalies
subplot(2,3,4); hold on
pcolor(disti12,Zi,N_NINOa'); shading interp; cmocean('balance',15);
caxis([-1.5 1.5]);
[C h]=contour(disti12, Zi, V_NINO'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, V_NINO'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-MLD_NINO,'linewidth',3,'Color','k');
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-250 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('TN anomaly 5-16S [NINO]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -1.5:0.5:1.5;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mm \cdot N \cdot m^{-3}$','interpreter','latex'); % Add your desired label here

subplot(2,3,5); hold on
pcolor(disti12,Zi,N_NINAa'); shading interp; cmocean('balance',15);
[C h]=contour(disti12, Zi, V_NINA'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, V_NINA'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-MLD_NINA,'linewidth',3,'Color','k');
caxis([-1.5 1.5]);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-250 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('TN anomaly 5-16S [NINA]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -1.5:0.5:1.5;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mm \cdot N \cdot m^{-3}$','interpreter','latex'); % Add your desired label here

subplot(2,3,6); hold on
pcolor(disti12,Zi,N_NEUTROa'); shading interp; cmocean('balance',15);
caxis([-1.5 1.5]);
[C h]=contour(disti12, Zi, V_NEUTRO'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, V_NEUTRO'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
plot(disti12,-MLD_NEUTRO,'linewidth',3,'Color','k');
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-250 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('TN anomaly 5-16S [NEUTRO]');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -1.5:0.5:1.5;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
ylabel(c, '$mm \cdot N \cdot m^{-3}$','interpreter','latex'); % Add your desired label here




%% I dont understand this plot, i wont put it.
flag=1;
if flag ==1
    Zi=[0:-10:-500]';
    distance_km12 = calculate_longitudinal_distance(-12,5); %latitude, longitude
    disti12 = flip(linspace(0,distance_km12,size(N_NINO,1)));
    
    figure
    P=get(gcf,'position');
    P(3)=P(3)*3;
    P(4)=P(4)*2;
    set(gcf,'position',P);
    set(gcf,'PaperPositionMode','auto');
    
    subplot(2,4,1); hold on
    pcolor(disti12,Zi,N_NEUTRO'); shading interp; cmocean('haline',16);
    caxis([0 35]);
    [C h]=contour(disti12, Zi, V_NEUTRO'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
    [C h]=contour(disti12, Zi, V_NEUTRO'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
    plot(disti12,-MLD_NEUTRO,'linewidth',3,'Color','k');
    set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
    ylim([-250 0]);ylabel('Depth [m]')
    xlim([0 250])
    box on
    title('TN 14S-15S [NEUTRO]');
    colorbar
    ax = gca;
    ax.FontSize = 20;
    ticks = 0:5:35;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    ylabel(c, '$mm \cdot N \cdot m^{-3}$','interpreter','latex'); % Add your desired label here

    subplot(2,4,2); hold on
    pcolor(disti12,Zi,N_NINO'); shading interp; cmocean('haline',16);
    caxis([0 35]);
    [C h]=contour(disti12, Zi, V_NINO'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
    [C h]=contour(disti12, Zi, V_NINO'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
    plot(disti12,-MLD_NINO,'linewidth',3,'Color','k');
    set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
    ylim([-250 0]);%ylabel('Depth [m]')
    xlim([0 250])
    box on
    title('TN anomaly 5-16S [NINO]');
    colorbar
    ax = gca;
    ax.FontSize = 20;
    ticks = 0:5:35;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    ylabel(c, '$mm \cdot N \cdot m^{-3}$','interpreter','latex'); % Add your desired label here
    
    subplot(2,4,3); hold on
    pcolor(disti12,Zi,N_NINA'); shading interp; cmocean('haline',16);
    [C h]=contour(disti12, Zi, V_NINA'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
    [C h]=contour(disti12, Zi, V_NINA'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
    caxis([0 35]);
    plot(disti12,-MLD_NINA,'linewidth',3,'Color','k');
    set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
    ylim([-250 0]);%ylabel('Depth [m]')
    xlim([0 250])
    box on
    title('TN 5-16S [NINA]');
    colorbar
    ax = gca;
    ax.FontSize = 20;
    ticks = 0:5:35;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    ylabel(c, '$mm \cdot N \cdot m^{-3}$','interpreter','latex'); % Add your desired label here
    
    
    subplot(2,4,4); hold on
    pcolor(disti12,Zi,N_NINO9798'); shading interp; cmocean('haline',16);
    caxis([0 35]);
    [C h]=contour(disti12, Zi, V_NINO97_98'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
    [C h]=contour(disti12, Zi, V_NINO97_98'*100, [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
    plot(disti12,-MLD_NINO,'linewidth',3,'Color','k');
    set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
    ylim([-250 0]);%ylabel('Depth [m]')
    xlim([0 250])
    box on
    title('TN 5-16S [NINO 97/98]');
    colorbar
    ax = gca;
    ax.FontSize = 20;
    ticks = 0:5:35;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    ylabel(c, '$mm \cdot N \cdot m^{-3}$','interpreter','latex'); % Add your desired label here

    
    subplot(2,4,6); hold on
    pcolor(disti12,Zi,(N_NINO-N_NEUTRO)'); shading interp; cmocean('balance',15);
    caxis([-3 3]);
    [C h]=contour(disti12, Zi, V_NEUTRO'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:0],'color',[.5 .5 .5],'fontsize',14);
    plot(disti12,-MLD_NEUTRO,'linewidth',3,'Color','k');
    set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
    ylim([-250 0]);ylabel('Depth [m]')
    xlim([0 250])
    box on
    title('TN 5-16S [NINO - NEUTRO]');
    colorbar
    ax = gca;
    ax.FontSize = 20;
    ticks = -3:1:3;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    ylabel(c, '$mm \cdot N \cdot m^{-3}$','interpreter','latex'); % Add your desired label here
    
    
    subplot(2,4,7); hold on
    pcolor(disti12,Zi,(N_NINA-N_NEUTRO)'); shading interp; cmocean('balance',15);
    caxis([-3 3]);
    [C h]=contour(disti12, Zi, V_NEUTRO'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:0],'color',[.5 .5 .5],'fontsize',14);
    plot(disti12,-MLD_NEUTRO,'linewidth',3,'Color','k');
    set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
    ylim([-250 0]);%ylabel('Depth [m]')
    xlim([0 250])
    box on
    title('TN 5S-16S [NINA - NEUTRO]');
    colorbar
    ax = gca;
    ax.FontSize = 20;
    ticks = -3:1:3;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    ylabel(c, '$mm \cdot N \cdot m^{-3}$','interpreter','latex'); % Add your desired label here
    
    subplot(2,4,8); hold on
    pcolor(disti12,Zi,(N_NINO9798-N_NEUTRO)'); shading interp; cmocean('balance',15);
    caxis([-3 3]);
    [C h]=contour(disti12, Zi, V_NEUTRO'*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:0],'color',[.5 .5 .5],'fontsize',14);
    plot(disti12,-MLD_NEUTRO,'linewidth',3,'Color','w');
    set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
    ylim([-250 0]);%ylabel('Depth [m]')
    xlim([0 250])
    box on
    title('TN 5-16S [NINO97/98 - NEUTRO]');
    colorbar
    ax = gca;
    ax.FontSize = 20;
    ticks = -3:1:3;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    ylabel(c, '$mm \cdot N \cdot m^{-3}$','interpreter','latex'); % Add your desired label here

end

