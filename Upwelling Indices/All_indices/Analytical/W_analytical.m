%% --- Analytical vertical velocity Index --- %
clear all; close all; clc;
[mask,LON,LAT,f,path1]=lets_get_started;

cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/w_analytical;

load('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Wc_mean_wstrss.mat'); %Wc
load('Ekman_We_wind.mat');%WSCD
load('EKMAN_pump_April.mat')
%load('/Users/dlizarbe/Documents/DANIEL/depths/MLD_W_1990_2010.mat'); % CROCO

Humboldt_ports;

%W_MLD=mean(Wmld,3,'omitnan');

%W_analytical = Mean_We + Wc_mean; %m/s
W_analytical = LTM_ekpump + Wc_mean;
%W_a = WcMean + Ekman_We;
W_a = WcMean + EK_pump;

W_amean=nanmean(W_a,3);
%% ----- Plot ---- %% 

[~,ylab] = generateYLabels(20,5,5);
[~,xlab] = generateXLabels(90,70,5);

figure
P=get(gcf,'position');
P(3)=P(3)*1;
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(LON,LAT,W_amean.*mask.*86400,[-10:0.1:10]); 
axis([-90 -70 -20 -5]); caxis([-3 3]);cmocean('balance',13); colorbar;
title('LTM Analytical Velocity'); set(h,'LineColor','none');
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
%% --- Cut cut cut ----- %%

arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
%arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/SST/BK111km.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

ind1=double(inpolygon(LON,LAT,lonb1,latb1));
ind1(ind1==0)=NaN;

W_analytical = W_a .*ind1.*mask;

flag==0;
if flag==1
pcolor(W_analytical(:,:,1)'.*86400); shading flat;
caxis([-2 2]); cmocean('balance');
end

%% ------ monthly ----- %%
indxlat = find(LAT(1,:)<=-5 & LAT(1,:)>=-20)';
lati=LAT(1,indxlat)';
time=linspace(1990,2010,size(W_analytical,3))';

Monthly_wa=permute(mean(W_analytical(:,indxlat,:),1,'omitnan'),[2 3 1]);

Wa_ts = mean(Monthly_wa,1,'omitnan');

if flag==1
subplot(2,1,1)
pcolor(time,lati,Monthly_wa.*86400); shading flat;
title('Monthly Analytical velocity'); colorbar;
caxis([-4 4]); cmocean('balance',17);

subplot(2,1,2)
plot(time,Wa_ts);
end
%% ------- Climatology -------- %% 
time = generate_monthly_time_vector(1990, 2010)';

jj=0;
[yr,mo]=datevec(time);

for imo=1:1:12
    
    indxclim=find(mo==imo);
    climWa(:,imo)=mean(Monthly_wa(:,indxclim),2,'omitnan');

end

%% ---- plot Clim ---- %% 
timeclim=1:12;
[~,ylab] = generateYLabels(20,5,5);
xlab={'J','F','M','A','M','J','J','A','S','O','N','D'};


figure
P=get(gcf,'position');
P(3)=P(3)*1;
P(4)=P(4)*1.2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(timeclim,lati,climWa.*86400,[-10:0.1:10]); colorbar; 
cmocean('balance',17); clabel(c,h);set(h,'LineColor','none'); 
hold on
% [c,h]=contour(timeclim,latCUTI,climBEUTI,[-100:20:100],'Color',grey);
% clabel(c,h);
title('Analytical Velocity Climatology','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Months');
caxis([-4 4]);
ticks = -4:1:4;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
%% 
save('W_analytical.mat','climWa','time','Wa_ts','Monthly_wa','lati');






