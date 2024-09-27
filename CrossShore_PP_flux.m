%% Monthly average
clear all; close all; clc;
[mask,LON,LAT,~]=lets_get_started;
mask(mask==0)=NaN;
%cd /Volumes/BM_2022_x/Hindcast_1990_2010/means/MLD

cd /Volumes/BM_2022_x/Hindcast_1990_2010/flux
hdir = dir('*diabio_avg*');

%% loni
indxlon = find(LON(:,1)>= -85 & LON(:,1)<=-75);
loni = LON(indxlon,1);
%% 

ij=0;
for ik=1:1:length(hdir)
        fn=hdir(ik).name;
        disp(fn)
        
                
        s_rho=ncread(fn,'s_rho');
        s_w=ncread(fn,'s_w');
        
        zz=get_depths(fn,fn,1,'rho'); %we get the depths using all the rho variables
        

        %fn = 'diabio_avg_Y1990M01.nc';
        indxlat = find(LAT(1,:)>= -16 & LAT(1,:)<=-5);
        indxlon = find(LON(:,1)>= -85 & LON(:,1)<=-75);
        
        start_lon = min(indxlon);
        count_lon = length(indxlon);
        start_lat = min(indxlat);
        count_lat = length(indxlat);
        
        start_time = 1;  % Assuming we want to start from the first time step
        count_time = Inf;  % Use Inf to read all time steps
        
        %--- small phyto
        NO3P1=permute(double(ncread(fn,'NFlux_ProdNO3P1', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time])),[3 2 1 4]);
        NO3P2=permute(double(ncread(fn,'NFlux_ProdNO3P2', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time])),[3 2 1 4]);
        NO2P1=permute(double(ncread(fn,'NFlux_ProdNO2P1', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time])),[3 2 1 4]);
        NO2P2=permute(double(ncread(fn,'NFlux_ProdNO2P2', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time])),[3 2 1 4]);
        NH4P1=permute(double(ncread(fn,'NFlux_ProdNH4P1', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time])),[3 2 1 4]);
        NH4P2=permute(double(ncread(fn,'NFlux_ProdNH4P2', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time])),[3 2 1 4]);
                
        zz1 = zz(:,indxlat,indxlon);
        
        jj=0;
        for ii=0:-10:-500
            
            jj=jj+1;
            %vnew1 = vinterp(vv,zz1,ii);  vnew1(vnew1==0)=NaN; 
            NO3P1_new1 = vinterp(NO3P1,zz1,ii); NO3P1_new1(NO3P1_new1==0)=NaN;
            NO3P2_new1 = vinterp(NO3P2,zz1,ii); NO3P2_new1(NO3P2_new1==0)=NaN;
            NO2P1_new1 = vinterp(NO2P1,zz1,ii); NO2P1_new1(NO2P1_new1==0)=NaN;
            NO2P2_new1 = vinterp(NO2P2,zz1,ii); NO2P2_new1(NO2P2_new1==0)=NaN;
            NH4P1_new1 = vinterp(NH4P1,zz1,ii); NH4P1_new1(NH4P1_new1==0)=NaN;
            NH4P2_new1 = vinterp(NH4P2,zz1,ii); NH4P2_new1(NH4P2_new1==0)=NaN;
            
            
            no3p1 = shift_coast_to_0km_ver2(NO3P1_new1);
            no3p2 = shift_coast_to_0km_ver2(NO3P2_new1);
            no2p1 = shift_coast_to_0km_ver2(NO2P1_new1);
            no2p2 = shift_coast_to_0km_ver2(NO2P2_new1);
            nh4p1 = shift_coast_to_0km_ver2(NH4P1_new1);
            nh4p2 = shift_coast_to_0km_ver2(NH4P2_new1);
            
            PP_flux(:,:,jj) = no3p1+no3p2+no2p1+no2p2+nh4p1+nh4p2;
            disp(ii)
        end
         
        %PP_flux(:,:,ij) = no3p1+no3p2+no2p1+no2p2+nh4p1+nh4p2;
        
        PP_fluxes(:,:,ik) = permute(mean(PP_flux,1,'omitnan'),[2 3 1]);

        
    end
%% 

save('PP_flux_Cross_shore.mat','PP_fluxes');
%% load 
indxlat = find(LAT(1,:)>= -16 & LAT(1,:)<=-5);
indxlon = find(LON(:,1)>= -85 & LON(:,1)<=-75);

loncut = find(loni>= -80);

load('ENSO_DANTE_dates.mat');
timeNINO2(16)=[]; indxNINO2(16) = [];

noNINOIndex = cat(1,[1:87]',[107:252]');

load('NINO9798.mat');
%%  V 
load('5_16S_composite_cross_section.mat')

V_NINO = mean(Vmean_1415(loncut,:,indxNINO2),3,'omitnan');
V_NINA = mean(Vmean_1415(loncut,:,indxNINA2),3,'omitnan');
V_NEUTRO = mean(Vmean_1415(loncut,:,indxNEUTRO2),3,'omitnan');
V_NINO97_98 = mean(Vmean_1415(loncut,:,EN9798_index),3,'omitnan');
V_NEUTRO2 = mean(Vmean_1415(loncut,:,noNINOIndex),3,'omitnan');

%% ------------- MLD ------------------ % 

load('MLD.mat');
%NO3_2(NO3_2==0)=NaN;
%NO3new(:,:,jj) = shift_coast_to_0km_ver2(NO3_2);

MLD_N1 = MLD(indxlon,indxlat,:); MLD_N1(MLD_N1==0)=NaN;
for ik=1:1:size(MLD_N1,3)
    MLD_new(:,:,ik) = shift_coast_to_0km_ver2(MLD_N1(:,:,ik)');
end
MLD_N = squeeze(mean(MLD_new,2,'omitnan'));%latitudinal mean

%---MLD 
MLD_NINO = mean(MLD_N(loncut,indxNINO2),2);
MLD_NINA = mean(MLD_N(loncut,indxNINA2),2);
MLD_NEUTRO = mean(MLD_N(loncut,indxNEUTRO2),2);
%EN9798_index
MLD_NINO9798 = mean(MLD_N(loncut,EN9798_index),2);
MLD_NEUTRO2 = mean(MLD_N(loncut,noNINOIndex),2);

%%
loncut = find(loni>= -80);
NINO_PP_flux = mean(PP_fluxes(loncut,:,EN9798_index),3,'omitnan');
Neutro_PP_flux = mean(PP_fluxes(loncut,:,indxNEUTRO2),3,'omitnan');
Neutro_PP_flux2 = mean(PP_fluxes(loncut,:,noNINOIndex),3,'omitnan');

    Zi=[0:-10:-500]';
    distance_km12 = calculate_longitudinal_distance(-12,5); %latitude, longitude
    disti12 = flip(linspace(0,distance_km12,size(NINO_PP_flux,1)));
    
    figure; 
    subplot(1,2,2);hold on
    pcolor(disti12,Zi,log10(NINO_PP_flux')); shading interp; cmocean('balance',17);
    caxis([-20 -5]);
    [C h]=contour(disti12, Zi,V_NINO97_98'.*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
    [C h]=contour(disti12, Zi, V_NINO97_98', [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
    set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
    ylim([-300 0]);ylabel('Depth [m]')
    xlim([0 250])
    box on
    title('NINO 5S-16S');
    colorbar
    ax = gca;
    ax.FontSize = 20;
    ticks = -20:2:5;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    ylabel(c, 'mm N m^{-3} day^{-1}'); % Add your desired label here

   subplot(1,2,1);hold on
    pcolor(disti12,Zi,log10(Neutro_PP_flux')); shading interp; cmocean('balance',17);
    caxis([-20 -5]);
    [C h]=contour(disti12, Zi,V_NEUTRO'.*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
    [C h]=contour(disti12, Zi, V_NEUTRO', [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
    set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
    ylim([-300 0]);ylabel('Depth [m]')
    xlim([0 250])
    box on
    title('NEUTRO 5S-16S');
    colorbar
    ax = gca;
    ax.FontSize = 20;
    ticks = -20:2:5;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    ylabel(c, 'mm N m^{-3} day^{-1}'); % Add your desired label here

    %% difference
    figure;hold on
    pcolor(disti12,Zi,[NINO_PP_flux-Neutro_PP_flux2]'*86400); shading interp; cmocean('balance',17);
    caxis([-0.2 0.2]);
    [C h]=contour(disti12, Zi,V_NEUTRO2'.*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color','k');
    clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
    [C h]=contour(disti12, Zi,V_NINO97_98'.*100, [-50:10:0],'Color',[.5 .5 .5],'linestyle','--','linewidth',2);
    clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
    plot(disti12,-MLD_NINO9798,'linewidth',3,'Color',[.5 .5 .5]);
    %MLD_NEUTRO
    plot(disti12,-MLD_NEUTRO2,'linewidth',3,'Color','k');
    [C h]=contour(disti12, Zi, V_NEUTRO2', [0:10:50],'w-','linestyle',':','linewidth',2,'Color','k');
    clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
    set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
    ylim([-50 0]);ylabel('Depth [m]')
    xlim([0 200])
    box on
    title('EN97/98 - NEUTRO');
    c=colorbar;
    ax = gca;
    ax.FontSize = 20;
%     ticks = [-2:0.5:2]*10^-6;
%     c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
   %  ylabel(c, 'mm N m^{-3} day^{-1}'); % Add your desired label here

ylabel(c, '$mmol \cdot N \cdot m^{-3} \cdot day^{-1}$','interpreter','latex'); % Add your desired label here
