clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,~,path1]=lets_get_started;
mask(mask==0)=NaN;
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/w_analytical;
load('MLD_W_1990_2010.mat');
load('ENSO_DANTE_dates.mat');
timeNINO2(16)=[]; indxNINO2(16) = [];

arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
%arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/SST/BK111km.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

%% climatology of WMLD
time = generate_monthly_time_vector(1990, 2010)';
%ttime=datevec(time);

jj=0;
[yr,mo]=datevec(time);

for imo=1:1:12
    disp(imo)
    indxclim=find(mo==imo);
    
    climWMLD(:,:,imo)=mean(Wmld(:,:,indxclim),3,'omitnan');
    
end

%-------- now anomalies -----%
jj=0;
for iy = yr(1):yr(end)
    
    for imo=mo(1):1:mo(end)
        
        indxAnom=find(yr==iy & mo==imo);
        disp(datestr(time(indxAnom)));
        jj=jj+1;
        anomWMLD(:,:,jj) = Wmld(:,:,indxAnom) - climWMLD(:,:,imo);
        
    end
end

%% NINO
WMLD = permute(Wmld,[2 1 3]).*mask;
WMLD_NINO = mean(WMLD(:,:,indxNINO2),3,'omitnan');
WMLD_NINA = mean(WMLD(:,:,indxNINA2),3,'omitnan');
WMLD_NEUTRO = mean(WMLD(:,:,indxNEUTRO2),3,'omitnan');

%---- ANOM ---- % 
WMLD_a = permute(anomWMLD,[2 1 3]).*mask;
WMLD_NINO_a = mean(WMLD_a(:,:,indxNINO2),3,'omitnan');
WMLD_NINA_a = mean(WMLD_a(:,:,indxNINA2),3,'omitnan');
WMLD_NEUTRO_a = mean(WMLD_a(:,:,indxNEUTRO2),3,'omitnan');

Humboldt_ports;

%pcolor(LON,LAT,WMLD_NINO.*86400); shading flat;
%% ----------------- Long Term Mean ----------------- %%
[~,ylab] = generateYLabels(20,5,5);
[~,xlab] = generateXLabels(90,70,5);

%------- LTM NINO ---------------%
figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');
subplot(2,2,1)
[c,h]=contourf(LON,LAT,WMLD_NINO.*86400,[-10:0.1:10]);
axis([-90 -70 -20 -5]); caxis([-2 2]);cmocean('balance',9); colorbar;
title('LTM NINO'); set(h,'LineColor','none');
hold on
for i = 1:5
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end
hold on
plot(lonb1,latb1,'k','linewidth',2);

ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);

%---------------- LTM NINA -------------------------%
subplot(2,2,2)
[c,h]=contourf(LON,LAT,WMLD_NINA.*86400,[-10:0.1:10]);
axis([-90 -70 -20 -5]); caxis([-2 2]);cmocean('balance',9); colorbar;
title('LTM NINA'); set(h,'LineColor','none');
hold on
for i = 1:5
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end
hold on
plot(lonb1,latb1,'k','linewidth',2);

ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);

%---------------- LTM NEUTRO -------------------------%
subplot(2,2,3)
[c,h]=contourf(LON,LAT,WMLD_NEUTRO.*86400,[-10:0.1:10]);
axis([-90 -70 -20 -5]); caxis([-2 2]);cmocean('balance',9); colorbar;
title('LTM NEUTRO'); set(h,'LineColor','none');
hold on
for i = 1:5
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end
hold on
plot(lonb1,latb1,'k','linewidth',2);

ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);


%% ----------------- Anomalies LTM ----------------- %%
[~,ylab] = generateYLabels(20,5,5);
[~,xlab] = generateXLabels(90,70,5);
crange = [-1 1];
%------- LTM NINO ---------------%
figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');
subplot(2,2,1)
[c,h]=contourf(LON,LAT,WMLD_NINO_a.*86400,[-10:0.1:10]);
axis([-90 -70 -20 -5]); caxis(crange);cmocean('balance',9); colorbar;
title('Anom LTM NINO'); set(h,'LineColor','none');
hold on
for i = 1:5
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end
hold on
plot(lonb1,latb1,'k','linewidth',2);

ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);

%---------------- LTM NINA -------------------------%
subplot(2,2,2)
[c,h]=contourf(LON,LAT,WMLD_NINA_a.*86400,[-10:0.1:10]);
axis([-90 -70 -20 -5]); caxis(crange);cmocean('balance',9); colorbar;
title('Anom LTM NINA'); set(h,'LineColor','none');
hold on
for i = 1:5
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end
hold on
plot(lonb1,latb1,'k','linewidth',2);

ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);

%---------------- LTM NEUTRO -------------------------%
subplot(2,2,3)
[c,h]=contourf(LON,LAT,WMLD_NEUTRO_a.*86400,[-10:0.1:10]);
axis([-90 -70 -20 -5]); caxis(crange);cmocean('balance',9); colorbar;
title('Anom LTM NEUTRO'); set(h,'LineColor','none');
hold on
for i = 1:5
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end
hold on
plot(lonb1,latb1,'k','linewidth',2);

ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);

%% lateral comparison
ind1=double(inpolygon(LON,LAT,lonb1,latb1));
ind1(ind1==0)=NaN;

Lat_WMLD_NINO = mean(WMLD_NINO.*ind1.*mask,1,'omitnan')';
Lat_WMLD_NINA = mean(WMLD_NINA.*ind1.*mask,1,'omitnan')';
Lat_WMLD_NEUTRO = mean(WMLD_NEUTRO.*ind1.*mask,1,'omitnan')';

rmLat_WMLD_NINO=movmean(Lat_WMLD_NINO,13);
rmLat_WMLD_NINA=movmean(Lat_WMLD_NINA,13);
rmLat_WMLD_NEUTRO=movmean(Lat_WMLD_NEUTRO,13);

% --------- Anomalies ---------- %
Lat_WMLD_NINO_a = mean(WMLD_NINO_a.*ind1.*mask,1,'omitnan')';
Lat_WMLD_NINA_a = mean(WMLD_NINA_a.*ind1.*mask,1,'omitnan')';
Lat_WMLD_NEUTRO_a = mean(WMLD_NEUTRO_a.*ind1.*mask,1,'omitnan')';

rmLat_WMLD_NINO_a=movmean(Lat_WMLD_NINO_a,13);
rmLat_WMLD_NINA_a=movmean(Lat_WMLD_NINA_a,13);
rmLat_WMLD_NEUTRO_a=movmean(Lat_WMLD_NEUTRO_a,13);

% -- upwelling centers 
up_center = [5, 7.5, 10, 11, 14, 15]*-1;
 
arr= ones(length(up_center), 1); 
arr(arr==1)=1.5; 
arr2= ones(length(up_center), 1); 
arr2(arr2==1)=-1.5;
%%  plot ------ Long Term Mean --------------- %% 
[~,ylab] = generateYLabels(20,4,2);

lati=LAT(1,:);
fsize=20;
%ylab={'20S','15S','10S','5S'};
grey = [0.5 0.5 0.5];

figure
P=get(gcf,'position');
P(3)=P(3)*1.4;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(1,2,1)
%----- NINA --------%
barh(up_center,arr,'FaceColor', grey, 'EdgeColor', 'none','FaceAlpha', 0.3,'BarWidth', 1);
hold on
plot(Lat_WMLD_NINA*86400,lati,'Color',[0, 0.4470, 0.7410],'linewidth',1,'linestyle',':');
hold on
a=plot(rmLat_WMLD_NINA*86400,lati,'Color',[0, 0.4470, 0.7410],'linewidth',2);
hold on
%------ NINO ---------%
plot(Lat_WMLD_NINO*86400,lati,'Color',[0.8500 0.3250 0.0980],'linewidth',1,'linestyle',':');
hold on
b=plot(rmLat_WMLD_NINO*86400,lati,'Color',[0.8500 0.3250 0.0980],'linewidth',2);

%-----NEUTRO ----------%
plot(Lat_WMLD_NEUTRO*86400,lati,'Color',grey,'linewidth',1,'linestyle',':');
hold on
c=plot(rmLat_WMLD_NEUTRO*86400,lati,'Color',grey,'linewidth',2);

title('ENSO');

ax = gca;
ax.FontSize = fsize;
grid on
set(gca,'ytick',[-20:2:-4],'yticklabel',ylab,'ylim',[-20 -4]);
xlabel('m day^{-1}');

legend([a,b,c],{'NINA','NINO','NEUTRO'})

xlim([0 1.5]);
%%  plot ------ Anomalies Long Term Mean --------------- %% 
[~,ylab] = generateYLabels(20,4,2);

lati=LAT(1,:);
fsize=20;
%ylab={'20S','15S','10S','5S'};
grey = [0.5 0.5 0.5];


% P=get(gcf,'position');
% P(3)=P(3)*0.7;
% P(4)=P(4)*2;
% set(gcf,'position',P);
% set(gcf,'PaperPositionMode','auto');
subplot(1,2,2)
barh(up_center,arr,'FaceColor', grey, 'EdgeColor', 'none','FaceAlpha', 0.3,'BarWidth', 1);
hold on
barh(up_center,arr2,'FaceColor', grey, 'EdgeColor', 'none','FaceAlpha', 0.3,'BarWidth', 1);
hold on;
%----- NINA --------%
plot(Lat_WMLD_NINA_a*86400,lati,'Color',[0, 0.4470, 0.7410],'linewidth',1,'linestyle',':');
hold on
a=plot(rmLat_WMLD_NINA_a*86400,lati,'Color',[0, 0.4470, 0.7410],'linewidth',2);
hold on
%------ NINO ---------%
plot(Lat_WMLD_NINO_a*86400,lati,'Color',[0.8500 0.3250 0.0980],'linewidth',1,'linestyle',':');
hold on
b=plot(rmLat_WMLD_NINO_a*86400,lati,'Color',[0.8500 0.3250 0.0980],'linewidth',2);

%-----NEUTRO ----------%
plot(Lat_WMLD_NEUTRO_a*86400,lati,'Color',grey,'linewidth',1,'linestyle',':');
hold on
c=plot(rmLat_WMLD_NEUTRO_a*86400,lati,'Color',grey,'linewidth',2);

title('Anomaly ENSO');

ax = gca;
ax.FontSize = fsize;
grid on
set(gca,'ytick',[-20:2:-4],'yticklabel',ylab,'ylim',[-20 -4]);
xlabel('m day^{-1}');

legend([a,b,c],{'NINA','NINO','NEUTRO'})
xlim([-0.2 0.4]);