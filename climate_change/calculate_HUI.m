function calculate_HUI(in_path,fname)
[mask,LON,LAT,~,~]=lets_get_started_CC;
cd(in_path);
fn = fname;
f = ncread(fn,'f');
f=f.*mask;
%% 
D = struct2array(load(fullfile(in_path,'EKMAN_pump.mat'),'Divergence')).*mask;
Ekman_pump = struct2array(load(fullfile(in_path,'EKMAN_pump.mat'),'EK_pump')).*mask;

%% Ekman Pump modified vertical upwelling index %EPMUI
rho_seawater=1025;
LTM_EK = mean(Ekman_pump,3,'omitnan');
%PUI_2nd = mean(((beta2.*Taux)./(rho_seawater.*(f.^2))),3,'omitnan');

%PUI = (Curl./(rho_seawater.*f)) + ((beta2.*Taux)./(rho_seawater.*(f.^2)));
%LTM_PUI = mean(PUI,3,'omitnan').*86400;
%LTM_Taux = mean(Taux,3,'omitnan');
D = (D./(rho_seawater.*f))*-1;
LTM_D = mean(D,3,'omitnan');

HUI = Ekman_pump + D;
LTM_HUI = mean(HUI,3,'omitnan');
%% Now the Upwelling index by bravo
%Upwelling Index = Ekman pump + Coastal Divergence;

%% ---- Plot HUI ---- %% 
[~,ylab] = generateYLabels(20,5,5);
[~,xlab] = generateXLabels(90,70,5);
Humboldt_ports;

flag=0;
if flag==1
    
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
title('LTM Ekman Pump'); set(h,'LineColor','none');
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
axis([-90 -70 -20 -5]); caxis([-5 5]); cmocean('balance',11); colorbar;
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
ticks = -5:1:5;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);

%savefig('LTM_HUI.fig'); 
end
%% -- Monthly effect --- %
time = [1:12]';
arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
%arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/SST/BK111km.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

ind1=double(inpolygon(LON,LAT,lonb1,latb1));
ind1(ind1==0)=NaN;

nHUI = HUI.*ind1;
indxlat = find(LAT(1,:)<=-5 & LAT(1,:)>=-20)';
lati=LAT(1,indxlat)';


Mean_HUI = permute(mean(nHUI(:,indxlat,:),1,'omitnan'),[3 2 1]);

%% --- Climatology of HUI --- % 

% -------- plot ------%

timeclim=[1:12]';
grey = [0.5 0.5 0.5];
ylab={'20S','15S','10S','5S'};
xlab={'J','F','M','A','M','J','J','A','S','O','N','D'};


figure
P=get(gcf,'position');
P(3)=P(3)*1;
P(4)=P(4)*1.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(timeclim,lati,Mean_HUI'.*86400,[-10:0.01:10]);colorbar; 
cmocean('balance',13); clabel(c,h);set(h,'LineColor','none'); 
title('HUI Climatology','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Months');
caxis([-5 5]);
ticks = -5:1:5;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);

savefig('HUI_clim.fig');close;
%% all mean

HUI_index = mean(Mean_HUI,2,'omitnan');
HUI_lat = mean(Mean_HUI,1,'omitnan');

%% save
save('HUI_index.mat','HUI_lat','time','lati','Mean_HUI','HUI_index');