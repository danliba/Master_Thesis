addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices
Humboldt_ports;
%% ------------ ENSO Dante ------------------ %
load('ENSO_DANTE_dates.mat');
timeNINO2(16)=[]; indxNINO2(16) = [];

%% ---------- wmld --------
WMLD = permute(Wmld,[2 1 3]).*mask;
[nWMLD,lati] = calculate_URegion(WMLD, LON, LAT, mask);

WMLD_NINO = mean(nWMLD(:,indxNINO2),2,'omitnan');
WMLD_NINA = mean(nWMLD(:,indxNINA2),2,'omitnan');
WMLD_NEUTRO = mean(nWMLD(:,indxNEUTRO2),2,'omitnan');

rmWMLD_NINO = movmean(WMLD_NINO,13);
rmWMLD_NINA = movmean(WMLD_NINA,13);
rmWMLD_NEUTRO = movmean(WMLD_NEUTRO,13);

%% ------------ Load Upwelling Indices --------- %
%-----Analytical
Analytical = table2array(struct2table(load('W_analytical.mat','Monthly_wa'))); %analytical

analytical_NINO = mean(Analytical(:,indxNINO2),2,'omitnan');
analytical_NINA = mean(Analytical(:,indxNINA2),2,'omitnan');
analytical_NEUTRO = mean(Analytical(:,indxNEUTRO2),2,'omitnan');

rmAnalytical_NINO = movmean(analytical_NINO,13);
rmAnalytical_NINA = movmean(analytical_NINA,13);
rmAnalytical_NEUTRO = movmean(analytical_NEUTRO,13);

%-----Bakun 
BUI = table2array(struct2table(load('BUI.mat','Mean_Bakun'))); %BUI

BUI_NINO = mean(BUI(:,indxNINO2),2,'omitnan');
BUI_NINA = mean(BUI(:,indxNINA2),2,'omitnan');
BUI_NEUTRO = mean(BUI(:,indxNEUTRO2),2,'omitnan');

rmBUI_NINO = movmean(BUI_NINO,13); 
rmBUI_NINA = movmean(BUI_NINA,13); 
rmBUI_NEUTRO = movmean(BUI_NEUTRO,13); 

%-----CUTI
CUTI = table2array(struct2table(load('CUTI_HR','Mean_CUTI_HR'))); %CUTI

CUTI_NINO = mean(CUTI(:,indxNINO2),2,'omitnan');
CUTI_NINA = mean(CUTI(:,indxNINA2),2,'omitnan');
CUTI_NEUTRO = mean(CUTI(:,indxNEUTRO2),2,'omitnan');

rmCUTI_NINO = movmean(CUTI_NINO,13);
rmCUTI_NINA = movmean(CUTI_NINA,13);
rmCUTI_NEUTRO = movmean(CUTI_NEUTRO,13);

%----BEUTI
BEUTI = table2array(struct2table(load('BEUTI_HR','Mean_BEUTI_HR'))); %BEUTI 

BEUTI_NINO = mean(BEUTI(:,indxNINO2),2,'omitnan');
BEUTI_NINA = mean(BEUTI(:,indxNINA2),2,'omitnan');
BEUTI_NEUTRO = mean(BEUTI(:,indxNEUTRO2),2,'omitnan');

rmBEUTI_NINO = movmean(BEUTI_NINO,13);
rmBEUTI_NINA = movmean(BEUTI_NINA,13);
rmBEUTI_NEUTRO = movmean(BEUTI_NEUTRO,13);

%-----CUI
CUI = table2array(struct2table(load('CUI_SST_index.mat','CUI_SSTi'))); %CUI

CUI_NINO = mean(CUI(:,indxNINO2),2,'omitnan');
CUI_NINA = mean(CUI(:,indxNINA2),2,'omitnan');
CUI_NEUTRO = mean(CUI(:,indxNEUTRO2),2,'omitnan');

rmCUI_NINO = movmean(CUI_NINO,13);
rmCUI_NINA = movmean(CUI_NINA,13);
rmCUI_NEUTRO = movmean(CUI_NEUTRO,13);

%-----HUI
HUI =table2array(struct2table(load('HUI_index.mat','Mean_HUI')))'; %HUI

HUI_NINO = mean(HUI(:,indxNINO2),2,'omitnan');
HUI_NINA = mean(HUI(:,indxNINA2),2,'omitnan');
HUI_NEUTRO = mean(HUI(:,indxNEUTRO2),2,'omitnan');


rmHUI_NINO = movmean(HUI_NINO,13);
rmHUI_NINA = movmean(HUI_NINA,13);
rmHUI_NEUTRO = movmean(HUI_NEUTRO,13);

%% upwelling centers
up_center = [5, 7.5, 10, 11, 14, 15]*-1;

arr= ones(length(up_center), 1);
arr(arr==1)=200;
fsize=20;
ylab={'20S','15S','10S','5S'};
grey = [0.5 0.5 0.5];

dark_grey = [0.3, 0.3, 0.3];
blue2=[0, 0.4470, 0.7410];
sunburn = [0.9290 0.6940 0.1250];
%% -------- Now under ENSO conditions ------- %

%Simulation
subplot(2,4,1); hold on;
barh(up_center,arr,'FaceColor', grey, 'EdgeColor', 'none','FaceAlpha', 0.3,'BarWidth', 1);
plot(WMLD_NINO*86400,lati,'Color',grey,'linewidth',0.2,'marker','x');
a=plot(rmWMLD_NINO*86400,lati,'kx-','linewidth',2); %nino
plot(WMLD_NINA*86400,lati,'Color',grey,'linewidth',0.2,'linestyle','--');
b=plot(rmWMLD_NINA*86400,lati,'k--','linewidth',2.5);%nina
plot(WMLD_NEUTRO*86400,lati,'Color',grey,'linewidth',0.2);
c=plot(rmWMLD_NEUTRO*86400,lati,'k-','linewidth',2);%neutro
title('Model Upward Velocity');
ax = gca;
ax.FontSize = fsize;
grid on
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
xlabel('m day^{-1}'); xlim([0 1.5]); box on;
legend([a,b,c],{'Nino','Nina','Neutro'},'Location', 'southeast'); box on;

%Analytical
subplot(2,4,2); hold on
barh(up_center,arr,'FaceColor', grey, 'EdgeColor', 'none','FaceAlpha', 0.3,'BarWidth', 1);
plot(analytical_NINO*86400,lati,'Color',grey,'linewidth',0.2,'marker','x');%nino
a=plot(rmAnalytical_NINO*86400,lati,'Color',dark_grey,'linewidth',2,'Marker','x');
plot(analytical_NINA*86400,lati,'Color',grey,'linewidth',0.2,'linestyle','--');%nina
b=plot(rmAnalytical_NINA*86400,lati,'Color',dark_grey,'linewidth',2.5,'linestyle','--');
plot(analytical_NEUTRO*86400,lati,'Color',grey,'linewidth',0.2,'linestyle','-');%neutro
c=plot(rmAnalytical_NEUTRO*86400,lati,'Color',dark_grey,'linewidth',2,'linestyle','-');
title('Analytical Velocity'); box on;
ax = gca;
ax.FontSize = fsize;
grid on
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
xlabel('m day^{-1}'); xlim([0 2.5]);
legend([a,b,c],{'Nino','Nina','Neutro'},'Location', 'southeast'); box on;

%Bakun
subplot(2,4,3); hold on
barh(up_center,arr,'FaceColor', grey, 'EdgeColor', 'none','FaceAlpha', 0.3,'BarWidth', 1);
plot(BUI_NINO,lati,'Color',grey,'linewidth',0.2,'marker','x');
a=plot(rmBUI_NINO,lati,'mx-','linewidth',2);%nino
plot(BUI_NINA,lati,'Color',grey,'linewidth',0.2,'linestyle','--');
b=plot(rmBUI_NINA,lati,'m--','linewidth',2);%nina
plot(BUI_NEUTRO,lati,'Color',grey,'linewidth',0.2,'linestyle','-');
c=plot(rmBUI_NEUTRO,lati,'m-','linewidth',2);%neutro
xlim([0 1.5]); box on;
title('Bakun Index');
ax = gca;
ax.FontSize = fsize;
grid on
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
xlabel('m^{2}/s'); xlim([0 1.5]);
legend([a,b,c],{'Nino','Nina','Neutro'},'Location', 'southeast'); box on;

%CUTI
subplot(2,4,4); hold on
barh(up_center,arr,'FaceColor', grey, 'EdgeColor', 'none','FaceAlpha', 0.3,'BarWidth', 1);
plot(CUTI_NINO*-1,lati,'Color',grey,'linewidth',0.2,'marker','x');
a=plot(rmCUTI_NINO*-1,lati,'bx-','linewidth',2);%nino
plot(CUTI_NINA*-1,lati,'Color',grey,'linewidth',0.2,'linestyle','--');
b=plot(rmCUTI_NINA*-1,lati,'b--','linewidth',2);%nina
plot(CUTI_NEUTRO*-1,lati,'Color',grey,'linewidth',0.2,'linestyle','-');
c=plot(rmCUTI_NEUTRO*-1,lati,'b','linewidth',2);%neutro
title('CUTI Index');
ax = gca;
ax.FontSize = fsize;
grid on
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
xlabel('m^{2}/s');xlim([0 10]); box on;
legend([a,b,c],{'Nino','Nina','Neutro'},'Location', 'southeast'); box on;

%BEUTI
subplot(2,4,5); hold on
barh(up_center,arr,'FaceColor', grey, 'EdgeColor', 'none','FaceAlpha', 0.3,'BarWidth', 1);
plot(BEUTI_NINO*-1,lati,'Color',grey,'linewidth',0.2,'marker','x');
a=plot(rmBEUTI_NINO*-1,lati,'Color',blue2,'linewidth',2,'marker','x');%nino
plot(BEUTI_NINA*-1,lati,'Color',grey,'linewidth',0.2,'linestyle','--');
b=plot(rmBEUTI_NINA*-1,lati,'Color',blue2,'linewidth',2,'linestyle','--');%nina
plot(BEUTI_NEUTRO*-1,lati,'Color',grey,'linewidth',0.2,'linestyle','-');
c=plot(rmBEUTI_NEUTRO*-1,lati,'Color',blue2,'linewidth',2,'linestyle','-');%neutro
title('BEUTI Index');
ax = gca;
ax.FontSize = fsize;
grid on
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
xlabel('m^{2}/s'); xlim([0 200]); box on;
legend([a,b,c],{'Nino','Nina','Neutro'},'Location', 'southeast'); box on;

%CUI
subplot(2,4,6); hold on
barh(up_center,arr,'FaceColor', grey, 'EdgeColor', 'none','FaceAlpha', 0.3,'BarWidth', 1);
plot(CUI_NINO,lati,'color',grey,'linewidth',0.2,'marker','x');
a=plot(rmCUI_NINO,lati,'color',sunburn,'linewidth',2,'marker','x');%nino
plot(CUI_NINA,lati,'color',grey,'linewidth',0.2,'linestyle','--');
b=plot(rmCUI_NINA,lati,'color',sunburn,'linewidth',2.5,'linestyle','--');%nina
plot(CUI_NEUTRO,lati,'color',grey,'linewidth',0.2,'linestyle','-');
c=plot(rmCUI_NEUTRO,lati,'color',sunburn,'linewidth',2,'linestyle','-');%neutro
title('CUI Index');
grid on
ax = gca;
ax.FontSize = fsize;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
xlabel('SST [C]'); xlim([0.5 3.5]); box on;
legend([a,b,c],{'Nino','Nina','Neutro'},'Location', 'southeast'); box on;

%HUI
subplot(2,4,7); hold on
barh(up_center,arr,'FaceColor', grey, 'EdgeColor', 'none','FaceAlpha', 0.3,'BarWidth', 1);
plot(HUI_NINO*86400,lati,'Color',grey,'linewidth',0.2,'marker','x');
a=plot(rmHUI_NINO*86400,lati,'Cyan','linewidth',2,'marker','x');%nino
plot(HUI_NINA*86400,lati,'Color',grey,'linewidth',0.2,'linestyle','--');
b=plot(rmHUI_NINA*86400,lati,'Cyan','linewidth',2.5,'linestyle','--');%nina
plot(HUI_NEUTRO*86400,lati,'Color',grey,'linewidth',0.2,'linestyle','-');
c=plot(rmHUI_NEUTRO*86400,lati,'Cyan','linewidth',2,'linestyle','-');%enso
title('HUI Index');
ax = gca;
ax.FontSize = fsize;
grid on
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
xlabel('m day^{-1}');xlim([0 3]);box on;
legend([a,b,c],{'Nino','Nina','Neutro'},'Location', 'southeast'); box on;


%% yearly
%aa= mean(mean(reshape(nWMLD,[185 12 21]),1),2); 


%% 
%bb = mean(mean(reshape(Analytical,[185 12 21]),1),2);
%plot(permute(aa,[3 1 2])); hold on; yyaxis left
%plot(permute(bb,[3 1 2]));

