%% SSH var
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/CUTI
clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,f,path1]=lets_get_started;
mask(mask==0)=NaN;
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/CUTI

%% load 
load('MLD.mat');
load('SSH_croco.mat');
Humboldt_ports;

%% 
dy=diff(LAT(1,:));
[dxx,dyy]=gradient(LAT);
%% 
R = 6371; %km

% Calculate the distance of 1 degree of latitude
distance_per_degree = (2 * pi * R) / 360;

% Calculate the distance between the latitudes
distance_between_latitudes = dxx .* distance_per_degree*1000; %m %dy

%distance_Array=repmat(distance_between_latitudes'*1000,1,size(SSH,1))';%meters

%%
%[LON,LAT]=meshgrid(lon,lat);
%[x,y] = ll2utm(LAT,LON,'wgs84',18);

%--- la primera derivada.
[auxx,auxy]=gradient(SSH); 
%adtx=auxx./dx; 
ugeo=auxx./distance_between_latitudes;

%f=coriolisf(LAT);
g=9.81;

%% 
pcolor(LON,LAT,ugeo(:,:,1).*mask); shading flat;
%% 
UGEO = -g.*ugeo.*MLD./f;
LTM_UGEO = mean(UGEO,3,'omitnan');
LTM_ugeo = mean(ugeo,3,'omitnan');

%%
Humboldt_ports;
grey = [0.5 0.5 0.5];

figure
P=get(gcf,'position');
P(3)=P(3)*2.1;
P(4)=P(4)*2.4;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(1,2,1)
pcolor(LON,LAT,LTM_ugeo.*mask.*86400); shading flat;
hold on
[c,h]=contour(LON,LAT,LTM_ugeo.*mask.*86400,[0:0.5:5],'Color',grey);
%caxis([-5 5])
clabel(c,h);
cmocean('balance',41);
%borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 
ax = gca;
ax.FontSize = 20; 
% hold on
% for i = 1:length(Puertos)
%     key = Puertos{i,1}; % Get port name
%     x = Puertos{i,2}(2); % Get longitude
%     y = Puertos{i,2}(1); % Get latitude
%     plot(x,y,'ko--','markerfacecolor','m');
%     text(x+0.2, y, key, 'FontSize', 14); % Plot text
% end
title('Long-term mean of ocean [1990-2010] ugeo','fontsize',22); 
caxis([-0.05, 0.05]);
ticks = -0.05:0.01:0.05;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String='m/day';
c.Label.FontSize = 20;

subplot(1,2,2)
pcolor(LON,LAT,LTM_UGEO.*mask); shading flat;
hold on
[c,h]=contour(LON,LAT,LTM_UGEO.*mask,[0:0.5:5],'Color',grey);
%caxis([-5 5])
clabel(c,h);
cmocean('balance',41);
%borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 
ax = gca;
ax.FontSize = 20; 
c=colorbar;
c.Label.String='m^{2}/s';
c.Label.FontSize = 20;
% hold on
% for i = 1:length(Puertos)
%     key = Puertos{i,1}; % Get port name
%     x = Puertos{i,2}(2); % Get longitude
%     y = Puertos{i,2}(1); % Get latitude
%     plot(x,y,'ko--','markerfacecolor','m');
%     text(x+0.2, y, key, 'FontSize', 14); % Plot text
% end
title('Long-term mean of ocean [1990-2010] UGEO','fontsize',22); 
caxis([-5, 5]);
ticks = -5:0.5:5;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String='m^{2}/s';
c.Label.FontSize = 18;
%%
UEK=table2array(struct2table(load('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BakunIndex_Final.mat','UE')));

% [Xu,Yu]=meshgrid(LON(:,1), latiCUTI(1,:));
% 
% for ii=1:1:size(SSH,3)
%     UGEO(:,:,ii) = interp2(Xu,Yu,Ugeo(:,:,1)', LON', LAT', 'linear')'; %
%     disp(ii)
% end
%% 
CUTI = UEK + UGEO ;
LTM_CUTI = mean(CUTI,3,'omitnan');
LTM_UE = mean(UEK,3,'omitnan');
%% 
Humboldt_ports;
grey = [0.5 0.5 0.5];

figure
P=get(gcf,'position');
P(3)=P(3)*1;
P(4)=P(4)*2.4;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

pcolor(LON,LAT,LTM_CUTI.*mask); shading flat;
hold on
[c,h]=contour(LON,LAT,LTM_CUTI.*mask,[0:1:5],'Color',grey);
%caxis([-5 5])
clabel(c,h);
cmocean('balance',41);
borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 
ax = gca;
ax.FontSize = 20; 
c=colorbar;
c.Label.String='m^{2}/s';
c.Label.FontSize = 20;
hold on
for i = 1:length(Puertos)
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end
title('Long-term mean of ocean [1990-2010] CUTI','fontsize',22); 
caxis([-5, 5]);
ticks = -5:0.5:5;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String='m^{2}/s';
c.Label.FontSize = 18;

%% let's cut
arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

ind1=double(inpolygon(LON,LAT,lonb1,latb1));
ind1(ind1==0)=NaN;

lati=LAT(1,:); loni=LON(:,1);
indxlat=find(lati>=-20 & lati<=-5);

nCUTI=CUTI.*ind1.*mask;
cCUTI=nCUTI(:,indxlat,:);
%% 
figure
[c,h]=contourf(loni,lati(indxlat),squeeze(cCUTI(:,:,100)'),[-10:0.2:10]);shading flat; colorbar; 
cmocean('balance',13); set(h,'LineColor','none');
axis([-90 -70 -20 -5]);

title('CUTI Index','fontsize',16); 
caxis([-5 5]);
%%
time=time';
Mean_CUTI=permute(mean(cCUTI,1,'omitnan'),[2 3 1]);

time2=linspace(1990,2010.99,length(time))';
%pcolor(time2,Mean_Bakun); shading flat;
latCUTI=lati(indxlat);
%% 
figure
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*1.2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(time2,latCUTI,Mean_CUTI,[-30:0.1:30]);colorbar; 
cmocean('balance',41); set(h,'LineColor','none'); clabel(c,h);
title('Monthly CUTI Index 150km offshore','fontsize',22); 
ax = gca;
ax.FontSize = 18;
ylabel('Latitude'); xlabel('Time');
ax = gca;
ax.FontSize = 18; 
caxis([-7 7]);
ticks = -7:1:7;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String='m^{2}/s';
c.Label.FontSize = 20;

%% Climatology

jj=0;
[yr,mo]=datevec(time');

for imo=1:1:12
    
    indxclim=find(mo==imo);
    
    climCUTI(:,imo)=mean(Mean_CUTI(:,indxclim),2,'omitnan');
    
end
%% 
timeclim=1:12;

figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*3;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(timeclim,latCUTI,climCUTI,[-20:0.1:20]);shading flat; colorbar; 
cmocean('balance',41); clabel(c,h);set(h,'LineColor','none'); 
hold on
% [c,h]=contour(timeclim,latCUTI,climCUTI,[-1:0.5:5],'Color',grey);
% clabel(c,h);
title('CUTI Index Climatology 150km offshore','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Months');
caxis([-4 4]);
ticks = -4:1:4;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String='m^{2}/s';
c.Label.FontSize = 18;