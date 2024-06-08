%% ------ BEUTI ----- %% 
clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,~,path1]=lets_get_started;
mask(mask==0)=NaN;
%%
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BEUTI
CUTI = table2array(struct2table(load('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/CUTI/CUTI_HR.mat','CUTI')));
load('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BEUTI/Nitrogen.mat');

%% Let's find BEUTI 
Total_N = permute(Total_N,[2,1,3]);

BEUTI = Total_N .* CUTI ;
LTM_BEUTI = mean(BEUTI,3,'omitnan');
LTM_CUTI = mean(CUTI,3,'omitnan');
Humboldt_ports;
%% Plot BEUTI 
flag=1;
if flag==1
[~,ylab] = generateYLabels(20,5,5);
[~,xlab] = generateXLabels(90,70,5);

figure 
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*1.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(1,2,2)
[c,h]=contourf(LON,LAT,LTM_BEUTI*-1.*mask,[-100:1:100]);shading flat;
axis([-90 -70 -20 -5]); cmocean('balance',21); 
colorbar; %borders('countries','facecolor','white');
title('BEUTI'); set(h,'LineColor','none');

hold on
for i = 1:5
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end

ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
ticks = -100:20:100;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mu mol \cdot m^{-1} \cdot s^{-1}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);
caxis([-100 100]); 

%Plot CUTI
subplot(1,2,1)
[c,h]=contourf(LON,LAT,LTM_CUTI*-1.*mask,[-100:1:100]);shading flat;
axis([-90 -70 -20 -5]); cmocean('balance',21); 
colorbar;
title('CUTI'); set(h,'LineColor','none');

hold on
for i = 1:length(Puertos)
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end

ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$ m^{2} \cdot s^{-1}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);
caxis([-10 10]); 
end
%% cut
arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

ind1=double(inpolygon(LON,LAT,lonb1,latb1));
ind1(ind1==0)=NaN;

lati=LAT(1,:); loni=LON(:,1);
indxlat=find(lati>=-20 & lati<=-5);

nBEUTI=BEUTI.*ind1.*mask;
cBEUTI=nBEUTI(:,indxlat,:);
%% 
if flag==1
figure
[c,h]=contourf(loni,lati(indxlat),squeeze(cBEUTI(:,:,100)'),[-100:1:100]);shading flat; colorbar; 
cmocean('balance',13); set(h,'LineColor','none');
axis([-90 -70 -20 -5]);

title('BEUTI Index','fontsize',16); 
caxis([-100 100]);
end
%%
time = generate_monthly_time_vector(1990, 2010)';

Mean_BEUTI=permute(mean(cBEUTI,1,'omitnan'),[2 3 1]);

time2=linspace(1990,2010.99,length(time))';
%pcolor(time2,Mean_Bakun); shading flat;
latCUTI=lati(indxlat);
%% 
if flag==1
[~,ylab] = generateYLabels(20,5,5);

figure
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(time2,latCUTI,Mean_BEUTI,[-700:1:700]);colorbar; 
cmocean('balance',21); set(h,'LineColor','none'); clabel(c,h);
title('Monthly BEUTI Index','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Time');
ax = gca;
ax.FontSize = 18; 
caxis([-160 160]);
ticks = -160:40:160;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mu mol \cdot m^{-1} \cdot s^{-1}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
end
%% Climatology

jj=0;
[yr,mo]=datevec(time);

for imo=1:1:12
    
    indxclim=find(mo==imo);
    
    climBEUTI(:,imo)=mean(Mean_BEUTI(:,indxclim),2,'omitnan');
    
end
%% 
timeclim=1:12;
ylab={'20S','15S','10S','5S'};
xlab={'J','F','M','A','M','J','J','A','S','O','N','D'};

if flag==1
grey = [0.5 0.5 0.5];
figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*3;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(timeclim,latCUTI,climBEUTI*-1,[-500:1:500]);shading flat; colorbar; 
cmocean('balance',21); clabel(c,h);set(h,'LineColor','none'); 
hold on
% [c,h]=contour(timeclim,latCUTI,climBEUTI,[-100:20:100],'Color',grey);
% clabel(c,h);
title('BEUTI Climatology','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Months');
caxis([-100 100]);
ticks = -100:20:100;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$mmol \cdot m^{-1} \cdot s^{-1}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);

end
%% 
BEUTI_latitudinal_HR = mean(climBEUTI, 2,'omitnan');
%% plot
if flag==1
plot(BEUTI_latitudinal_HR,latCUTI,'mo-','markerfacecolor','m');
ylabel('Latitude','fontsize',14); xlabel('Transport m^{2}s^{-1}','fontsize',14);
ax = gca;
ax.FontSize = 20; grid minor; title('LTM BEUTI');
end
%% SAVE
Mean_BEUTI_HR= Mean_BEUTI;
%save('BEUTI_HR','time2','latCUTI','Mean_BEUTI_HR','BEUTI_latitudinal_HR','BEUTI');

%%

figure 


[c,h]=contourf(LON,LAT,LTM_BEUTI*-1.*mask,[-100:1:100]);shading flat;
axis([-90 -70 -20 -5]); cmocean('balance',21); 
colorbar; %borders('countries','facecolor','white');
title('BEUTI'); set(h,'LineColor','none');

hold on
for i = 1:5
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end

ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
ticks = -100:20:100;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mu mol \cdot m^{-1} \cdot s^{-1}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);
caxis([-100 100]); 

%% Plot CUTI
figure
[c,h]=contourf(LON,LAT,LTM_CUTI*-1.*mask,[-100:1:100]);shading flat;
axis([-90 -70 -20 -5]); cmocean('balance',21); 
colorbar;
title('CUTI'); set(h,'LineColor','none');

hold on
for i = 1:length(Puertos)
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end

ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$ m^{2} \cdot s^{-1}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);
caxis([-10 10]); 

%% CUTI 

time = generate_monthly_time_vector(1990, 2010)';
nCUTI = calculate_URegion(CUTI, LON, LAT, mask);
[climCUTI, ~] = calculateClimatologyAndAnomalies(nCUTI, time);

%% 
timeclim=1:12;
grey = [0.5 0.5 0.5];


figure
[c,h]=contourf(timeclim,latCUTI,climCUTI*-1,[-20:0.1:20]);shading flat; colorbar; 
cmocean('balance',21); clabel(c,h);set(h,'LineColor','none'); 
hold on
title('CUTI '); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Months');
caxis([-10 10]);
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String='m^{2}/s';
c.Label.FontSize = 18;
xlim([1 12]); 
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);

