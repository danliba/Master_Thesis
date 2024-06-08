%% Windstress curl and windstress anomalies
clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
cd /Volumes/BM_2022_x/Hindcast_1990_2010/means/MLD
%% 
load('EKMAN_pump_April.mat','Curl');
load('EKMAN_pump_April.mat','Crosshore_wind');
load('EKMAN_pump_April.mat','VTauy');
%load(
%%
%----- wind stress curl ---%
[Curl_ts,Curl_anom, lat_Curl,lat_Curl_anom] = calculateUpwellingAnomalies(LON, LAT, Curl.*sign(LAT), mask);

%------ Taux --------------%
[Taux_ts,Taux_anom, lat_Taux,lat_Taux_anom] = calculateUpwellingAnomalies(LON, LAT, Crosshore_wind, mask);

%------ Taux --------------%
[Tauy_ts,Tauy_anom, lat_Tauy,lat_Tauy_anom] = calculateUpwellingAnomalies(LON, LAT, VTauy, mask);

%% ------------- Load ENSO by DANTE ----------------- %%
load('ENSO_DANTE_dates.mat');
timeNINO2(16)=[];
fsize=20;
[~,ylab] = generateYLabels(20,4,2);

grey = [0.5 0.5 0.5];
brown = [165, 42, 42] ./ 255;
dark_green = [0, 100, 0] ./ 255;
blue_green = [0, 128, 128] ./ 255;
dark_yellow = [0.6, 0.6, 0]; 
%% plotting Curl
arr= ones(length(timeNINO2), 1); arr2=ones(length(timeNINA2),1);
arr(arr==1)=1000; arr2(arr2==1)=1000;
arr3(arr==1000)=-1000; arr4(arr2==1000)=-1000;

time = generate_monthly_time_vector(1990, 2010)';
trp = 0.3;

figure
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(2,1,1)
a=bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
b=bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
c=plot(time,Curl_ts.*10^7,'Color',grey,'linewidth',2,'linestyle','-');
datetick('x'); ylim([0 8]);
title('Windstress Curl');
ax = gca;
ax.FontSize = fsize;
grid on
ylabel('$\mathrm{N} \cdot \mathrm{m}^{-3} \cdot 10^{-7}  $','interpreter','latex');
legend([a,b,c],{'Nino','Nina','Curl'});

subplot(2,1,2)
bar(timeNINO2,arr3, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
bar(timeNINA2,arr4, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
a=bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
b=bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
plot(time,Curl_anom.*10^7,'Color',grey,'linewidth',0.7,'linestyle','-');
hold on
c=plot(time,movmean(Curl_anom.*10^7,13),'Color',dark_yellow,'linewidth',2,'linestyle','-');
datetick('x'); ylim([-4 5]);
title('Wind Stress Curl Anomaly');
ax = gca;
ax.FontSize = fsize;
grid on
ylabel('$\mathrm{N} \cdot \mathrm{m}^{-3} \cdot 10^{-7}  $','interpreter','latex');
legend([a,b,c],{'Nino','Nina','Curl anom'});

%% ------- Taux and Tauy
% subplot(1,2,1)
% pcolor(LON,LAT,mean(Crosshore_wind,3,'omitnan').*mask); shading flat;
% hold on; colorbar;
% plot(lonb1,latb1);
% subplot(1,2,2)
% pcolor(LON,LAT,mean(VTauy,3,'omitnan').*mask); shading flat; hold on;
% plot(lonb1,latb1);colorbar;

figure
P=get(gcf,'position');
P(3)=P(3)*1;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(1,4,1)
barh(timeNINO2,arr3, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
barh(timeNINA2,arr4, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
a=barh(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
b=barh(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
c=plot(Taux_ts.*100,time,'Color',grey,'linewidth',2,'linestyle','-');
datetick('y'); xlim([-3.5 0.5]);
title('Crosshore Wind stress');
ax = gca;
ax.FontSize = fsize;
grid on
xlabel('$\mathrm{N} \cdot \mathrm{m}^{-2} \cdot 10^{2}  $','interpreter','latex');
legend([a,b,c],{'Nino','Nina','Taux'});set(gca, 'YDir','reverse')

subplot(1,4,2)
barh(timeNINO2,arr3, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
barh(timeNINA2,arr4, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
a=barh(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
b=barh(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
plot(Taux_anom.*10^2,time,'Color',grey,'linewidth',0.7,'linestyle','-');
hold on
c=plot(movmean(Taux_anom.*10^2,7),time,'Color',dark_yellow,'linewidth',2,'linestyle','-');
datetick('y'); xlim([-2 2]);
title('Crosshore Wind stress Anomaly');
ax = gca;
ax.FontSize = fsize;
grid on
xlabel('$\mathrm{N} \cdot \mathrm{m}^{-2} \cdot 10^{2}  $','interpreter','latex');
legend([a,b,c],{'Nino','Nina','Taux'});set(gca, 'YDir','reverse')


subplot(1,4,3)
barh(timeNINO2,arr3, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
barh(timeNINA2,arr4, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
a=barh(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
b=barh(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
c=plot(Tauy_ts.*100,time,'Color',grey,'linewidth',2,'linestyle','-');
datetick('y'); xlim([1 10]);
title('Alongshore Wind stress');
ax = gca;
ax.FontSize = fsize;
grid on
xlabel('$\mathrm{N} \cdot \mathrm{m}^{-2} \cdot 10^{2}  $','interpreter','latex');
legend([a,b,c],{'Nino','Nina','Tauy'});set(gca, 'YDir','reverse')

subplot(1,4,4)
barh(timeNINO2,arr3, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
barh(timeNINA2,arr4, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
a=barh(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
b=barh(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
plot(Tauy_anom.*10^2,time,'Color',grey,'linewidth',0.7,'linestyle','-');
hold on
c=plot(movmean(Tauy_anom.*10^2,7),time,'Color',blue_green,'linewidth',2,'linestyle','-');
datetick('y'); xlim([-4 5]);
title('Alongshore Wind stress Anomaly');
ax = gca;
ax.FontSize = fsize;
grid on
xlabel('$\mathrm{N} \cdot \mathrm{m}^{-2} \cdot 10^{2}  $','interpreter','latex');
legend([a,b,c],{'Nino','Nina','Tauy'});set(gca, 'YDir','reverse')
%% 
% %% ---- Upwelling Region --- %
% arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
% R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;
% 
% ind1=double(inpolygon(LON,LAT,lonb1,latb1));
% ind1(ind1==0)=NaN;
% 
% lati=LAT(1,:); loni=LON(:,1);
% indxlat=find(lati>=-20 & lati<=-5);
% 
% nCurl=MLD.*ind1.*mask;
% cCurl=nCurl(:,indxlat,:);
% 
% %% ------- Curl ------ % 
% 
% time = generate_monthly_time_vector(1990, 2010)';
% 
% Mean_Curl=permute(mean(cCurl,1,'omitnan'),[2 3 1]);
% Curl_ts = mean(Mean_Curl,1,'omitnan')';
% lat_Curl = mean(Mean_Curl,2,'omitnan');
% 
% %--------- Taux --------% 
% 
% %% Climatology
% 
% jj=0;
% [yr,mo]=datevec(time);
% 
% for imo=1:1:12
%     
%     indxclim=find(mo==imo);
%     
%     climCurl(imo,:)=mean(Curl_ts(indxclim,:),1,'omitnan');
%     climMeanCurl(:,imo) = mean(Mean_Curl(:,indxclim),2,'omitnan');
% end
% 
% %% ------ Anomalies ----- %% 
% jj=0;
% for iy=yr(1):yr(end)
%     
%     for imo=mo(1):mo(end)
%         
%         jj=jj+1;
%         indxAnom = find(iy==yr & imo ==mo);
%         
%         Curl_anom(jj,:) = Curl_ts(indxAnom) - climCurl(imo);
%         CurlMean_anom(:,jj) = Mean_MLD(:,indxAnom) - climMeanCurl(:,imo);
%     end
% end
% 
% %% latitudinal anomaly
% lat_MLD_anom = mean(CurlMean_anom,2,'omitnan');
