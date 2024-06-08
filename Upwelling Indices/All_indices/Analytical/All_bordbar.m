clear all; close all; clc;
%% 
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;

load('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Wc_mean_wstrss.mat'); %Wc
load('Ekman_We_wind.mat');%WSCD
load('EKMAN_pump_April.mat')
load('/Users/dlizarbe/Documents/DANIEL/depths/MLD_W_1990_2010.mat'); % CROCO

Humboldt_ports;

W_MLD=mean(Wmld,3,'omitnan');

%W_analytical = Mean_We + Wc_mean; %m/s
W_analytical = LTM_ekpump + Wc_mean;
%W_a = WcMean + Ekman_We;
W_a = WcMean + EK_pump;

W_amean=nanmean(W_a,3);
%% 
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout/Bordbar
dark_green_rgb = [0, 0.5, 0];

figure
P=get(gcf,'position');
P(3)=P(3)*2.4;
P(4)=P(4)*2.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(1,2,1)
[c,h]=contourf(LON,LAT,W_MLD'.*mask.*86400,[-3:0.2:3]);colorbar;
set(h,'LineColor','none');
title('Long-term mean of ocean (1990-2010) W velocity at MLD','fontsize',16); 
cmocean('balance',13);
caxis([-1.6 1.6]); hold on;
qp=quiversc(LON,LAT,U,V,'k');hold on;
%set(qp,'AutoScale','on', 'AutoScaleFactor', 1)

[c,h]=contour(lon,lat,chloro',[0.5 2 5 10],'Color',dark_green_rgb,'linewidth',3);
clabel(c,h,'Color',dark_green_rgb);
borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 
ax = gca;
ax.FontSize = 18; 
c=colorbar;
c.Label.FontSize = 20;
hold on
for i = 1:length(Puertos)
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end
caxis([-1.6, 1.6]);
ticks = -1.6:0.2:1.6;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.FontSize = 20;
c.Label.String='m/day';

subplot(1,2,2)
[c,h]=contourf(LON,LAT,W_amean.*mask.*86400,[-10:0.2:10]);colorbar;
set(h,'LineColor','none');
title('Long-term mean of ocean (1990-2010) W analytical velocity','fontsize',16); 
cmocean('balance',13);
hold on;
quiversc(LON,LAT,U,V,'k');hold on;
[c,h]=contour(lon,lat,chloro',[0.5 2 5 10],'Color',dark_green_rgb,'linewidth',3);
clabel(c,h,'Color',dark_green_rgb);
borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 
ax = gca;
ax.FontSize = 18; 
c=colorbar;
c.Label.String='m/day';
c.Label.FontSize = 20;
hold on
for i = 1:length(Puertos)
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end

caxis([-1.6, 1.6]);
ticks = -1.6:0.2:1.6;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.FontSize = 18;
c.Label.String='m/day';

%% all w analytical components
figure
P=get(gcf,'position');
P(3)=P(3)*2.4;
P(4)=P(4)*2.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(1,2,1)
[c,h]=contourf(LON,LAT,LTM_ekpump.*mask.*86400,[-3:0.2:3]);colorbar;
set(h,'LineColor','none');
title('Long-term mean of ocean (1990-2010) WSCD (Wcurl)','fontsize',16); 
cmocean('balance',13);
hold on;
axis([-90 -70 -33 10]); 
ax = gca;
ax.FontSize = 16; 
c=colorbar;
c.Label.String='m/day';
hold on
for i = 1:length(Puertos)
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 12); % Plot text
end
caxis([-1.6, 1.6]);
ticks = -1.6:0.2:1.6;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.FontSize = 18;
c.Label.String='m/day';

subplot(1,2,2)
[c,h]=contourf(LON,LAT,Wc_mean.*mask.*86400,[-3:0.2:3]);colorbar;
set(h,'LineColor','none');
title('Long-term mean of ocean (1990-2010) Wc','fontsize',16); 
cmocean('balance',13);
hold on;
axis([-90 -70 -33 10]); 
ax = gca;
ax.FontSize = 16; 
c=colorbar;
c.Label.String='m/day';
hold on
for i = 1:length(Puertos)
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 12); % Plot text
end
caxis([-1.6, 1.6]);
ticks = -1.6:0.2:1.6;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.FontSize = 18;
c.Label.String='m/day';

%% Std
Wanalytical_std = std(W_a,0,3,'omitnan');
Wmld_std = std(Wmld,0,3,'omitnan');
dark_green_rgb = [0, 0.5, 0];

%% 
figure
P=get(gcf,'position');
P(3)=P(3)*2.4;
P(4)=P(4)*2.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(1,2,1)
[c,h]=contourf(LON,LAT,Wmld_std'.*mask.*86400,[0:0.2:3]);colorbar;
set(h,'LineColor','none');
title('STD 1990-2010 W velocity at MLD','fontsize',16); 
cmocean('ice',13,'negative');
caxis([0 3]); hold on;
[c,h]=contour(lon,lat,chloro',[0.5 2 5 10],'Color',dark_green_rgb,'linewidth',3);
clabel(c,h,'Color',dark_green_rgb);
borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 
ax = gca;
ax.FontSize = 18; 
c=colorbar;
hold on
for i = 1:length(Puertos)
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 12); % Plot text
end
caxis([0 3]);
ticks = 0:0.2:3;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.FontSize = 18;
c.Label.String='m/day';

subplot(1,2,2)
[c,h]=contourf(LON,LAT,Wanalytical_std.*mask.*86400,[0:0.2:3]);colorbar;
set(h,'LineColor','none');
title('STD 1990-2010 W analytical velocity','fontsize',16); 
cmocean('ice',13,'negative');
hold on;
[c,h]=contour(lon,lat,chloro',[0.5 2 5 10],'Color',dark_green_rgb,'linewidth',3);
clabel(c,h,'Color',dark_green_rgb);
borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 
ax = gca;
ax.FontSize = 18; 
c=colorbar;
c.Label.String='m/day';
hold on
for i = 1:length(Puertos)
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 12); % Plot text
end
caxis([0 3]);
ticks = 0:0.2:3;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.FontSize = 18;
c.Label.String='m/day';
%% Correlations
WMLD=permute(Wmld,[2 1 3]);

% WMLD(isnan(WMLD)==1)=0;
% W_analytical(isnan(W_analytical)==1)=0;

%W_a %Wmld
%rho=corr(WMLD,W_a,'Type','Pearson','Rows','all');
for ilon=1:1:size(LON(:,1),1)
    
    for ilat=1:1:size(LAT(1,:),2)
        
        [R,P]=corrcoef(WMLD(ilon,ilat,:),W_a(ilon,ilat,:));
        
        R_array(ilon,ilat)=R(1,2);
        P_array(ilon,ilat)=P(2,1);
    end
    disp(ilon)
end

%% 
figure
P=get(gcf,'position');
P(3)=P(3)*1;
P(4)=P(4)*2.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(LON,LAT,R_array.*mask,[-0.7:0.1:0.7]);colorbar;
%[c,h]=contourf(LON,LAT,R_array.*mask);colorbar;

set(h,'LineColor','none');
title('Simulated vs Analytical P-Correlation 1990-2010','fontsize',16); 
cmocean('balance',13);
%cmocean('balance');
hold on;
borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 
ax = gca;
ax.FontSize = 16; 
c=colorbar;
c.Label.String='Correlation';
c.Location = 'eastoutside'; % Move colorbar to the right
hold on
for i = 1:length(Puertos)
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 12); % Plot text
end
caxis([-0.7 0.7]);
ticks = -0.7:0.1:0.7;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.FontSize = 18;
c.Label.String='Pearson Correlation';
%%
time=linspace(1990,2010,size(WMLD,3))';
%% 
figure
for ilon=1:1:size(LON(:,1),1)
    
    for ilat=1:1:size(LAT(1,:),2)
     
        plot(time,squeeze(WMLD(ilon,ilat,:)));
        hold on
        plot(time,squeeze(W_a(ilon,ilat,:)));
        xlabel('Time');
        pause(0.1)
        clf
    end
end
%% 
plot(squeeze(WMLD(ilon,ilat,:))',squeeze(W_a(ilon,ilat,:))','.');
%% 
x=dist2coast(LAT,LON);

figure
P=get(gcf,'position');
P(3)=P(3)*1.2;
P(4)=P(4)*2.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(LON,LAT,W_MLD'.*mask.*86400,[-3:0.2:3]);colorbar;
set(h,'LineColor','none');
title('Long-term mean of ocean (1990-2010) W velocity at MLD','fontsize',16); 
cmocean('balance',13);
caxis([-1.6 1.6]); 
hold on
[c,h]=contour(LON,LAT,x.*mask,[150 150],'linewidth',2); clabel(c,h);
axis([-90 -70 -33 10]); 

