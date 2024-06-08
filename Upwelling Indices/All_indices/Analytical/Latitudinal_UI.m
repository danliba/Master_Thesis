%% Latitudinal indices
clear all; close all; clc;

%CROCO
load('WMLD_lat.mat')


Analytical = mean(table2array(struct2table(load('W_analytical.mat','climWa'))),2,'omitnan'); %analytical
BUI = mean(table2array(struct2table(load('BUI.mat','climBUI'))),2,'omitnan'); %BUI
CUTI = table2array(struct2table(load('CUTI_HR','CUTI_latitudinal'))); %CUTI
BEUTI = table2array(struct2table(load('BEUTI_HR','BEUTI_latitudinal_HR'))); %BEUTI 
CUI = mean(table2array(struct2table(load('CUI_SST_index.mat','CUI_SSTi'))),2,'omitnan'); %CUI
HUI = mean(table2array(struct2table(load('HUI_index.mat','climHUI'))),2,'omitnan'); %HUI

rmWMLD = movmean(WMLD_lat,13);
rmAnalytical = movmean(Analytical,13);
rmBUI = movmean(BUI,13); 
rmCUTI = movmean(CUTI,13);
rmBEUTI = movmean(BEUTI,13);
rmCUI = movmean(CUI,13);
rmHUI = movmean(HUI,13);

% T_UI=array2table(cat(2,WMLD_lat,Analytical,BUI,CUTI,BEUTI,CUI,HUI));
% T_UI.Properties.VariableNames = {'WMLD','Analytical','BUI','CUTI','BEUTI','CUI','HUI'};
% 
% T_rmUI = array2table(cat(2,rmWMLD,rmAnalytical,rmBUI,rmCUTI,rmBEUTI,rmCUI,rmHUI));
% T_rmUI.Properties.VariableNames = {'WMLD','Analytical','BUI','CUTI','BEUTI','CUI','HUI'};
% 
% writetable(T_UI,'UI_lat.xlsx');
% writetable(T_rmUI,'UI_RMlat.xlsx');
up_center = [5, 7.5, 10, 11, 14, 15]*-1;

arr= ones(length(up_center), 1); 
arr(arr==1)=200; 

%% --- let's plot Latitudinal ----- %% 
fsize=20;
ylab={'20S','15S','10S','5S'};
grey = [0.5 0.5 0.5];

subplot(2,4,1); hold on;
barh(up_center,arr,'FaceColor', grey, 'EdgeColor', 'none','FaceAlpha', 0.3,'BarWidth', 1);
plot(WMLD_lat*86400,lati,'k:','linewidth',1.5);
plot(rmWMLD*86400,lati,'k-','linewidth',2);
title('Model Upward Velocity');
ax = gca;
ax.FontSize = fsize;
grid on
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
xlabel('m day^{-1}'); xlim([0 1.2]); box on;

subplot(2,4,2); hold on
barh(up_center,arr,'FaceColor', grey, 'EdgeColor', 'none','FaceAlpha', 0.3,'BarWidth', 1);
plot(Analytical*86400,lati,'Color',grey,'linewidth',1.5,'linestyle',':');
hold on
plot(rmAnalytical*86400,lati,'Color',grey,'linewidth',2);
title('Analytical Velocity'); box on;
ax = gca;
ax.FontSize = fsize;
grid on
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
xlabel('m day^{-1}'); xlim([0 2.1]);

subplot(2,4,3); hold on
barh(up_center,arr,'FaceColor', grey, 'EdgeColor', 'none','FaceAlpha', 0.3,'BarWidth', 1);
plot(BUI,lati,'m:','linewidth',1);
hold on
plot(rmBUI,lati,'m','linewidth',2);xlim([0 1.5]); box on;
title('Bakun Index');
ax = gca;
ax.FontSize = fsize;
grid on
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
xlabel('m^{2}/s'); xlim([0 1.5]);

subplot(2,4,4); hold on
barh(up_center,arr,'FaceColor', grey, 'EdgeColor', 'none','FaceAlpha', 0.3,'BarWidth', 1);
plot(CUTI*-1,lati,'b:','linewidth',1);
plot(rmCUTI*-1,lati,'b','linewidth',2);
title('CUTI Index');
ax = gca;
ax.FontSize = fsize;
grid on
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
xlabel('m^{2}/s');xlim([0 10]); box on;

subplot(2,4,5); hold on
barh(up_center,arr,'FaceColor', grey, 'EdgeColor', 'none','FaceAlpha', 0.3,'BarWidth', 1);
plot(BEUTI*-1,lati,'Color',[0, 0.4470, 0.7410],'linewidth',1,'linestyle',':');
plot(rmBEUTI*-1,lati,'Color',[0, 0.4470, 0.7410],'linewidth',2);
title('BEUTI Index');
ax = gca;
ax.FontSize = fsize;
grid on
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
xlabel('m^{2}/s'); xlim([0 200]); box on;

subplot(2,4,6); hold on
barh(up_center,arr,'FaceColor', grey, 'EdgeColor', 'none','FaceAlpha', 0.3,'BarWidth', 1);
plot(CUI,lati,'color',[0.9290 0.6940 0.1250],'linewidth',1,'linestyle',':');
plot(rmCUI,lati,'color',[0.9290 0.6940 0.1250],'linewidth',2);
title('CUI Index');
grid on
ax = gca;
ax.FontSize = fsize;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
xlabel('SST [C]'); xlim([0.9 3]); box on;

subplot(2,4,7); hold on
barh(up_center,arr,'FaceColor', grey, 'EdgeColor', 'none','FaceAlpha', 0.3,'BarWidth', 1);
plot(HUI*86400,lati,'Cyan','linewidth',1,'linestyle',':');
plot(rmHUI*86400,lati,'Cyan','linewidth',2);
title('HUI Index');
ax = gca;
ax.FontSize = fsize;
grid on
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
xlabel('m day^{-1}');xlim([0 3]);box on;

%% lets define the upwelling centers
flag=0;
if flag ==1
    up_center = [5, 7.5, 10, 11, 14, 15]*-1;
    
    arr= ones(length(up_center), 1);
    arr(arr==1)=1.5;
    
    figure; hold on;
    barh(up_center,arr,'FaceColor', grey, 'EdgeColor', 'none','FaceAlpha', 0.3,'BarWidth', 1);
    plot(WMLD_lat*86400,lati,'k:','linewidth',1.5);
    hold on
    plot(rmWMLD*86400,lati,'k-','linewidth',2);
    title('Model Upward Velocity');
    ax = gca;
    ax.FontSize = fsize;
    grid on
    set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
    xlabel('m day^{-1}'); box on; xlim([0 1.5]);
end
