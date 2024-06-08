clear all; close all; clc;
load('BakunIndex_Final.mat')
Humboldt_ports;
LTM_BUI = mean(BUI,3,'omitnan');
%% 

[~,ylab] = generateYLabels(20,5,5);
[~,xlab] = generateXLabels(90,70,5);

figure
P=get(gcf,'position');
P(3)=P(3)*1;
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(LON,LAT,LTM_BUI.*mask,[-10:0.1:10]);colorbar; 
cmocean('balance',17); colorbar;
title('Bakun Index'); set(h,'LineColor','none');
hold on
for i = 1:5
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end

ax = gca;
ax.FontSize = 20; caxis([-2 2]);
ylabel('Latitude'); xlabel('Longitude');
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = 'm$^{2}$/s';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);

savefig('BUI_LTM.fig');
%%
arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

ind1=double(inpolygon(LON,LAT,lonb1,latb1));
ind1(ind1==0)=NaN;

lati=LAT(1,:); loni=LON(:,1);
indxlat=find(lati>=-20 & lati<=-5);

nBUI=BUI.*ind1.*mask;
cBUI=nBUI(:,indxlat,:);

time=time';
Mean_Bakun=permute(mean(cBUI,1,'omitnan'),[2 3 1]);

time2=linspace(1990,2010.99,length(time))';
latBakun=lati(indxlat);

Bakun_ts = mean(Mean_Bakun,1,'omitnan');
%% --- climatology ---- %% 

jj=0;
[yr,mo]=datevec(time');

for imo=1:1:12
    
    indxclim=find(mo==imo);
    
    climBUI(:,imo)=mean(Mean_Bakun(:,indxclim),2,'omitnan');
    
end

%% ---- plot climatology ---- %%
timeclim=1:12;
[~,ylab] = generateYLabels(20,5,5);
xlab={'J','F','M','A','M','J','J','A','S','O','N','D'};


figure
P=get(gcf,'position');
P(3)=P(3)*1;
P(4)=P(4)*1.2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');


[c,h]=contourf(timeclim,latBakun,climBUI,[-10:0.1:10]);shading flat; colorbar; 
cmocean('balance',13); clabel(c,h);set(h,'LineColor','none'); 
title('Bakun Index','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Months');
caxis([-3 3]);
ticks = -3:1:3;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = 'm$^{2}$/s';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
%% save
save('BUI.mat','climBUI','time','Bakun_ts','Mean_Bakun','latBakun');
