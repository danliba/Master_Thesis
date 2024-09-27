clear all; close all; clc; 
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
cd /Volumes/BM_2019_01/For_Daniel/biomass
Humboldt_ports;
load('Biomass_surface_GOOD.mat','Schla');
load('Biomass_integrated.mat');
load('PP_flux.mat')

%%
indxlat = find(LAT(1,:)>= -20 & LAT(1,:)<=-5);
indxlon = find(LON(:,1)>= -90 & LON(:,1)<=-70);
       
loni = LON(indxlon,indxlat); 
lati = LAT(indxlon,indxlat);
%% 
zoo = permute(zoo,[2 1 3]); phyto = permute(phyto,[2 1 3]);
chlor = permute(Schla,[2 1 3]);
%% anomalies
time = generate_monthly_time_vector(1990, 2010)';
[~, anom_PPflux] = calculateClimatologyAndAnomalies(PP_flux, time);
[climZoo, anomZoo] = calculateClimatologyAndAnomalies(zoo, time);
[~, anomPhyto] = calculateClimatologyAndAnomalies(phyto, time);
[~, anomChl] = calculateClimatologyAndAnomalies(chlor, time);

%% -------------------- TS -------------------------------- %%
nPP_flux = calculate_URegion(permute(PP_flux,[2 1 3]), loni, lati, mask(indxlon,indxlat));
nPP_flux2 = calculate_URegion(permute(anom_PPflux,[2 1 3]), loni, lati, mask(indxlon,indxlat)); % ANOM
 
PP_flux_ts = mean(nPP_flux,1,'omitnan')';
PP_flux_ts_a = mean(nPP_flux2,1,'omitnan')';

nzoo = calculate_URegion(zoo, LON, LAT, mask);
nzoo2 = calculate_URegion(anomZoo, LON, LAT, mask); % ANOM

nphyto = calculate_URegion(phyto, LON, LAT, mask);
nphyto2 = calculate_URegion(anomPhyto, LON, LAT, mask);

[nchla,lati] = calculate_URegion(chlor, LON, LAT, mask);
nchla2 = calculate_URegion(anomChl, LON, LAT, mask);


zoo_ts = mean(nzoo,1,'omitnan')';
zoo_ts_a = mean(nzoo2,1,'omitnan')';

phyto_ts = mean(nphyto,1,'omitnan')';
phyto_ts_a = mean(nphyto2,1,'omitnan')';

chla_ts = mean(nchla,1,'omitnan')';
chla_ts_a = mean(nchla2,1,'omitnan')';

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
a=plot(time,movmean(PP_flux_ts*86400,13),'Color',blue_green,'linewidth',4,'linestyle','-');
%plot(time,movmean(PP_flux_ts*86400,wz),'Color',yellow_orange,'linewidth',4,'linestyle','-');
datetick('x'); ylim([24 32]);
title('Int. Primary Production Flux and Chlorophyll'); box on;
ax = gca;
ax.FontSize = fsize;
grid on
ylabel('$\mathrm{mmol \cdot N \cdot m^{-2} \cdot day^{-1}}$','interpreter','latex');
yyaxis right
ax.YColor = dark_green;
b=plot(time,movmean(chla_ts,13),'Color',dark_green,'linewidth',4,'linestyle','-');
ylabel('$\mathrm{mg \cdot m^{-3}}$','interpreter','latex');
legend([a,b],{'Int. Primary Production','Chlorophyll'},'Orientation','horizontal');

subplot(2,1,2); hold on
bar(timeNINO2,arr3, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINA2,arr4, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
%plot(time,PP_flux_ts_a*86400,'Color',grey,'linewidth',1,'linestyle','-');
a=plot(time,movmean(PP_flux_ts_a*86400,wz),'Color',blue_green,'linewidth',4,'linestyle','-');
datetick('x'); ylim([-4 4]); box on;
title('Int. Primary Production Flux and Chlorophyll Anomaly');
ax = gca;
ax.FontSize = fsize;
grid on
ylabel('$\mathrm{mmol \cdot N \cdot m^{-2} \cdot day^{-1}}$','interpreter','latex');

yyaxis right
ax.YColor = dark_green;
b=plot(time,movmean(chla_ts_a,13),'Color',dark_green,'linewidth',4,'linestyle','-');
ylabel('$\mathrm{mg \cdot m^{-3}}$','interpreter','latex');
legend([a,b],{'Int. Primary Production','Chlorophyll'},'Orientation','horizontal');

%% zoo and phyto

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
a=plot(time,movmean(zoo_ts,13),'Color',brown,'linewidth',4,'linestyle','-');
%plot(time,movmean(PP_flux_ts*86400,wz),'Color',yellow_orange,'linewidth',4,'linestyle','-');
datetick('x'); ylim([43 57]);
title('Int. Biomass'); box on;
ax = gca;
ax.FontSize = fsize;
grid on
ylabel('$\mathrm{mmol \cdot N \cdot m^{-3}}$','interpreter','latex');
yyaxis right
ax.YColor = dark_green;
b=plot(time,movmean(phyto_ts,13),'Color',dark_green,'linewidth',4,'linestyle',':');
ylabel('$\mathrm{mmol \cdot N \cdot m^{-3}}$','interpreter','latex');
legend([a,b],{'Zooplankton','Phytoplankton'},'Orientation','horizontal');

subplot(2,1,2); hold on
bar(timeNINO2,arr3, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINA2,arr4, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
%plot(time,PP_flux_ts_a*86400,'Color',grey,'linewidth',1,'linestyle','-');
a=plot(time,movmean(zoo_ts_a,wz),'Color',brown,'linewidth',4,'linestyle','-');
datetick('x'); ylim([-7 7]); box on;
title('Int. Biomass Anomaly');
ax = gca;
ax.FontSize = fsize;
grid on
ylabel('$\mathrm{mmol \cdot N \cdot m^{-3}}$','interpreter','latex');

yyaxis right
ax.YColor = dark_green;
b=plot(time,movmean(phyto_ts_a,13),'Color',dark_green,'linewidth',4,'linestyle',':');
ylabel('$\mathrm{mmol \cdot N \cdot m^{-3}}$','interpreter','latex');
legend([a,b],{'Zooplankton','Phytoplankton'},'Orientation','horizontal');

%% -------------------- Presentation 
%----------------------------------------------------------
trp = 0.3;
wz = 13;

figure
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');hold on;

subplot(2,1,1); hold on
bar(EN9798,arrN, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', 0.3);
bar(EN9798,arrN2, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', 0.3);
bar(timeNINO2,arr3, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINA2,arr4, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
%plot(time,SNa,'Color',brown,'linewidth',0.5,'linestyle','-');
a=plot(time,movmean(SNa,13),'Color',brown,'linewidth',3,'linestyle','-');
%plot(time,mldNa,'Color',sunburn,'linewidth',0.5,'linestyle','-');
b=plot(time,movmean(mldNa,13),'Color',sunburn,'linewidth',3,'linestyle','-');
datetick('x'); ylim([-3 3]);
ax = gca;
ax.FontSize = fsize;
grid on
ylabel('$\mathrm{mmol \cdot N \cdot m^{-3}}$','interpreter','latex');

yyaxis right;
ax.YColor = matblue; % Set the color of the right y-axis to blue
c = plot(time,movmean(SNa-mldNa,13),'Color',matblue,'linewidth',4,'linestyle','-');
legend([b, a, c], {'N_{MLD}', 'N_{Surface}', 'N_{(Surface - MLD)}'},'Orientation','horizontal','location','southeast');
box on;ylim([-0.6 0.6]);
ylabel('$\mathrm{mmol \cdot N \cdot m^{-3}}$','interpreter','latex');
xlabel('Time');
title('Nitrogen Anomaly');
%----------
subplot(2,1,2)
hold on;
bar(EN9798,arrN, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', 0.3);
bar(EN9798,arrN2, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', 0.3);
bar(timeNINO2,arr3, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINA2,arr4, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);


%ax1= axes;
%yyaxis left;
a=plot(time, movmean(PP_flux_ts_a*86400, wz), 'Color', blue_green, 'linewidth', 4, 'linestyle', '-');
%ylabel('[m]', 'Color', blue_green);
ylabel('$\mathrm{mmol \cdot N \cdot m^{-2}}$','interpreter','latex','Color', blue_green);
ylim([-3 3]); box on;

ax1 = gca; %ylim([12 26]);
ax1.YColor = blue_green;
datetick('x');
pause(0.1)
ax1.XTickMode = 'manual';
ax1.YLim = [min(ax1.YTick), max(ax1.YTick)];  % see [4]
ax1.XLimMode = 'manual';
grid(ax1,'on')
ytick = ax1.YTick;  xlabel('time')
set(ax1.YAxis, 'Color', blue_green);
%set(ax1,'xticklabel',[],'yticklabel',[]);

yyaxis right
b=plot(time, movmean(phyto_ts_a, 13), 'Color', dark_green, 'linewidth', 4, 'linestyle', '-');
%ylabel('[C]', 'Color', dark_green);
ylabel('$\mathrm{mmol \cdot N \cdot m^{-2}}$','interpreter','latex','Color', dark_green);

ax2 = gca;
ax2.YColor = dark_green;
ax = gca;
ax.FontSize = 20;
ylim([-15 15]);

% create 2nd, transparent axes
ax2 = axes('position', ax1.Position);
set(ax2,'xticklabel',[])

ax2.Box = 'off';
c=line(ax2,time, movmean(zoo_ts_a, 13), 'Color', brown, 'linewidth', 4, 'linestyle', '-');             % see [3]
ax2.Color = 'none';

pause(0.1)
grid(ax2, 'off')
% Horizontally scale the y axis to alight the grid (again, be careful!)
ax2.XLim = ax1.XLim;
ax2.XTick = ax1.XTick;
ax2.YLimMode = 'manual';
yl = ax2.YLim;
ylabel('$\mathrm{mmol \cdot N \cdot m^{-2}}$','interpreter','latex','fontsize',20);
% horzontally offset y tick labels
ax2.YTickLabel = strcat(ax2.YTickLabel, {'             '});
ax2.YTick = linspace(yl(1), yl(2), 9);      % see [2]
%set(gca, 'XDir','reverse'); xlim([0 400]);
%ax2.Ylim([-8 8]);
set(ax2.YAxis, 'Color', brown);
ax = gca;
ax.FontSize = 20;
ax.Box = 'off';
ax2.Box = 'off';
%set(ax2,'xticklabel',[])
legend([a,b,c],{'Primary Production Flux','Phytoplankton','Zooplankton'},'orientation','horizontal','location','southeast');
title('Integrated Biomass Anomaly');

