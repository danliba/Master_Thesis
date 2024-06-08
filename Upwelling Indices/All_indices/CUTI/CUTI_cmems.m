%% SSH var
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/CUTI
clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/CUTI

%% load 
load('MLD.mat');
load('SSH_copernicus.mat');
Humboldt_ports;

%% 
lati=LAT(1,:)'; loni=LON(:,1);
latiflip=flip(lati);

lati1=latiflip(1:end-1); %10 to -32
lati2=latiflip(2:end);%9.9 to -33;
%flip SSH in the 2nd dimension
% figure; pcolor(LON,LAT,SSH(:,:,1).*mask); shading flat;
% SSHflip=flip(SSH,2);
% pcolor(LON,LAT,SSHflip(:,:,1)); shading flat;
% 

[~,IA1,~] = intersect(lati,lati1);
[~,IA2,~] = intersect(lati,lati2);


SSHA=SSH_cmems(:,IA1,:)/100;%m
SSHB=SSH_cmems(:,IA2,:)/100;

SSH2=abs(SSHA-SSHB);%meters

%% 
R = 6371;

% Calculate the distance of 1 degree of latitude
distance_per_degree = (2 * pi * R) / 360;

% Calculate the distance between the latitudes
distance_between_latitudes = flip(abs(lati1 - lati2) .* distance_per_degree); %km%we flip back

distance_Array=repmat(distance_between_latitudes*1000,1,size(SSH2,1))';%meters

latiCUTI=repmat(flip(lati1),1,size(SSH2,1))';%fliped back

%% plot
subplot(1,3,1)
pcolor(LON(:,1),latiCUTI(1,:),squeeze(SSHA(:,:,1))'); shading flat;
borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 

colorbar;
subplot(1,3,2)
pcolor(LON(:,1),latiCUTI(1,:),squeeze(SSHB(:,:,1))');shading flat;
borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 

colorbar;
subplot(1,3,3)
pcolor(LON(:,1),latiCUTI(1,:),squeeze(SSH2(:,:,1))');shading flat; colorbar;
borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 
caxis([-0.05 0.05]);
%% 
LTM_SSHgrad = mean(SSH2,3,'omitnan');

pcolor(LON(:,1),latiCUTI(1,:),LTM_SSHgrad');shading flat; colorbar;
borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 
caxis([-0.005 0.005]);
%%
g=9.81;

mld = MLD(:,IA1,:); %
f=coriolisf(latiCUTI);
ugeo=(g.*SSH2)./(f.* distance_Array);

LTM_mld=mean(mld,3,'omitnan');

Ugeo= ugeo.* LTM_mld;
%% 
LTM_UGEO = mean(Ugeo,3,'omitnan');

[Xu,Yu]=meshgrid(LON(:,1), latiCUTI(1,:));

LTM_UGEO2 = interp2(Xu,Yu,LTM_UGEO', LON', LAT', 'linear')'; %
%U = interp2(Xu, Yu, uwind', LON', LAT', 'linear')'; %m/s

%% PLOTTIN UGEO
Humboldt_ports;
grey = [0.5 0.5 0.5];

figure
P=get(gcf,'position');
P(3)=P(3)*1;
P(4)=P(4)*2.4;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

pcolor(LON,LAT,LTM_UGEO2.*mask); shading flat;
hold on
[c,h]=contour(LON,LAT,LTM_UGEO2.*mask,[0:0.5:5],'Color',grey);
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
title('Long-term mean of ocean [1990-2010] UGEO','fontsize',22); 
caxis([-5, 5]);
ticks = -5:0.5:5;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String='m^{2}/s';
c.Label.FontSize = 18;
%caxis([-30 30]);
%% save 
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/CUTI

%save('UGEO.mat','LON','LAT','LTM_UGEO2','Ugeo','latiCUTI');
%% NOW CUTI 
%load('UGEO.mat');
UEK=table2array(struct2table(load('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BakunIndex_Final.mat','UE')));

% [Xu,Yu]=meshgrid(LON(:,1), latiCUTI(1,:));
% 
% for ii=1:1:size(MLD,3)
%     UGEO(:,:,ii) = interp2(Xu,Yu,Ugeo(:,:,1)', LON', LAT', 'linear')'; %
%     disp(ii)
% end

%% sum cuti
LTM_UEK = mean(UEK,3,'omitnan');

LTM_CUTI = LTM_UEK + LTM_UGEO2 ;
% LTM_CUTI = mean(CUTI,3,'omitnan');
% LTM_UE = mean(UEK,3,'omitnan');
%% PLOT UEK

figure
P=get(gcf,'position');
P(3)=P(3)*1.2;
P(4)=P(4)*2.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

pcolor(LON,LAT,LTM_UEK.*mask); shading flat;
hold on
[c,h]=contour(LON,LAT,LTM_UEK.*mask,[0:0.5:5],'k');
caxis([-5 5])
clabel(c,h);
cmocean('delta');
borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 
ax = gca;
ax.FontSize = 18; 
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
title('Long-term mean of ocean (1990-2010) UEK','fontsize',16); 
%% PLOT CUTI
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

[c,h]=contourf(time2,latCUTI,Mean_CUTI,[-10:0.1:10]);colorbar; 
cmocean('balance',41); set(h,'LineColor','none'); clabel(c,h);
title('Monthly CUTI Index 150km offshore','fontsize',22); 
ax = gca;
ax.FontSize = 18;
ylabel('Latitude'); xlabel('Time');
ax = gca;
ax.FontSize = 18; 
caxis([-4 4]);
ticks = -4:0.5:4;
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

[c,h]=contourf(timeclim,latCUTI,climCUTI,[-10:0.1:10]);shading flat; colorbar; 
cmocean('balance',41); clabel(c,h);set(h,'LineColor','none'); 
hold on
[c,h]=contour(timeclim,latCUTI,climCUTI,[-1:0.5:5],'Color',grey);
clabel(c,h);
title('CUTI Index Climatology 150km offshore','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Months');
caxis([-4 4]);
ticks = -4:0.5:4;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String='m^{2}/s';
c.Label.FontSize = 18;