%% CUI SST offshore - inshore.
clear all; close all; clc;
[mask,LON,LAT,~,path1]=lets_get_started;
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/SST;

load('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/SST/SST.mat');
%% Lets get the inshore at 150km
arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
%arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/SST/BK111km.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

ind1=double(inpolygon(LON,LAT,lonb1,latb1));
ind1(ind1==0)=NaN;

SST_inshore = SSTi.*ind1.*mask;

%% plot
flag==0;
if flag==1
for ii=1:1:size(SSTi,3)
    pcolor(LON,LAT,squeeze(SST_inshore(:,:,ii)).*mask); shading flat;
    title(num2str(ii));
    pause(0.5)
    clf
end
end
%% Let's get the offshore at 500– 600 km 
%600km
arch_kml_zona3='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/SST/BK600km.kml';
R3=kml2struct(arch_kml_zona3); lonb3=R3.Lon; latb3=R3.Lat;

%500km
arch_kml_zona2='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/SST/BK500km.kml';
R2=kml2struct(arch_kml_zona2); lonb2=R2.Lon; latb2=R2.Lat;

ind3=double(inpolygon(LON,LAT,lonb3,latb3));
ind3(ind3==0)=NaN;

ind2=double(inpolygon(LON,LAT,lonb2,latb2));
ind2(ind2==1)=NaN;

offshore_mask = ind3.*ind2.*mask; offshore_mask(offshore_mask==0)=1;

SST_offshore_600km = SSTi.*offshore_mask;
%SST_offshore_500km = SSTi.*ind2;
%% 
pcolor(LON,LAT,SST_offshore_600km(:,:,1)); shading flat;
hold on
plot(lonb1,latb1);
hold on
plot(lonb2,latb2);
colorbar; cmocean('thermal');
axis([-90 -70 -20 -5]);
%% 
% pcolor(LON,LAT,ind3.*mask); shading flat;
% hold on
% plot(lonb3,latb3);
% hold on
% plot(lonb2,latb2);
%% Now the LTM
LTM_SST_offshore = mean(SST_offshore_600km,3,'omitnan');
LTM_SST_inshore = mean(SST_inshore,3,'omitnan');
Humboldt_ports;
%% 
[~,ylab] = generateYLabels(20,5,5);
[~,xlab] = generateXLabels(90,70,5);
flag==0;
if flag==1
figure 
P=get(gcf,'position');
P(3)=P(3)*1;
P(4)=P(4)*1.2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(LON,LAT,LTM_SST_offshore,[10:0.1:30]); shading flat;
axis([-90 -70 -20 -5]);set(h,'LineColor','none');
hold on
pcolor(LON,LAT,LTM_SST_inshore.*mask); shading flat;
hold on
hold on
for i = 1:length(Puertos)
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 20); % Plot text
end

ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
colorbar; cmocean('thermal',11);
caxis([16 26])
title('LTM Offshore and Inshore SST');
ticks = 16:2:26;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$^\circ C$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);
end
%% 
% pcolor(LON,LAT,SST_inshore(:,:,1).*mask); shading flat;
% caxis([16 26]); colorbar;
% axis([-90 -70 -20 -5]);
% %% 
% SST_mean = mean(SST_inshore(:,:,1),1,'omitnan')';

%% compute CUI
indxlat = find(LAT(1,:)<=-5 & LAT(1,:)>=-20)';
lati=LAT(1,indxlat)';

SST_offshore_lat=permute(mean(SST_offshore_600km(:,indxlat,:),1,'omitnan'),[2 3 1]);
SST_inshore_lat = permute(mean(SST_inshore(:,indxlat,:),1,'omitnan'),[2 3 1]);

CUI_SSTi =  abs(SST_inshore_lat -SST_offshore_lat) ;
%% 
time=linspace(1990,2010.99,size(SSTi,3))';
if flag==1
subplot(3,1,1)
pcolor(time,lati,SST_offshore_lat); shading flat;
title('SST offshore'); colorbar;

subplot(3,1,2)
pcolor(time,lati,SST_inshore_lat); shading flat;
title('SST inshore'); colorbar;

subplot(3,1,3)
pcolor(time,lati,CUI_SSTi); shading flat;
title('CUI SST'); colorbar;
end
%% monthly
ylab={'20S','15S','10S','5S'};

figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(time,lati,CUI_SSTi,[-70:0.1:70]);colorbar; 
cmocean('balance',21); set(h,'LineColor','none'); clabel(c,h);
title('Monthly CUI','fontsize',22); 
ax = gca;
ax.FontSize = 24;
ylabel('Latitude'); xlabel('Time');
ax = gca;
ax.FontSize = 24; 
caxis([-10 10]);
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$^\circ C$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 24;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);

%% climatology
time = generate_monthly_time_vector(1990, 2010)';

jj=0;
[yr,mo]=datevec(time);

for imo=1:1:12
    
    indxclim=find(mo==imo);
    
    climCUI(:,imo)=mean(CUI_SSTi(:,indxclim),2,'omitnan');
    climSST_offshore(:,imo)=mean(SST_offshore_lat(:,indxclim),2,'omitnan');
    climSST_inshore(:,imo)=mean(SST_inshore_lat(:,indxclim),2,'omitnan');
%SST_inshore_lat
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
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(1,2,1)
[c,h]=contourf(timeclim,lati,climSST_offshore,[-100:0.1:100]);shading flat; colorbar; 
cmocean('thermal',11); clabel(c,h);set(h,'LineColor','none'); 
hold on
% [c,h]=contour(timeclim,latCUTI,climBEUTI,[-100:20:100],'Color',grey);
% clabel(c,h);
title('SST offshore Climatology','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Months');
caxis([16 26])
ticks = 16:2:26;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$^\circ C$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);

subplot(1,2,2)
[c,h]=contourf(timeclim,lati,climSST_inshore,[-100:0.1:100]);shading flat; colorbar; 
cmocean('thermal',11); clabel(c,h);set(h,'LineColor','none'); 
hold on
% [c,h]=contour(timeclim,latCUTI,climBEUTI,[-100:20:100],'Color',grey);
% clabel(c,h);
title('SST inshore Climatology','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Months');
caxis([16 26])
ticks = 16:2:26;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$^\circ C$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
end
%% Climatology CUI 
if flag ==1 
figure
P=get(gcf,'position');
P(3)=P(3)*1;
P(4)=P(4)*1.2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(timeclim,lati,climCUI,[-15:0.1:15]);shading flat; colorbar; 
cmocean('balance',21); clabel(c,h);set(h,'LineColor','none'); 
hold on
% [c,h]=contour(timeclim,latCUTI,climBEUTI,[-100:20:100],'Color',grey);
% clabel(c,h);
title('CUI SST Climatology','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Months');
caxis([-10 10]);
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$^\circ C$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
end
%% 
Mean_CUI = mean(CUI_SSTi,1,'omitnan');
plot(time,Mean_CUI');
%%
%save('CUI_SST_index.mat','time','lati','CUI_SSTi','SST_inshore_lat','SST_offshore_lat','Mean_CUI');


