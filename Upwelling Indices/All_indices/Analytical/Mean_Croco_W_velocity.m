clear all; close all; clc;
%% ---- plot of the Study Regio ----- %%
[mask,LON,LAT,f,path1]=lets_get_started;
mask(mask==0)=NaN;
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/w_analytical

load('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/w_analytical/MLD_W_1990_2010.mat'); % CROCO
%% 
WMLD = permute(Wmld,[2 1 3]);
% [WMLD_ts2,WMLD_anom, ~,~] = calculateUpwellingAnomalies(LON, LAT, WMLD, mask);
% save('WMLD_anom.mat','WMLD_ts2','WMLD_anom');

%% 
LTM_wmld = mean(WMLD,3,'omitnan');
Humboldt_ports;

ylab = {'30S','25S','20S','15S','10S','5S','0','5N','10N'};
[~,xlab] = generateXLabels(90,70,5);

if flag==1
    figure
    P=get(gcf,'position');
    P(3)=P(3)*1;
    P(4)=P(4)*2;
    set(gcf,'position',P);
    set(gcf,'PaperPositionMode','auto');
    
    [c,h]=contourf(LON,LAT,LTM_wmld.*mask.*86400,[-10:0.1:10]);
    axis([-90 -70 -30 10]); caxis([-2 2]);cmocean('balance',9); colorbar;
    title('LTM W at MLD [CROCO]'); set(h,'LineColor','none');
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
    ticks = -2:0.5:2;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
    set(gca,'ytick',[-30:5:10],'yticklabel',ylab,'ylim',[-30 10]);
    set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);
end
%% 

arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
%arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/SST/BK111km.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

%%
[~,ylab] = generateYLabels(20,5,5);
[~,xlab] = generateXLabels(90,70,5);

if flag==1
    figure
    P=get(gcf,'position');
    P(3)=P(3)*1;
    P(4)=P(4)*1;
    set(gcf,'position',P);
    set(gcf,'PaperPositionMode','auto');
    
    [c,h]=contourf(LON,LAT,LTM_wmld.*mask.*86400,[-10:0.1:10]);
    axis([-90 -70 -20 -5]); caxis([-2 2]);cmocean('balance',9); colorbar;
    title('Study Region'); set(h,'LineColor','none');
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
end
%% cut cut cut %% 
ind1=double(inpolygon(LON,LAT,lonb1,latb1));
ind1(ind1==0)=NaN;

cWMLD = WMLD.*ind1.*mask;

indxlat = find(LAT(1,:)<=-5 & LAT(1,:)>=-20)';
lati=LAT(1,indxlat)';

nWMLD=permute(mean(cWMLD (:,indxlat,:),1,'omitnan'),[2 3 1]);

time = generate_monthly_time_vector(1990, 2010)';

jj=0;
[yr,mo]=datevec(time);

for imo=1:1:12
    
    indxclim=find(mo==imo);
    climWMLD(:,imo)=mean(nWMLD(:,indxclim),2,'omitnan');
end
%% 
timeclim=1:12;
ylab={'20S','15S','10S','5S'};
xlab={'J','F','M','A','M','J','J','A','S','O','N','D'};

if flag==1
    figure
    P=get(gcf,'position');
    P(3)=P(3)*1;
    P(4)=P(4)*1.5;
    set(gcf,'position',P);
    set(gcf,'PaperPositionMode','auto');
    
    [c,h]=contourf(timeclim,lati,climWMLD.*86400,[-3:0.1:3]);colorbar;
    cmocean('balance',17); clabel(c,h);set(h,'LineColor','none');
    title('W CROCO Climatology','fontsize',22);
    clabel(c,h);
    ax = gca;
    ax.FontSize = 20;
    ylabel('Latitude'); xlabel('Months');
    caxis([-2 2]);
    ticks = -2:0.5:2;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
    set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
    set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
    
end
%% save

WMLD_ts = mean(nWMLD,1,'omitnan')';
WMLD_lat = mean(climWMLD,2,'omitnan');

%plot(WMLD_lat,lati);
save('WMLD_lat.mat','WMLD_lat','lati');





