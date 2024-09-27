clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
cd /Volumes/BM_2022_x/Hindcast_1990_2010/flux
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
        indxlat = find(LAT(1,:)>= -20 & LAT(1,:)<=-5);
        indxlon = find(LON(:,1)>= -90 & LON(:,1)<=-70);
        
        start_lon = min(indxlon);
        count_lon = length(indxlon);
        start_lat = min(indxlat);
        count_lat = length(indxlat);
        
        start_time = 1;  % Assuming we want to start from the first time step
        count_time = Inf;  % Use Inf to read all time steps
        
        %--- small phyto
        NO3P1=double(ncread(fn,'NFlux_ProdNO3P1', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time]));
        NO3P2=double(ncread(fn,'NFlux_ProdNO3P2', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time]));
        NO2P1=double(ncread(fn,'NFlux_ProdNO2P1', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time]));
        NO2P2=double(ncread(fn,'NFlux_ProdNO2P2', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time]));
        NH4P1=double(ncread(fn,'NFlux_ProdNH4P1', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time]));
        NH4P2=double(ncread(fn,'NFlux_ProdNH4P2', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time]));
        
        zr=get_depths(fn,fn,1,'rho'); %we get the depths using all the rho variables
        zw=get_depths(fn,fn,1,'w'); %we get the depths using all the wi variables
        
        zzr=zr(:,indxlat,indxlon);
        zzw=zw(:,indxlat,indxlon);
        
        [no3p1,~]=vintegr2(permute(NO3P1,[3 2 1]),zw(:,indxlat,indxlon),zr(:,indxlat,indxlon),NaN,NaN);
        [no3p2,~]=vintegr2(permute(NO3P2,[3 2 1]),zw(:,indxlat,indxlon),zr(:,indxlat,indxlon),NaN,NaN);
        [no2p1,~]=vintegr2(permute(NO2P1,[3 2 1]),zw(:,indxlat,indxlon),zr(:,indxlat,indxlon),NaN,NaN);
        [no2p2,~]=vintegr2(permute(NO2P2,[3 2 1]),zw(:,indxlat,indxlon),zr(:,indxlat,indxlon),NaN,NaN);
        [nh4p1,~]=vintegr2(permute(NH4P1,[3 2 1]),zw(:,indxlat,indxlon),zr(:,indxlat,indxlon),NaN,NaN);
        [nh4p2,~]=vintegr2(permute(NH4P2,[3 2 1]),zw(:,indxlat,indxlon),zr(:,indxlat,indxlon),NaN,NaN);
        
        PP_flux(:,:,ij) = no3p1+no3p2+no2p1+no2p2+nh4p1+nh4p2;
        
    end
end
%% save
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Table_BIOGE
save('PP_flux_BIOGEO_region.mat','PP_flux');
%% --------- Anom and Clim --------------------------------%%
%load('PP_flux.mat');
indxlat = find(LAT(1,:)>= -16 & LAT(1,:)<=-5);
indxlon = find(LON(:,1)>= -90 & LON(:,1)<=-70);
       
loni = LON(indxlon,indxlat); 
lati = LAT(indxlon,indxlat);

time = generate_monthly_time_vector(1990, 2010)';
[climZoo, anom_PPflux] = calculateClimatologyAndAnomalies(PP_flux, time);

%% -------------------- TS -------------------------------- %%
nPP_flux = calculate_URegion(permute(PP_flux,[2 1 3]), loni, lati, mask(indxlon,indxlat));
nPP_flux2 = calculate_URegion(permute(anom_PPflux,[2 1 3]), loni, lati, mask(indxlon,indxlat)); % ANOM

PP_flux_ts = mean(nPP_flux,1,'omitnan')';
PP_flux_ts_a = mean(nPP_flux2,1,'omitnan')';

PP_flux_lati = mean(nPP_flux,2,'omitnan');
PP_flux_lati_a = mean(nPP_flux2,2,'omitnan');
%% save to table
% T = array2table(cat(2,time,PP_flux_ts, PP_flux_ts_a));
% T.Properties.VariableNames{1} = 'time';
% T.Properties.VariableNames{2} = 'PP_flux_ts';
% T.Properties.VariableNames{3} = 'PP_flux_ts_a';
% 
% filename = 'Integrated_pp_flux.xlsx';
% writetable(T,filename,'Sheet',1);
% 
% T2 = array2table(cat(2,lati(1,:)',PP_flux_lati, PP_flux_lati_a));
% T2.Properties.VariableNames{1} = 'time';
% T2.Properties.VariableNames{2} = 'PP_flux_lat';
% T2.Properties.VariableNames{3} = 'PP_flux_lat_a';
% 
% filename = 'Integrated_pp_flux_lat.xlsx';
% writetable(T2,filename,'Sheet',1);

%% ------------- Load ENSO by DANTE ----------------- %%
load('ENSO_DANTE_dates.mat');
timeNINO2(16)=[]; indxNINO2(16)=[];
fsize=20;
[~,ylab] = generateYLabels(20,4,2);

grey = [0.5 0.5 0.5];
brown = [165, 42, 42] ./ 255;
dark_green = [0, 100, 0] ./ 255;
blue_green = [0, 128, 128] ./ 255;
yellow_orange = [255, 204, 102] / 255;
%%  total mean
%% plot

trp = 0.3;
wz = 13;
arr= ones(length(timeNINO2), 1); arr2=ones(length(timeNINA2),1);
arr(arr==1)=1000; arr2(arr2==1)=1000;
arr3(arr==1000)=-1000; arr4(arr2==1000)=-1000;

figure
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(2,1,1); hold on
bar(timeNINO2,arr3, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINA2,arr4, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
plot(time,movmean(PP_flux_ts*86400,13),'Color',blue_green,'linewidth',4,'linestyle','-');
%plot(time,movmean(PP_flux_ts*86400,wz),'Color',yellow_orange,'linewidth',4,'linestyle','-');
datetick('x'); ylim([24 34]);
title('Integrated Primary Production Flux'); box on;
ax = gca;
ax.FontSize = fsize;
grid on
ylabel('$\mathrm{mmol \cdot N \cdot m^{-2} \cdot day^{-1}}$','interpreter','latex');

subplot(2,1,2); hold on
bar(timeNINO2,arr3, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINA2,arr4, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
plot(time,PP_flux_ts_a*86400,'Color',grey,'linewidth',1,'linestyle','-');
plot(time,movmean(PP_flux_ts_a*86400,wz),'Color',blue_green,'linewidth',4,'linestyle','-');

datetick('x'); ylim([-6 8]); box on;
title('Integrated Primary Production Flux Anomaly');
ax = gca;
ax.FontSize = fsize;
grid on
ylabel('$\mathrm{mmol \cdot N \cdot m^{-2} \cdot day^{-1}}$','interpreter','latex');

%% Climatology

for ii = 1:1:12
    
    subplot(3,4,ii)
    pcolor(loni,lati,climZoo(:,:,ii)'*86400); shading flat; colorbar; axis square;
    title(['Month: ',num2str(ii)]); caxis([0 40]);
end

%% clim 1D
fsize =20;
clim = squeeze(mean(reshape(PP_flux_ts,[21 12]),1,'omitnan'))';
xlab ={'J','F','M','A','M','J','J','A','S','O','N','D'};
%subplot(1,2,1)
figure
plot([1:12],clim*86400,'linewidth',2,'Color',brown);
hold on
h=boxplot(reshape(PP_flux_ts*86400,[21 12]),'Color',yellow_orange);
set(h,{'linew'},{2})
title('Integrated Primary Production Flux climatology');
ax = gca;
ax.FontSize = fsize; 
xlabel('Months');
grid on
ylabel('$\mathrm{mmol \cdot N \cdot m^{-2} \cdot day^{-1}}$','interpreter','latex');
axis square

set(gca,'xtick',[1:1:12],'xticklabel',xlab);
close all;
% subplot(1,2,2)
% h=boxplot(reshape(PP_flux_ts,[21 12]),'Color',yellow_orange);
% set(h,{'linew'},{2})


