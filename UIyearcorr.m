clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;

cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/w_analytical;

bd = readtable('normalized_data.xlsx');
UI = table2array(cat(2,bd(:,3:6),bd(:,8)));

UPI = readtable("Upwelling_indices_2.xlsx");

%meanUI = mean(UI,2);
load('MLD_W_1990_2010.mat');
%% now the Normalized mean
UIs = movmean(abs(table2array(UPI(:,1:7))),13);

UIsnormal = normalize(UIs(:,2:end),'range');

UIs2 = abs(table2array(UPI(:,2:7)));
UIsnormal2 = normalize(UIs2,'range');

meanUI = mean(UIsnormal2,2);
%%
time = generate_monthly_time_vector(1990, 2010)';

[climWMLD, anomWMLD] = calculateClimatologyAndAnomalies(permute(Wmld,[2 1 3]), time);

%%-------------------- TS -------------------------------- %%
nwmld = mean(calculate_URegion(permute(Wmld,[2 1 3]), LON, LAT, mask),1,'omitnan');
nwmld_a = mean(calculate_URegion(anomWMLD, LON, LAT, mask),1,'omitnan');
wmld_clim =  mean(calculate_URegion(climWMLD, LON, LAT, mask),1,'omitnan');
%% year mean
yrMeanUI = double(mean(reshape(meanUI,[12 21]),1,'omitnan'))';
yrWmld = double(mean(reshape(nwmld,[12 21]),1,'omitnan'))'*86400;
yrAnalytical = double(mean(reshape(UPI.Analytical,[12 21]),1,'omitnan'))'*86400;
yrHUI = double(mean(reshape(UPI.HUI,[12 21]),1,'omitnan'))'*86400;

%% anom
Analy_clim = repmat(mean(reshape(UPI.Analytical,[12 21]),2)',21);
Analy_anom = UPI.Analytical - Analy_clim(1,:)';
%% plot anom
plot(time, movmean(Analy_anom*86400,13));
yyaxis right
plot(time,movmean(nwmld_a*86400,13));
datetick('x');
%% correlations Mean UI vs Wmld
fsize=20;

years = [1990:2010];

figure; hold on;
plot(yrMeanUI,yrWmld,'o','markerfacecolor','b');
for ii=1:1:length(years)
    text(yrMeanUI(ii),yrWmld(ii),num2str(years(ii)),'Fontsize',15);
end
ax = gca;
ax.FontSize = fsize;
grid on; title('Yearly Correlation');
ylabel('$m \cdot day^{-1}$','interpreter','latex');
xlabel('$Averaged \: normalized \:UI$','interpreter','latex');
text(0.065, 0.45,['R = ' num2str(round(corr(yrMeanUI,yrWmld),2))],'fontsize',20);
box on
%% Linear models
Year = categorical(years');
tbl1 = table(yrMeanUI,yrWmld,Year);
tbl2 = table(yrAnalytical,yrWmld,Year);
tblH = table(yrHUI, yrWmld,Year);

mdl1 = fitlm(tbl1,'yrMeanUI  ~ yrWmld');
mld2 = fitlm(tbl2,'yrAnalytical ~ yrWmld');
mldH = fitlm(tblH,'yrHUI ~ yrWmld');
%% 
round(corr(double(mean(reshape(UPI.WMLD,[12 21]),1,'omitnan')'),...
double(mean(reshape(UPI.HUI,[12 21]),1,'omitnan'))'),2)

figure
plot(mldH);hold on;
for ii=1:1:length(years)
    text(yrWmld(ii),yrHUI(ii),num2str(years(ii)),'Fontsize',16);
end

%% 
figure; 
P=get(gcf,'position');
P(3)=P(3)*2.1;
P(4)=P(4)*1.3;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(1,2,1);hold on;
plot(mdl1);
for ii=1:1:length(years)
    text(yrWmld(ii),yrMeanUI(ii),num2str(years(ii)),'Fontsize',16);
end
ax = gca;
ax.FontSize = fsize;
grid on; title('Yearly Correlation');
xlabel('$m \cdot day^{-1}$','interpreter','latex');
ylabel('$Averaged \: normalized \:UI$','interpreter','latex');
text(0.45, 0.48,['R = ' num2str(round(corr(yrMeanUI,yrWmld),2))],'fontsize',20);
box on
xlim([0.35 0.85]);

subplot(1,2,2); hold on;
plot(mld2);
for ii=1:1:length(years)
    text(yrWmld(ii),yrAnalytical(ii),num2str(years(ii)),'Fontsize',16);
end
ax = gca;
ax.FontSize = fsize;
grid on; title('Simulated vs Analytical');
ylabel('$m \cdot day^{-1}$','interpreter','latex');
xlabel('$m \cdot day^{-1}$','interpreter','latex');
text(0.45, 1.6,['R = ' num2str(round(corr(yrAnalytical,yrWmld),2))],'fontsize',20);
box on
ylim([0.9 1.65]);
xlim([0.35 0.85]);
%% CUTI and BEUTI seasonality 
mes = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Set','Oct','Nov','Dec'};
M = categorical(mes');
CUTI_clim = mean(reshape(double(UPI.CUTI)*-1,[12 21]),2);
BEUTI_clim = abs(mean(reshape(UPI.BEUTI,[12 21]),2)')';
wmld_clim2 = double(wmld_clim')*86400;

%--- LM seasonality 
tbl3 = table(CUTI_clim,wmld_clim2,M);
mdl3 = fitlm(tbl3,'wmld_clim2 ~ CUTI_clim');

tbl4 = table(BEUTI_clim,wmld_clim2,M);
mdl4 = fitlm(tbl4,'wmld_clim2 ~ BEUTI_clim');

%% --- figure
figure; 
P=get(gcf,'position');
P(3)=P(3)*2.1;
P(4)=P(4)*1.3;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');


subplot(1,2,1); hold on
plot(mdl3);
for ii=1:1:length(mes)
    text(CUTI_clim(ii),wmld_clim2(ii),char(mes(ii)),'Fontsize',16);
end
ax = gca;
ax.FontSize = fsize;
grid on; title('CUTI vs Simulated');
ylabel('$m \cdot day^{-1}$','interpreter','latex');
xlabel('$m^{2} \cdot s^{-1}$','interpreter','latex');
text(1.2, 0.8,['R = ' num2str(round(corr(CUTI_clim,wmld_clim2),2))],'fontsize',20);
box on
ylim([0.2 1]);

subplot(1,2,2); hold on
plot(mdl4);
for ii=1:1:length(mes)
    text(BEUTI_clim(ii),wmld_clim2(ii),char(mes(ii)),'Fontsize',16);
end
ax = gca;
ax.FontSize = fsize;
grid on; title('BEUTI vs Simulated');
ylabel('$m \cdot day^{-1}$','interpreter','latex');
xlabel('$mm \cdot N \cdot m^{2} \cdot s^{-1}$','interpreter','latex');
text(12, 0.8,['R = ' num2str(round(corr(BEUTI_clim,wmld_clim2),2))],'fontsize',20);
box on
ylim([0.2 1]);
%%
% yr2Wmld = double(mean(reshape(movmean(nwmld,13),[21 12]),2,'omitnan'))*86400;
% yr2Analytical = double(mean(reshape(movmean(UPI.Analytical,13),[21 12]),2,'omitnan'))*86400;
% 
% round(corr(yr2Analytical,yr2Wmld),2)

%% ENSO
load('ENSO_DANTE_dates.mat');
timeNINO2(16)=[]; indxNINO2(16) = [];
fsize=20;
[~,ylab] = generateYLabels(20,4,2);

arr= ones(length(timeNINO2), 1); arr2=ones(length(timeNINA2),1);
arr(arr==1)=1000; arr2(arr2==1)=1000;
arr3(arr==1000)=-1000; arr4(arr2==1000)=-1000;

arrN = ones(length(EN9798), 1);arrN(arrN==1)=1000;
load('NINO9798.mat');
%% plot 
UIsnormal = normalize(UIs(:,2:end),'range'); %A%BUI%CUTI%BEUTI%CUI%HUI

trp = 0.1;
%trp1 = 0.15; 
figure; hold on;
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

bar(EN9798,arrN, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', 0.25);
bar(timeNINO2,arr3, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINA2,arr4, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
plot(time,UIsnormal(:,2:end),'linewidth',1,'Color',[.5 .5 .5]);
b = plot(time,UIsnormal(:,2),'linewidth',1,'Color',[.5 .5 .5]);
a = plot(time,UIsnormal(:,1),'linewidth',3,'Color','k');
c = plot(time,UIsnormal(:,5),'linewidth',1,'Color','red');
d = plot(time,UIsnormal(:,4),'linewidth',1,'Color','blue');

datetick('x'); box on; 
ylabel('$Normalized \: \: UIs \:$','interpreter','latex');
xlabel('$Time$','interpreter','latex');
ylim([0 1.1]);
box on;
title('Normalized Upwelling Indices','fontsize',27);
ax = gca;
ax.FontSize = fsize;
grid on
legend([a,b,c,d],{'Simulated','Wind based UIs','CUI (SST)','BEUTI (N)'},'Orientation','horizontal');



