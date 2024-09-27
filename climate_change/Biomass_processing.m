%% calculate phyto, chloro and zoo

cd /Volumes/BM_2019_01/For_Daniel/biomass
% yr=1990:2010;
% mo=1:12;
%
% jj=0;
% for iy=yr(1):1:yr(end)
%
%     for imo=mo(1):1:mo(end)
%
%         fn=sprintf('/Volumes/BM_2019_01/For_Daniel/biomass/Biomass_Y%dM%d.mat',iy,imo);
%         load(fn)
%         disp(fn)
%         jj=jj+1;
%         phyto(:,:,jj) = lphyto_mld + sphyto_mld;
%         zoo(:,:,jj) = lzoo_mld + szoo_mld;
%         chlor(:,:,jj)=chla;
%     end
% end
% %%
% zoo = permute(zoo,[2 1 3]);
% phyto = permute(phyto,[2 1 3]);

%save('BIOMASS.mat','chlor','phyto','zoo');
%%
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
cd /Volumes/BM_2019_01/For_Daniel/biomass
Humboldt_ports;
load('Biomass_surface_GOOD.mat');

zoo = permute(Szoo,[2 1 3]); phyto = permute(Sphyto,[2 1 3]);
chlor = permute(Schla,[2 1 3]);
%%
LTM_chlor = mean(Schla,3,'omitnan')';
LTM_zoo = mean(Szoo,3,'omitnan')';
LTM_phyto = mean(Sphyto,3,'omitnan')';
%% ---------------------- Plot LTM ---------------------------- %%
[~,ylab] = generateYLabels(20,5,5);
[~,xlab] = generateXLabels(90,70,5);

flag =0;
if flag==1
    figure
    P=get(gcf,'position');
    P(3)=P(3)*2;
    P(4)=P(4)*2;
    set(gcf,'position',P);
    set(gcf,'PaperPositionMode','auto');
    %----- Chlorophyll -----%
    subplot(2,2,1)
    [c,h]=contourf(LON,LAT,LTM_chlor,[-10:0.1:10]);
    axis([-90 -70 -20 -5]); caxis([0 10]);colormap(slanCM('Viridis',21)) ; colorbar;
    title('LTM Chla'); set(h,'LineColor','none');
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
    ticks = 0:1:10;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = '$\mathrm{mg \cdot m^{-3}}$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
    set(gca,'ytick',[-30:5:10],'yticklabel',ylab);
    set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);

    %------- Phyto --------%
    subplot(2,2,2)
    [c,h]=contourf(LON,LAT,LTM_phyto.*mask,[-10:0.1:10]);
    axis([-90 -70 -20 -5]); caxis([0 5]);colormap(slanCM('Viridis',11)) ; colorbar;
    title('LTM Phytoplankton'); set(h,'LineColor','none');
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
    ticks = 0:1:5;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = '$\mathrm{mmol \cdot N \cdot m^{-3}}$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
    set(gca,'ytick',[-30:5:10],'yticklabel',ylab);
    set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);

    %--------- zoo plankton ------------ %
    subplot(2,2,3)
    [c,h]=contourf(LON,LAT,LTM_zoo.*mask,[-10:0.1:10]);
    axis([-90 -70 -20 -5]);caxis([0 5]);colormap(slanCM('Viridis',11)) ; colorbar;
    title('LTM Zooplankton'); set(h,'LineColor','none');
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
    ticks = 0:1:5;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = '$\mathrm{mmol \cdot N \cdot m^{-3}}$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
    set(gca,'ytick',[-30:5:10],'yticklabel',ylab);
    set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);
end
%% ------------- Load ENSO by DANTE ----------------- %%
load('ENSO_DANTE_dates.mat');
timeNINO2(16)=[]; indxNINO2(16)=[];
fsize=20;
[~,ylab] = generateYLabels(20,4,2);

grey = [0.5 0.5 0.5];
brown = [165, 42, 42] ./ 255;
dark_green = [0, 100, 0] ./ 255;
blue_green = [0, 128, 128] ./ 255;
%% --------- Anom and Clim --------------------------------%%

time = generate_monthly_time_vector(1990, 2010)';
[climZoo, anomZoo] = calculateClimatologyAndAnomalies(zoo, time);
[~, anomPhyto] = calculateClimatologyAndAnomalies(phyto, time);
[~, anomChl] = calculateClimatologyAndAnomalies(chlor, time);

%% -------------------- TS -------------------------------- %%
nzoo = calculate_URegion(zoo, LON, LAT, mask);
nzoo2 = calculate_URegion(anomZoo, LON, LAT, mask); % ANOM

nphyto = calculate_URegion(phyto, LON, LAT, mask);
nphyto2 = calculate_URegion(anomPhyto, LON, LAT, mask);

[nchla,lati] = calculate_URegion(chlor, LON, LAT, mask);
nchla2 = calculate_URegion(anomChl, LON, LAT, mask);


zoo_ts = mean(nzoo,1,'omitnan')';
zoo_ts_a = mean(nzoo2,1,'omitnan')';

phyto_ts = mean(nphyto,1,'omitnan')';
phyto_ts_a = mean(nphyto2,1,'omitnan')';

chla_ts = mean(nchla,1,'omitnan')';
chla_ts_a = mean(nchla2,1,'omitnan')';

time = generate_monthly_time_vector(1990, 2010)';
%% save to export 
T = array2table(cat(2, time,chla_ts_a,chla_ts));
filename = 'chlor_surf.xlsx';
writetable(T,filename,'Sheet',1);
%% ---- plot TS with ENSO ---
trp = 0.3;
arr= ones(length(timeNINO2), 1); arr2=ones(length(timeNINA2),1);
arr(arr==1)=1000; arr2(arr2==1)=1000;
%bar(indxveda,arr)
%bar(timeNINO2,arr, 'FaceColor', [0.9 0.9 0.9], 'EdgeColor', 'none');

figure
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*3;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(3,1,1)
bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
plot(time,zoo_ts,'Color',brown,'linewidth',2,'linestyle','-');
datetick('x'); ylim([0 5]);
title('Zooplankton');
ax = gca;
ax.FontSize = fsize;
grid on
ylabel('$\mathrm{mmol \cdot N \cdot m^{-3}}$','interpreter','latex');

subplot(3,1,3)
bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
plot(time,phyto_ts,'Color',blue_green,'linewidth',2,'linestyle','-');
datetick('x'); ylim([0 8]);
title('Phytoplankton');
ax = gca;
ax.FontSize = fsize;
grid on
ylabel('$\mathrm{mmol \cdot N \cdot m^{-3}}$','interpreter','latex');

subplot(3,1,2)
bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
hold on
plot(time,chla_ts,'Color',dark_green,'linewidth',2,'linestyle','-');
datetick('x'); ylim([0 20]);
title('Chlorophyll');
ax = gca;
ax.FontSize = fsize;
grid on
ylabel('$\mathrm{mg \cdot m^{-3}}$','interpreter','latex');

%% ---------------------- Anom TS --------------------------- %%
trp = 0.3;
wz = 13;
arr= ones(length(timeNINO2), 1); arr2=ones(length(timeNINA2),1);
arr(arr==1)=1000; arr2(arr2==1)=1000;
arr3(arr==1000)=-1000; arr4(arr2==1000)=-1000;
%bar(indxveda,arr)
%bar(timeNINO2,arr, 'FaceColor', [0.9 0.9 0.9], 'EdgeColor', 'none');

figure
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*3;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(3,1,1); hold on
bar(timeNINO2,arr3, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINA2,arr4, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
plot(time,zoo_ts_a,'Color',brown,'linewidth',1.5,'linestyle',':');
plot(time,movmean(zoo_ts_a,wz),'Color',brown,'linewidth',2,'linestyle','-');
datetick('x'); ylim([-1 1]);
title('Zooplankton'); box on;
ax = gca;
ax.FontSize = fsize;
grid on
ylabel('$\mathrm{mmol \cdot N \cdot m^{-3}}$','interpreter','latex');

subplot(3,1,3); hold on
bar(timeNINO2,arr3, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINA2,arr4, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
plot(time,phyto_ts_a,'Color',blue_green,'linewidth',1.5,'linestyle',':');
plot(time,movmean(phyto_ts_a,wz),'Color',blue_green,'linewidth',2,'linestyle','-');

datetick('x'); ylim([-2 2]); box on;
title('Phytoplankton');
ax = gca;
ax.FontSize = fsize;
grid on
ylabel('$\mathrm{mmol \cdot N \cdot m^{-3}}$','interpreter','latex');

subplot(3,1,2); hold on
bar(timeNINO2,arr3, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINA2,arr4, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp);
bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp);
plot(time,chla_ts_a,'Color',dark_green,'linewidth',1.5,'linestyle',':');
plot(time,movmean(chla_ts_a,wz),'Color',dark_green,'linewidth',2,'linestyle','-');
datetick('x'); ylim([-6 6]);
title('Chlorophyll'); box on;
ax = gca;
ax.FontSize = fsize;
grid on
ylabel('$\mathrm{mg \cdot m^{-3}}$','interpreter','latex');


%% -------------------- Latitudinal ------------------------- %%
up_center = [5, 7.5, 10, 11, 14, 15]*-1;
arr= ones(length(up_center), 1); arr(arr==1)=20;


zoo_lat = mean(nzoo,2,'omitnan');
phyto_lat = mean(nphyto,2,'omitnan');
chla_lat = mean(nchla,2,'omitnan');


%------ plot --------%
figure
P=get(gcf,'position');
P(3)=P(3)*1.9;
P(4)=P(4)*1.9;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

fsize=20;
[~,ylab] = generateYLabels(20,4,2);

grey = [0.5 0.5 0.5];
brown = [165, 42, 42] ./ 255;
dark_green = [0, 100, 0] ./ 255;
blue_green = [0, 128, 128] ./ 255;

% subplot(2,4,1)
% plot(WMLD_lat*86400,lati,'k:','linewidth',1.5);
% hold on
% plot(rmWMLD*86400,lati,'k-','linewidth',2);
% title('Model Upward Velocity');
% ax = gca;
% ax.FontSize = fsize;
% grid on
% set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
% xlabel('m day^{-1}');

subplot(1,3,1); hold on
barh(up_center',arr, 'FaceColor', [0.5, 0.5, 0.5], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1);
plot(zoo_lat,lati,'Color',brown,'linewidth',1.5,'linestyle',':');
plot(movmean(zoo_lat,13),lati,'Color',brown,'linewidth',2,'linestyle','-');
title('Zooplankton'); xlim([1.5 3.5]);
ax = gca;
ax.FontSize = fsize;
grid on
set(gca,'ytick',[-20:2:-4],'yticklabel',ylab,'ylim',[-20 -5]);
xlabel('$\mathrm{mmol \cdot N \cdot m^{-3}}$','interpreter','latex');


subplot(1,3,2); hold on;
barh(up_center',arr, 'FaceColor', [0.5, 0.5, 0.5], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1);
plot(phyto_lat,lati,'Color',blue_green,'linewidth',1.5,'linestyle',':');
plot(movmean(phyto_lat,13),lati,'Color',blue_green,'linewidth',2,'linestyle','-');
title('Phytoplankton');xlim([1.5 6]);
ax = gca;
ax.FontSize = fsize;
grid on
set(gca,'ytick',[-20:2:-4],'yticklabel',ylab,'ylim',[-20 -5]);
xlabel('$\mathrm{mmol \cdot N \cdot m^{-3}}$','interpreter','latex');

subplot(1,3,3); hold on
barh(up_center',arr, 'FaceColor', [0.5, 0.5, 0.5], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1);
plot(chla_lat,lati,'Color',dark_green,'linewidth',1.5,'linestyle',':');
plot(movmean(chla_lat,13),lati,'Color',dark_green,'linewidth',2,'linestyle','-');
title('Chlorophyll');xlim([4 15]);
ax = gca;
ax.FontSize = fsize;
grid on
set(gca,'ytick',[-20:2:-4],'yticklabel',ylab,'ylim',[-20 -5]);
xlabel('$\mathrm{mg \cdot m^{-3}}$','interpreter','latex');


%% --------------- ENSO Latitudinal Effect ---------------- %%
% ----- ZOO ---- %
zoo_latNINO = mean(nzoo(:,indxNINO2),2,'omitnan');
zoo_latNINA = mean(nzoo(:,indxNINA2),2,'omitnan');
zoo_latNEUTRO = mean(nzoo(:,indxNEUTRO2),2,'omitnan');

% ----- PHYTO ---- %
phyto_latNINO = mean(nphyto(:,indxNINO2),2,'omitnan');
phyto_latNINA = mean(nphyto(:,indxNINA2),2,'omitnan');
phyto_latNEUTRO = mean(nphyto(:,indxNEUTRO2),2,'omitnan');

% ----- CHLA ------ %
chla_latNINO = mean(nchla(:,indxNINO2),2,'omitnan');
chla_latNINA = mean(nchla(:,indxNINA2),2,'omitnan');
chla_latNEUTRO = mean(nchla(:,indxNEUTRO2),2,'omitnan');

%---Plots ENSO latitudinal
figure
P=get(gcf,'position');
P(3)=P(3)*1.9;
P(4)=P(4)*1.9;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');


subplot(1,3,1); hold on
barh(up_center',arr, 'FaceColor', [0.5, 0.5, 0.5], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1);
plot(zoo_latNINO,lati,'Color',grey,'linewidth',0.5,'linestyle','-');
a=plot(movmean(zoo_latNINO,13),lati,'Color',brown,'linewidth',2,'linestyle','-');
plot(zoo_latNINA,lati,'Color',grey,'linewidth',0.5,'linestyle','--');
b=plot(movmean(zoo_latNINA,13),lati,'Color',brown,'linewidth',2,'linestyle','--');
plot(zoo_latNEUTRO,lati,'Color',grey,'linewidth',1,'linestyle',':');
c=plot(movmean(zoo_latNEUTRO,13),lati,'Color','k','linewidth',3,'linestyle','-');

title('Zooplankton'); xlim([1 3.5]);
ax = gca;
ax.FontSize = fsize;
grid on
set(gca,'ytick',[-20:2:-4],'yticklabel',ylab,'ylim',[-20 -5]);
xlabel('$\mathrm{mmol \cdot N \cdot m^{-3}}$','interpreter','latex');
legend([a,b,c],{'Nino','Nina','Neutro'}); box on;

subplot(1,3,2); hold on;
barh(up_center',arr, 'FaceColor', [0.5, 0.5, 0.5], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1);
plot(phyto_latNINO,lati,'Color',grey,'linewidth',0.5,'linestyle','-');
a=plot(movmean(phyto_latNINO,13),lati,'Color',blue_green,'linewidth',2,'linestyle','-');
plot(phyto_latNINA,lati,'Color',grey,'linewidth',0.5,'linestyle','--');
b=plot(movmean(phyto_latNINA,13),lati,'Color',blue_green,'linewidth',2,'linestyle','--');
plot(phyto_latNEUTRO,lati,'Color',grey,'linewidth',1,'linestyle',':');
c=plot(movmean(phyto_latNEUTRO,13),lati,'Color','k','linewidth',3,'linestyle','-');
title('Phytoplankton');xlim([1 7]);
ax = gca; box on;
ax.FontSize = fsize;
grid on
set(gca,'ytick',[-20:2:-4],'yticklabel',ylab,'ylim',[-20 -5]);
xlabel('$\mathrm{mmol \cdot N \cdot m^{-3}}$','interpreter','latex');
legend([a,b,c],{'Nino','Nina','Neutro'}); box on;

subplot(1,3,3); hold on
barh(up_center',arr, 'FaceColor', [0.5, 0.5, 0.5], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1);
plot(chla_latNINO,lati,'Color',grey,'linewidth',0.5,'linestyle','-');
a=plot(movmean(chla_latNINO,13),lati,'Color',dark_green,'linewidth',2,'linestyle','-');
plot(chla_latNINA,lati,'Color',grey,'linewidth',0.5,'linestyle','--');
b=plot(movmean(chla_latNINA,13),lati,'Color',dark_green,'linewidth',2,'linestyle','--');
plot(chla_latNEUTRO,lati,'Color',grey,'linewidth',0.5,'linestyle',':');
c=plot(movmean(chla_latNEUTRO,13),lati,'Color','k','linewidth',2.5,'linestyle','-');
title('Chlorophyll');xlim([3.8 17]);
ax = gca;
ax.FontSize = fsize;
grid on
set(gca,'ytick',[-20:2:-4],'yticklabel',ylab,'ylim',[-20 -5]);
xlabel('$\mathrm{mg \cdot m^{-3}}$','interpreter','latex');
legend([a,b,c],{'Nino','Nina','Neutro'}); box on;

%% --------------- ANOM ENSO Latitudinal Effect ---------------- %%
arr= ones(length(up_center), 1); arr(arr==1)=20;
arr2 = ones(length(up_center), 1); arr2(arr2==1)=-20;
% ----- ZOO ---- %
zoo_latNINO = mean(nzoo2(:,indxNINO2),2,'omitnan');
zoo_latNINA = mean(nzoo2(:,indxNINA2),2,'omitnan');
zoo_latNEUTRO = mean(nzoo2(:,indxNEUTRO2),2,'omitnan');

% ----- PHYTO ---- %
phyto_latNINO = mean(nphyto2(:,indxNINO2),2,'omitnan');
phyto_latNINA = mean(nphyto2(:,indxNINA2),2,'omitnan');
phyto_latNEUTRO = mean(nphyto2(:,indxNEUTRO2),2,'omitnan');

% ----- CHLA ------ %
chla_latNINO = mean(nchla2(:,indxNINO2),2,'omitnan');
chla_latNINA = mean(nchla2(:,indxNINA2),2,'omitnan');
chla_latNEUTRO = mean(nchla2(:,indxNEUTRO2),2,'omitnan');


%---Plots ENSO latitudinal
figure
P=get(gcf,'position');
P(3)=P(3)*1.9;
P(4)=P(4)*1.9;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');


subplot(1,3,1); hold on
barh(up_center',arr, 'FaceColor', [0.5, 0.5, 0.5], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1);
barh(up_center',arr2, 'FaceColor', [0.5, 0.5, 0.5], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1);
plot(zoo_latNINO,lati,'Color',grey,'linewidth',0.5,'linestyle','-');
a=plot(movmean(zoo_latNINO,13),lati,'Color',brown,'linewidth',2,'linestyle','-');
plot(zoo_latNINA,lati,'Color',grey,'linewidth',0.5,'linestyle','--');
b=plot(movmean(zoo_latNINA,13),lati,'Color',brown,'linewidth',2,'linestyle','--');
plot(zoo_latNEUTRO,lati,'Color',grey,'linewidth',1,'linestyle',':');
c=plot(movmean(zoo_latNEUTRO,13),lati,'Color','k','linewidth',3,'linestyle','-');

title('Zooplankton'); xlim([-0.4 0.2]);
ax = gca;
ax.FontSize = fsize;
grid on
set(gca,'ytick',[-20:2:-4],'yticklabel',ylab,'ylim',[-20 -5]);
xlabel('$\mathrm{mmol \cdot N \cdot m^{-3}}$','interpreter','latex');
legend([a,b,c],{'Nino','Nina','Neutro'}); box on;

subplot(1,3,2); hold on;
barh(up_center',arr, 'FaceColor', [0.5, 0.5, 0.5], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1);
barh(up_center',arr2, 'FaceColor', [0.5, 0.5, 0.5], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1);
plot(phyto_latNINO,lati,'Color',grey,'linewidth',0.5,'linestyle','-');
a=plot(movmean(phyto_latNINO,13),lati,'Color',blue_green,'linewidth',2,'linestyle','-');
plot(phyto_latNINA,lati,'Color',grey,'linewidth',0.5,'linestyle','--');
b=plot(movmean(phyto_latNINA,13),lati,'Color',blue_green,'linewidth',2,'linestyle','--');
plot(phyto_latNEUTRO,lati,'Color',grey,'linewidth',1,'linestyle',':');
c=plot(movmean(phyto_latNEUTRO,13),lati,'Color','k','linewidth',3,'linestyle','-');
title('Phytoplankton');xlim([-2 1]);
ax = gca; box on;
ax.FontSize = fsize;
grid on
set(gca,'ytick',[-20:2:-4],'yticklabel',ylab,'ylim',[-20 -5]);
xlabel('$\mathrm{mmol \cdot N \cdot m^{-3}}$','interpreter','latex');
legend([a,b,c],{'Nino','Nina','Neutro'}); box on;

subplot(1,3,3); hold on
barh(up_center',arr, 'FaceColor', [0.5, 0.5, 0.5], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1);
barh(up_center',arr2, 'FaceColor', [0.5, 0.5, 0.5], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1);
plot(chla_latNINO,lati,'Color',grey,'linewidth',0.5,'linestyle','-');
a=plot(movmean(chla_latNINO,13),lati,'Color',dark_green,'linewidth',2,'linestyle','-');
plot(chla_latNINA,lati,'Color',grey,'linewidth',0.5,'linestyle','--');
b=plot(movmean(chla_latNINA,13),lati,'Color',dark_green,'linewidth',2,'linestyle','--');
plot(chla_latNEUTRO,lati,'Color',grey,'linewidth',0.5,'linestyle',':');
c=plot(movmean(chla_latNEUTRO,13),lati,'Color','k','linewidth',2.5,'linestyle','-');
title('Chlorophyll');xlim([-4.5 2.1]);
ax = gca;
ax.FontSize = fsize;
grid on
set(gca,'ytick',[-20:2:-4],'yticklabel',ylab,'ylim',[-20 -5]);
xlabel('$\mathrm{mg \cdot m^{-3}}$','interpreter','latex');
legend([a,b,c],{'Nino','Nina','Neutro'}); box on;
