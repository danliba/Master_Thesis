clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,~,path1]=lets_get_started;
mask(mask==0)=NaN;
%%
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BEUTI
CUTI = table2array(struct2table(load('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/CUTI/CUTI_1degree/CUTI_1D.mat','CUTI_1_DEG')));
IA1 = table2array(struct2table(load('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/CUTI/CUTI_1degree/CUTI_1D.mat','IA1')));
load('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BEUTI/Nitrogen.mat');

%% Let's find BEUTI 
Total_N = permute(Total_N,[2,1,3]);

N = Total_N(:,IA1,:);

BEUTI_1_DEG = CUTI.*N;
%% 
LTM_BEUTI = mean(BEUTI_1_DEG,3,'omitnan');
LTM_CUTI = mean(CUTI,3,'omitnan');
Humboldt_ports;
%% -- Plot  1 Degree plots-- %%

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
[c,h]=contourf(LON(:,1),LAT(1,IA1)',LTM_BEUTI',[-100:1:100]);shading flat;
%pcolor(LON(:,1),LAT(1,IA1)',LTM_BEUTI');shading flat;
axis([-90 -70 -20 -5]); cmocean('balance',21); 
colorbar; %borders('countries','facecolor','white');
title('Long-Term Mean BEUTI 1 Degree'); set(h,'LineColor','none');

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
[c,h]=contourf(LON(:,1),LAT(1,IA1)',LTM_CUTI',[-100:1:100]);shading flat;
axis([-90 -70 -20 -5]); cmocean('balance',21); 
colorbar;
title('Long-Term Mean CUTI 1 Degree'); set(h,'LineColor','none');

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
%% 
latis = LAT(1,IA1)'; 
[latis2,lonis2]=meshgrid(latis,loni);

arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

ind1=double(inpolygon(lonis2,latis2,lonb1,latb1));
ind1(ind1==0)=NaN;

latis=latis2(1,:); lonis=lonis2(:,1);
%indxlat=find(latis>=-20 & latis<=-5);

nBEUTI=BEUTI_1_DEG.*ind1;
%%
if flag==1
figure
pcolor(lonis2,latis2,squeeze(nBEUTI(:,:,1)));shading flat; colorbar; 
cmocean('balance',11); 
axis([-84 -70 -20 -5]);

title('BEUTI Index','fontsize',16); 
caxis([-100 100]);
hold on
plot(lonb1,latb1,'k','linewidth',4);
end
%%
time = generate_monthly_time_vector(1990, 2010)';

Mean_BEUTI=permute(mean(nBEUTI,1,'omitnan'),[2 3 1]);

time2=linspace(1990,2010.99,length(time))';
%%
latiCUTI = latis2(1,:); 

if flag==1
figure
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(time2,latiCUTI,Mean_BEUTI,[-500:1:500]);colorbar; 
cmocean('balance',21); set(h,'LineColor','none'); clabel(c,h);
title('Monthly BEUTI 1 degree','fontsize',22); 
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
%%
jj=0;
[yr,mo]=datevec(time');

for imo=1:1:12
    
    indxclim=find(mo==imo);
    
    climBEUTI(:,imo)=mean(Mean_BEUTI(:,indxclim),2,'omitnan');
    
end
%% 
timeclim=1:12;
grey = [0.5 0.5 0.5];

if flag==1
figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*3;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(timeclim,latiCUTI,climBEUTI,[-500:1:500]);shading flat; colorbar; 
cmocean('balance',21); clabel(c,h);set(h,'LineColor','none'); 
hold on
[c,h]=contour(timeclim,latiCUTI,climBEUTI,[-5:1:5],'Color',grey);
clabel(c,h);
title('BEUTI Climatology 1 Degree','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Months');
caxis([-100 100]);
ticks = -100:20:100;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mu mol \cdot m^{-1} \cdot s^{-1}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
end
%%
BEUTI_latitudinal_LR = mean(climBEUTI, 2,'omitnan');
%% plot
if flag==1;
plot(BEUTI_latitudinal_LR,latiCUTI,'bo-','markerfacecolor','b');
ylabel('Latitude','fontsize',14); %xlabel('Transport m^{2}s^{-1}','fontsize',14);
ax = gca;
xlabel('$\mu mol \cdot m^{-1} \cdot s^{-1}$', 'Interpreter', 'latex');
ax.FontSize = 20; grid minor; title('LTM BEUTI');end
%% SAVE

save('BEUTI_1D','time2','latiCUTI','Mean_BEUTI','BEUTI_latitudinal_LR','IA1','BEUTI_1_DEG');
