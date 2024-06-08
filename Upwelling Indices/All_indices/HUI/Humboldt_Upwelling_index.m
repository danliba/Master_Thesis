clear all; close all; clc;
[mask,LON,LAT,f,path1]=lets_get_started;
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/PUI;
f=f.*mask;
%% 
Curl=table2array(struct2table(load('/Volumes/BM_2022_x/Hindcast_1990_2010/means/EKMAN_pump_April.mat','Curl')));
Taux = table2array(struct2table(load('/Volumes/BM_2022_x/Hindcast_1990_2010/means/EKMAN_pump_April.mat','Crosshore_wind'))).*mask;
D = table2array(struct2table(load('/Volumes/BM_2022_x/Hindcast_1990_2010/means/EKMAN_pump_April.mat','Divergence'))).*mask;
Ekman_pump = table2array(struct2table(load('/Volumes/BM_2022_x/Hindcast_1990_2010/means/EKMAN_pump_April.mat','EK_pump'))).*mask;
[beta,~] = gradient (f);
[latgrad,~] = gradient (LAT);
beta2 = (beta./latgrad).*sign(LAT);

%% Ekman Pump modified vertical upwelling index %EPMUI
rho_seawater=1025;
LTM_EK = mean((Curl./(rho_seawater.*f)),3,'omitnan');
PUI_2nd = mean(((beta2.*Taux)./(rho_seawater.*(f.^2))),3,'omitnan');

PUI = (Curl./(rho_seawater.*f)) + ((beta2.*Taux)./(rho_seawater.*(f.^2)));
LTM_PUI = mean(PUI,3,'omitnan').*86400;
LTM_Taux = mean(Taux,3,'omitnan');
D = (D./(rho_seawater.*f))*-1;
LTM_D = mean(D,3,'omitnan');

HUI = Ekman_pump + D;
LTM_HUI = mean(HUI,3,'omitnan');
%% 
subplot(1,3,1)
pcolor(LON,LAT,LTM_EK.*86400); shading flat;
axis([-90 -70 -20 -5]); caxis([-2 2]); cmocean('balance',11); colorbar;

subplot(1,3,2)
pcolor(LON,LAT,LTM_D.*86400); shading flat;
axis([-90 -70 -20 -5]); caxis([-2 2]); cmocean('balance',11); colorbar;

subplot(1,3,3)
pcolor(LON,LAT,LTM_HUI.*86400); shading flat;
axis([-90 -70 -20 -5]); caxis([-5 5]); cmocean('balance',21); colorbar;
%% Now the Upwelling index by bravo
%Upwelling Index = Ekman pump + Coastal Divergence;

%% ---- Plot HUI ---- %% 
[~,ylab] = generateYLabels(20,5,5);
[~,xlab] = generateXLabels(90,70,5);
Humboldt_ports;
figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

%---- Ekman Pump -----%
subplot(2,2,1)
[c,h]=contourf(LON,LAT,LTM_EK.*86400,[-10:0.1:10]); 
axis([-90 -70 -20 -5]); caxis([-3 3]); cmocean('balance',13); colorbar;
title('LTM Ekman vertical velocity'); set(h,'LineColor','none');
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
ticks = -3:1:3;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);

%----- Coastal Divergence ----- % 
subplot(2,2,2)
[c,h]=contourf(LON,LAT,LTM_D.*86400,[-1:0.005:1]); 
axis([-90 -70 -20 -5]); caxis([-3 3]); cmocean('balance',13); colorbar;
title('LTM Coastal Divergence'); set(h,'LineColor','none');
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
ticks = -3:1:3;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);


%------ Humboldt Upwelling Index ------%
subplot(2,2,3)
[c,h]=contourf(LON,LAT,LTM_HUI.*86400,[-10:0.1:10]); 
axis([-90 -70 -20 -5]); caxis([-3 3]); cmocean('balance',11); colorbar;
title('LTM HUI'); set(h,'LineColor','none');
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
ticks = -3:1:3;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);
%% -- Monthly effect --- %
time = linspace(1990,2010,size(HUI,3))';
arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
%arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/SST/BK111km.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

ind1=double(inpolygon(LON,LAT,lonb1,latb1));
ind1(ind1==0)=NaN;

nHUI = HUI.*ind1;
indxlat = find(LAT(1,:)<=-5 & LAT(1,:)>=-20)';
lati=LAT(1,indxlat)';


Mean_HUI = permute(mean(nHUI(:,indxlat,:),1,'omitnan'),[3 2 1]);

%% --- plot ---%
figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(time,lati,Mean_HUI'*86400,[-10:0.1:10]); 
colorbar; caxis([-4 4]);
cmocean('balance',17); set(h,'LineColor','none'); clabel(c,h);
title('Monthly HUI','fontsize',22); 
ax = gca;
ax.FontSize = 24;
ylabel('Latitude'); xlabel('Time');
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
ticks = -4:1:4;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
%set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);
%% --- Climatology of HUI --- % 
jj=0;
time = generate_monthly_time_vector(1990, 2010)';

[yr,mo]=datevec(time');

for imo=1:1:12
    
    indxclim=find(mo==imo)';
    
    climHUI(:,imo)=mean(Mean_HUI(indxclim,:),1,'omitnan')';
    
end
%% -------- plot ------%

timeclim=1:12';
grey = [0.5 0.5 0.5];
ylab={'20S','15S','10S','5S'};
xlab={'J','F','M','A','M','J','J','A','S','O','N','D'};


figure
P=get(gcf,'position');
P(3)=P(3)*1;
P(4)=P(4)*1.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(timeclim,lati,climHUI.*86400,[-10:0.01:10]);colorbar; 
cmocean('balance',13); clabel(c,h);set(h,'LineColor','none'); 
title('HUI Climatology','fontsize',22); 
hold on
[c,h]=contour(timeclim,lati,climHUI.*86400,[-1:1:3],'Color',grey);
clabel(c,h);
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Months');
caxis([-3 3]);
ticks = -3:1:3;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
%% all mean

HUI_index = mean(Mean_HUI,2,'omitnan');

plot(time,HUI_index);
%% save
save('HUI_index.mat','climHUI','time','lati','Mean_HUI','HUI_index');




