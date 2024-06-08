%% ---------------------- INTERANUAL VARIABILITY -------------------------%%
%% ------------- Load ENSO by DANTE ----------------- %%
clear all; close all; clc;
load('ENSO_DANTE_dates.mat');
timeNINO2(16)=[];
fsize=20;
[~,ylab] = generateYLabels(20,4,2);

grey = [0.5 0.5 0.5];
brown = [165, 42, 42] ./ 255;
dark_green = [0, 100, 0] ./ 255;
blue_green = [0, 128, 128] ./ 255;

arr= ones(length(timeNINO2), 1); arr2=ones(length(timeNINA2),1);
arr(arr==1)=1000; arr2(arr2==1)=1000;
arr3(arr==1000)=-1000; arr4(arr2==1000)=-1000;

time = generate_monthly_time_vector(1990, 2010)';


%% --------------- Load Indices

Analytical = table2array(struct2table(load('W_analytical.mat','Wa_ts')))'; %analytical
BUI = table2array(struct2table(load('BUI.mat','Bakun_ts')))'; %BUI
CUTI = table2array(struct2table(load('CUTI_HR','Mean_CUTI_HR'))); %CUTI
CUTI = mean(CUTI,1,'omitnan')';
BEUTI = table2array(struct2table(load('BEUTI_HR','Mean_BEUTI_HR'))); %BEUTI 
BEUTI = mean(BEUTI,1,'omitnan')';
CUI = table2array(struct2table(load('CUI_SST_index.mat','Mean_CUI')))'; %CUI
HUI = table2array(struct2table(load('HUI_index.mat','HUI_index'))); %HUI
load('NINO1_2.mat');
% ---- Croco ---- % 
load('WMLD_anom.mat');


%% CROCO internanual Variability 
trp = 0.3;
wz = 13; 

figure
P=get(gcf,'position');
P(3)=P(3)*2.5;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(2,1,1)
a=bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
b=bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
c=plot(time,WMLD_ts2*86400,'k','linewidth',2); 
ylabel('$m \cdot day^{-1}$','interpreter','latex');
xlabel('time'); title('Modelled W velocity');
% yyaxis right
% plot(time,tmp,'color',[0.8500 0.3250 0.0980],'linewidth',2); ylabel('Nino 1+2 [°C]'); hold off
datetick('x'); 
ylim([0 2.5]);
ax = gca; ax.FontSize = 20;
legend([a,b,c],{'Nino','Nina','WMLD'});

subplot(2,1,2)
bar(timeNINO2,arr3, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
bar(timeNINA2,arr4, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
a=bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
b=bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
plot(time,WMLD_anom.*86400,'Color',grey,'linewidth',0.7,'linestyle','-');
hold on
c=plot(time,movmean(WMLD_anom.*86400,wz),'Color',blue_green,'linewidth',2,'linestyle','-');
datetick('x'); ylim([-1 1.5]);
title('Modelled W velocity Anomaly');
ax = gca;
ax.FontSize = fsize;
grid on
ylabel('$m \cdot day^{-1}$','interpreter','latex');
legend([a,b,c],{'Nino','Nina','WMLD anom'});

%% ------ Let's calculate the Interannual Variability ----- %% 
figure
P=get(gcf,'position');
P(3)=P(3)*2.5;
P(4)=P(4)*3;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(3,1,1)
a=bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
b=bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
c=plot(time,Analytical*86400,'k--','linewidth',2); ylabel('m/s'); 
xlabel('time'); title('Analytical Velocity');
% yyaxis right
% plot(time,tmp,'color',[0.8500 0.3250 0.0980],'linewidth',2); ylabel('Nino 1+2 [°C]'); hold off
datetick('x'); ylim([0 3]);
ax = gca; ax.FontSize = 20;
% yyaxis('right'); ax.YColor = [0.8500 0.3250 0.0980];
legend([a,b,c],{'Nino','Nina','Analytical'},'Orientation','horizontal');

subplot(3,1,2)
a=bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
b=bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
c=plot(time,BUI,'m','linewidth',2); ylabel('m^{2}/s'); 
xlabel('time'); title('BUI'); ylim([0 1.5]);
% yyaxis right
% plot(time,tmp,'color',[0.8500 0.3250 0.0980],'linewidth',2); 
% ylabel('Nino 1+2 [°C]')
datetick('x')
ax = gca;
ax.FontSize = 20;
% yyaxis('right'); ax.YColor = [0.8500 0.3250 0.0980];
legend([a,b,c],{'Nino','Nina','BUI'},'Orientation','horizontal');


subplot(3,1,3)
a=bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
b=bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
c=plot(time,CUTI*-1,'b','linewidth',2); ylabel('m^{2}/s'); 
xlabel('time'); title('CUTI'); ylim([0 10]);
% yyaxis right
% plot(time,tmp,'color',[0.8500 0.3250 0.0980],'linewidth',2); 
% ylabel('Nino 1+2 [°C]')
datetick('x')
ax = gca;
ax.FontSize = 20;
%yyaxis('right'); ax.YColor = [0.8500 0.3250 0.0980];
legend([a,b,c],{'Nino','Nina','BUI'},'Orientation','horizontal');

%% 
figure
P=get(gcf,'position');
P(3)=P(3)*2.5;
P(4)=P(4)*3;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(3,1,1)
a=bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
b=bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
c=plot(time,BEUTI.*-1,'b--','linewidth',2); ylabel('m^{2}/s'); 
xlabel('time'); title('BEUTI');
% yyaxis right
% plot(time,tmp,'color',[0.8500 0.3250 0.0980],'linewidth',2); ylabel('Nino 1+2 [°C]'); hold off
datetick('x'); 
ax = gca; ax.FontSize = 20;ylim([0 200]);
%yyaxis('right'); ax.YColor = [0.8500 0.3250 0.0980];
legend([a,b,c],{'Nino','Nina','BEUTI'},'Orientation','horizontal');

subplot(3,1,2)
a=bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
b=bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
c=plot(time,CUI,'color',[0.9290 0.6940 0.1250],'linewidth',2); ylabel('[°C]'); 
xlabel('time'); title('CUI');
% yyaxis right
% plot(time,tmp,'color',[0.8500 0.3250 0.0980],'linewidth',2); 
% ylabel('Nino 1+2 [°C]')
datetick('x'); ylim([0 6]);
ax = gca;
ax.FontSize = 20;
%yyaxis('right'); ax.YColor = [0.8500 0.3250 0.0980];
legend([a,b,c],{'Nino','Nina','CUI'},'Orientation','horizontal');

subplot(3,1,3)
a=bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
b=bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
c=plot(time,HUI*86400,'Cyan','linewidth',2); ylabel('m/s'); 
xlabel('time'); title('HUI');
%yyaxis right
%plot(time,tmp,'color',[0.8500 0.3250 0.0980],'linewidth',2); 
%ylabel('Nino 1+2 [°C]')
datetick('x');ylim([0 4]);
ax = gca;
ax.FontSize = 20;
%yyaxis('right'); ax.YColor = [0.8500 0.3250 0.0980];
legend([a,b,c],{'Nino','Nina','CUI'},'Orientation','horizontal');

%% --- Cor plot -- %
M = array2table(cat(2, WMLD_ts,Analytical,BUI,CUTI,BEUTI,CUI,HUI,tmp));
M.Properties.VariableNames = {'WMLD','Analytical','BUI','CUTI','BEUTI','CUI','HUI','ENSO'};

filename = 'Upwelling_indices_2.xlsx';
writetable(M,filename,'Sheet',1)

