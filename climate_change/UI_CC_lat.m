%Latitudinal mean
load('W_analytical.mat', 'lati')
%paths 
p1 ='/Volumes/BM_2019_01/climate/ref';
p2 = '/Volumes/BM_2019_01/climate/T+';
p3 = '/Volumes/BM_2019_01/climate/wind-';
p4 = '/Volumes/BM_2019_01/climate/wind+';

%analytical velocity
A1 = mean(struct2array(load(fullfile(p1,'W_analytical.mat'), 'Monthly_wa')),2,'omitnan')*86400;
A2 = mean(struct2array(load(fullfile(p2,'W_analytical.mat'), 'Monthly_wa')),2,'omitnan')*86400;
A3 = mean(struct2array(load(fullfile(p3,'W_analytical.mat'), 'Monthly_wa')),2,'omitnan')*86400;
A4 = mean(struct2array(load(fullfile(p4,'W_analytical.mat'), 'Monthly_wa')),2,'omitnan')*86400;

%BUI
B1 = mean(struct2array(load(fullfile(p1,'BUI.mat'), 'Mean_Bakun')),2,'omitnan');
B2 = mean(struct2array(load(fullfile(p2,'BUI.mat'), 'Mean_Bakun')),2,'omitnan');
B3 = mean(struct2array(load(fullfile(p3,'BUI.mat'), 'Mean_Bakun')),2,'omitnan');
B4 = mean(struct2array(load(fullfile(p4,'BUI.mat'), 'Mean_Bakun')),2,'omitnan');

%CUTI
C1 = struct2array(load(fullfile(p1,'CUTI.mat'),'CUTI_latitudinal'));
C2 = struct2array(load(fullfile(p2,'CUTI.mat'),'CUTI_latitudinal'));
C3 = struct2array(load(fullfile(p3,'CUTI.mat'),'CUTI_latitudinal'));
C4 = struct2array(load(fullfile(p4,'CUTI.mat'),'CUTI_latitudinal'));

%BEUTI
BE1 = struct2array(load(fullfile(p1,'BEUTI.mat'),'BEUTI_latitudinal'));
BE2 = struct2array(load(fullfile(p2,'BEUTI.mat'),'BEUTI_latitudinal'));
BE3 = struct2array(load(fullfile(p3,'BEUTI.mat'),'BEUTI_latitudinal'));
BE4 = struct2array(load(fullfile(p4,'BEUTI.mat'),'BEUTI_latitudinal'));

%CUI
CU1 = struct2array(load(fullfile(p1,'CUI_SST_index.mat'),'CUI_lat'));
CU2 = struct2array(load(fullfile(p2,'CUI_SST_index.mat'),'CUI_lat'));
CU3 = struct2array(load(fullfile(p3,'CUI_SST_index.mat'),'CUI_lat'));
CU4 = struct2array(load(fullfile(p4,'CUI_SST_index.mat'),'CUI_lat'));

%HUI
H1 = struct2array(load(fullfile(p1,'HUI_index.mat'),'HUI_lat'))'*86400;
H2 = struct2array(load(fullfile(p2,'HUI_index.mat'),'HUI_lat'))'*86400;
H3 = struct2array(load(fullfile(p3,'HUI_index.mat'),'HUI_lat'))'*86400;
H4 = struct2array(load(fullfile(p4,'HUI_index.mat'),'HUI_lat'))'*86400;
%% PLOT 
[~,ylab] = generateYLabels(20,5,5);

figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');
%Analytical
subplot(2,3,1); hold on
plot(movmean(A1,13),lati,'k','linewidth',3);
plot([movmean(A4,13) movmean(A2,13) movmean(A3,13)],lati,'linewidth',2);
legend('Ref','W+','T+','W-'); title('Analytical Velocity');
ax = gca; grid minor;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('$\mathrm{m \cdot d^{-1}}$','interpreter','latex');
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
box on;

%BUI
subplot(2,3,2); hold on
plot(movmean(B1,13),lati,'k','linewidth',3);
plot([ movmean(B4,13) movmean(B2,13) movmean(B3,13)],lati,'linewidth',2);
legend('Ref','W+','T+','W-'); title('BUI');
ax = gca; grid minor;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('$\mathrm{m^{2} \cdot s^{-1}}$','interpreter','latex');
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
box on;

%CUTI
subplot(2,3,3);hold on
plot(movmean(C1,13),lati,'k','linewidth',3);
plot([movmean(C4,13) movmean(C2,13) movmean(C3,13)],lati,'linewidth',2);
legend('Ref','W+','T+','W-'); title('CUTI');
ax = gca; grid minor;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('$\mathrm{m^{2} \cdot s^{-1}}$','interpreter','latex');
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
box on;

%BEUTI
subplot(2,3,4);hold on
plot(movmean(BE1,13),lati,'k','linewidth',3);
plot([movmean(BE4,13) movmean(BE2,13) movmean(BE3,13) ],lati,'linewidth',2);
legend('Ref','W+','T+','W-'); title('BEUTI');
ax = gca; grid minor;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('$m mol \cdot m^{-1} \cdot s^{-1}$', 'Interpreter', 'latex');
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
box on;

%CUI
subplot(2,3,5); hold on
plot(movmean(CU1,13),lati,'k','linewidth',3);
plot([movmean(CU4,13) movmean(CU2,13) movmean(CU3,13) ],lati,'linewidth',2);
legend('Ref','W+','T+','W-'); title('CUI');
ax = gca; grid minor;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('$^\circ C$','interpreter','latex');
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
box on;

%HUI
subplot(2,3,6); hold on
plot(movmean(H1,13),lati,'k','linewidth',3);
plot([movmean(H4,13) movmean(H2,13) movmean(H3,13) ],lati,'linewidth',2);
legend('Ref','W+','T+','W-'); title('HUI');
ax = gca; grid minor;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('$\mathrm{m \cdot d^{-1}}$','interpreter','latex');
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
box on;

%% now the W at mld
%[climW, ~] = calculateClimatologyAndAnomalies(zoo, time);
[mask, LON, LAT, ~,~] = lets_get_started_CC;
W1 = calculate_URegion(permute(struct2array(load(fullfile(p1,'WMLD_MLD.mat'), 'WMLD')),[2 1 3]), LON, LAT, mask)*86400;
W2 = calculate_URegion(permute(struct2array(load(fullfile(p2,'WMLD_MLD.mat'), 'WMLD')),[2 1 3]), LON, LAT, mask)*86400;
W3 = calculate_URegion(permute(struct2array(load(fullfile(p3,'WMLD_MLD.mat'), 'WMLD')),[2 1 3]), LON, LAT, mask)*86400;
W4 = calculate_URegion(permute(struct2array(load(fullfile(p4,'WMLD_MLD.mat'), 'WMLD')),[2 1 3]), LON, LAT, mask)*86400;

%---- Lat 
nW1 = mean(W1,2,'omitnan');
nW2 = mean(W2,2,'omitnan');
nW3 = mean(W3,2,'omitnan');
nW4 = mean(W4,2,'omitnan');

%season
sW1 = mean(W1,1,'omitnan');
sW2 = mean(W2,1,'omitnan');
sW3 = mean(W3,1,'omitnan');
sW4 = mean(W4,1,'omitnan');

%% -- THE WMLD during ENSO 97/98
load('MLD_W_1990_2010.mat');

wmld1 = calculate_URegion(permute(Wmld,[2 1 3]),LON,LAT,mask);
load('NINO9798.mat')
% wmldEN = mean(nwmld(:, EN9798_index),2,'omitnan');
% wmldEN_a = mean(nwmld_a(:, EN9798_index),2,'omitnan');
wmldEN = mean(wmld1(:, EN9798_index),2,'omitnan');

%-----upwelling centers
up_center = [5, 7.5, 10, 11, 14, 15]*-1;
 
arr= ones(length(up_center), 1); 
arr(arr==1)=1.5; 
arr2= ones(length(up_center), 1); 
arr2(arr2==1)=-1.5;

%% Plot 
[~,ylab] = generateYLabels(20,5,5);
grey = [0.5 0.5 0.5];
  
figure
barh(up_center,arr,'FaceColor', grey, 'EdgeColor', 'none','FaceAlpha', 0.3,'BarWidth', 1);
hold on
a=plot(movmean(nW1,13),lati,'k','linewidth',3); hold on;
b=plot(movmean(nW4,13),lati,'linewidth',2); %movmean(nW2,13) movmean(nW3,13
c=plot(movmean(nW2,13),lati,'linewidth',2); %movmean(nW2,13) movmean(nW3,13
d=plot(movmean(nW3,13),lati,'linewidth',2); %movmean(nW2,13) movmean(nW3,13
hold on
e=plot(movmean(wmldEN*86400,13),lati,'r--','linewidth',2);
legend([a,b,c,d,e],'Ref','W+','T+','W-','EN 97/98'); 
title('Simulated W');
ax = gca; grid minor;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('$\mathrm{m \cdot d^{-1}}$','interpreter','latex');
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);

%% Climatology

timeclim=[1:12]';
grey = [0.5 0.5 0.5];
ylab={'20°S','15°S','10°S','5°S'};
xlab={'J','F','M','A','M','J','J','A','S','O','N','D'};


figure
P=get(gcf,'position');
P(3)=P(3)*4;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');
%---ref
subplot(2, 4, 1);
[c,h]=contourf(timeclim,lati,W1,[-10:0.01:10]);colorbar; 
cmocean('balance',17); clabel(c,h);set(h,'LineColor','none'); 
title('Simulated W [ref]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Months');
caxis([-2 2]);
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%--T+
subplot(2, 4, 2);
[c,h]=contourf(timeclim,lati,W2,[-10:0.01:10]);colorbar; 
cmocean('balance',17); clabel(c,h);set(h,'LineColor','none'); 
title('Simulated W [T+]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Months');
caxis([-2 2]);
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%--wind -
subplot(2, 4, 3);
[c,h]=contourf(timeclim,lati,W3,[-10:0.01:10]);colorbar; 
cmocean('balance',17); clabel(c,h);set(h,'LineColor','none'); 
title('Simulated W [Wind-]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Months');
caxis([-2 2]);
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%--- wind + 
subplot(2, 4, 4);
[c,h]=contourf(timeclim,lati,W4,[-10:0.01:10]);colorbar; 
cmocean('balance',17); clabel(c,h);set(h,'LineColor','none'); 
title('Simulated W [Wind+]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Months');
caxis([-2 2]);
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

% ------------ Moving average ------- % 
%---ref
subplot(2, 4, 5);
[c,h]=contourf(timeclim,lati,movmean(W1,13,1),[-10:0.01:10]);colorbar; 
cmocean('balance',17); clabel(c,h);set(h,'LineColor','none'); 
title('Simulated W [ref]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); 
xlabel('Months');
caxis([-2 2]);
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%--T+
subplot(2, 4, 6);
[c,h]=contourf(timeclim,lati,movmean(W2,13,1),[-10:0.01:10]);colorbar; 
cmocean('balance',17); clabel(c,h);set(h,'LineColor','none'); 
title('Simulated W [T+]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Months');
caxis([-2 2]);
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%--wind -
subplot(2, 4, 7);
[c,h]=contourf(timeclim,lati,movmean(W3,13,1),[-10:0.01:10]);colorbar; 
cmocean('balance',17); clabel(c,h);set(h,'LineColor','none'); 
title('Simulated W [Wind-]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Months');
caxis([-2 2]);
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%--- wind + 
subplot(2, 4, 8);
[c,h]=contourf(timeclim,lati,movmean(W4,13,1),[-10:0.01:10]);colorbar; 
cmocean('balance',17); clabel(c,h);set(h,'LineColor','none'); 
title('Simulated W [Wind-]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Months');
caxis([-2 2]);
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%% for thesis
figure
P=get(gcf,'position');
P(3)=P(3)*1.7;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(2, 2, 1);
[c,h]=contourf(timeclim,lati,movmean(W1,13,1),[-10:0.01:10]);colorbar; 
cmocean('balance',17); clabel(c,h);set(h,'LineColor','none'); 
title('Simulated W [Ref]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); 
xlabel('Months');
caxis([-2 2]);
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%--T+
subplot(2, 2, 2);
[c,h]=contourf(timeclim,lati,movmean([W2 - W1],13,1),[-10:0.01:10]);colorbar; 
%[c,h]=contourf(timeclim,lati,[movmean(W2,13,1)-movmean(W1,13,1)],[-10:0.01:10]);colorbar; 
cmocean('balance',9); clabel(c,h);set(h,'LineColor','none'); 
title('[T +] - [ref]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Months');
caxis([-1.4 1.4]);
ticks = -1.6:0.4:1.6;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%--wind -
subplot(2, 2, 3);
[c,h]=contourf(timeclim,lati,movmean([W3 - W1],13,1),[-10:0.01:10]);colorbar; 
cmocean('balance',9); clabel(c,h);set(h,'LineColor','none'); 
title('[Wind -] - [ref]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Months');
caxis([-1.4 1.4]);
ticks = -1.6:0.4:1.6;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%--- wind + 
subplot(2, 2, 4);
[c,h]=contourf(timeclim,lati,movmean([W4 - W1],13,1),[-10:0.01:10]);colorbar; 
cmocean('balance',9); clabel(c,h);set(h,'LineColor','none'); 
title('[Wind +] - [ref]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Months');
caxis([-1.4 1.4]);
ticks = -1.6:0.4:1.6;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside
%% climatologies
matblue = [0, 0.4470, 0.7410];
matred = [0.8500, 0.3250, 0.0980];
matyellow = [0.9290 0.6940 0.1250];


figure; hold on
a=plot([1:12],sW1,'Color','k','linewidth',3);%ref
b=plot([1:12],sW2,'Color',matred,'linewidth',2); %temp +
c=plot([1:12],sW3,'Color',matyellow,'linewidth',2); %wind -
d=plot([1:12],sW4,'Color',matblue,'linewidth',2); %wind + 
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

title('Seasonality','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('$\mathrm{m \cdot d^{-1}}$','interpreter','latex');
xlabel('Months');
grid on;

legend([a,b,d,c],{'ref','T+','W +','W -'},'orientation','horizontal');
box on;
