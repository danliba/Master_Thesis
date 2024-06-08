clear all; close all; clc;
[mask,LON,LAT,~,path1]=lets_get_started;
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/SST;

load('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/SST/SST.mat');
%% Processing
time = generate_monthly_time_vector(1990, 2010)';
nSST = calculate_URegion(SSTi, LON, LAT, mask);
[climSST, SST_anom] = calculateClimatologyAndAnomalies(nSST, time);

TS_sst = mean(nSST,1,'omitnan')';
TS_ssta = mean(SST_anom,1,'omitnan')';

%% ENSO
load('ENSO_DANTE_dates.mat');
timeNINO2(16)=[]; indxNINO2(16)=[];

grey = [0.5 0.5 0.5];
brown = [165, 42, 42] ./ 255;
dark_green = [0, 100, 0] ./ 255;
blue_green = [0, 128, 128] ./ 255;

%% TS
trp = 0.3;
arr= ones(length(timeNINO2), 1); arr2=ones(length(timeNINA2),1);
arr(arr==1)=1000; arr2(arr2==1)=1000;
fsize = 20;
%bar(indxveda,arr)
%bar(timeNINO2,arr, 'FaceColor', [0.9 0.9 0.9], 'EdgeColor', 'none');

figure
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*3/2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(3,1,1)
bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
plot(time,TS_sst,'Color',grey,'linewidth',0.5,'linestyle','-'); hold on;
plot(time,movmean(TS_sst,13),'Color',brown,'linewidth',2,'linestyle','-');
datetick('x'); ylim([16 28]);
title('Temperature');
ax = gca;
ax.FontSize = fsize;
grid on
ylabel('$\circC}$','interpreter','latex');

subplot(3,1,3)
bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
plot(time,phyto_ts,'Color',blue_green,'linewidth',2,'linestyle','-');
datetick('x'); ylim([0 8]);
title('Phytoplankton');
ax = gca;
ax.FontSize = fsize;
grid on
ylabel('$\mathrm{mmol \cdot N \cdot m^{-3}}$','interpreter','latex');
