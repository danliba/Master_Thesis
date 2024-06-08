clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,~,path1]=lets_get_started;
mask(mask==0)=NaN;
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/SST
%% 
load('SST.mat');
time = generate_monthly_time_vector(1990, 2010)';
%% region Nino 1=2 , 0-10s, 90-80w

region0=[-90 -80 -10 0];

indxlat=find(LAT(1,:)>=region0(3) & LAT(1,:)<=region0(4));
indxlon=find(LON(:,1)>=region0(1) & LON(:,1)<=region0(2));

SSTs = permute(mean(mean(SSTi(indxlon,indxlat,:),1,'omitnan'),2,'omitnan'),[3 1 2]);
%% calculate anomaly

%--- climatology --%
jj=0;
[yr,mo]=datevec(time);

for imo=1:1:12
    
    indxclim=find(mo==imo);
    
    climENSO(imo,1)=mean(SSTs(indxclim),'omitnan');
    
end

plot(climENSO);

%% ------anomaly ------ %%
jj=0;
for iy=yr(1):1:yr(end)
    
    for imo=mo(1):1:mo(end)
        jj=jj+1;
        indx0 = find(yr==iy&mo==imo);
        disp(datestr(time(indx0)))
        anom(jj,1)= SSTs(indx0) - climENSO(imo);
        
    end
end

%% 3 month rm
ICEN = movmean(anom,3);

plot(time,anom);
hold on
plot(time,ICEN);
datetick('x');
%% extract dates of NINO, NEUTRO and NINA 
indxNINO = find(ICEN >=0.4);
indxNINA = find(ICEN<=-1);
indxNEUTRO = find(ICEN >-1 & ICEN< 0.4);  

timeNINO = time(indxNINO);
timeNINA = time(indxNINA);
timeNEUTRO = time(indxNEUTRO);

save('ENSO_dates.mat','indxNINO','indxNINA','indxNEUTRO','timeNEUTRO','timeNINO','timeNINA');
%% Now ENSO defined by Dante, 5 consecutive months
% quitamos jun,jul 1990, nov-dic 1994 jan 1995, 
indxNINO = find(ICEN >=0.5);
indxNINA = find(ICEN<=-0.5);
indxNEUTRO = find(ICEN >-0.5 & ICEN< 0.5);  

timeNINO = time(indxNINO);
timeNINA = time(indxNINA);
timeNEUTRO = time(indxNEUTRO);

timeNINO2 = timeNINO(1:end-5); indxNINO2= indxNINO(1:end-5);
timeNINA2 = cat(1,timeNINA(10:20),timeNINA(21:28),timeNINA(52:62),timeNINA(66:71));
indxNINA2= cat(1,indxNINA(10:20),indxNINA(21:28),indxNINA(52:62),indxNINA(66:71));
indxNEUTRO2 = cat(1,indxNEUTRO,indxNINO(end-4:end),indxNINA(1:9),indxNINA(29:51),...
    indxNINA(63:65));
indxNEUTRO2=sort(indxNEUTRO2,'ascend');
timeNEUTRO2 = time(indxNEUTRO2);

save('ENSO_DANTE_dates.mat','indxNINO2','indxNINA2','indxNEUTRO2','timeNEUTRO2','timeNINO2','timeNINA2');

%% plot DANTE
figure
anomaly(time,ICEN,'thresh',[-0.5 0.5]);
axis tight; title('Nino 1+2','fontsize',20);
hline(0,'k') % places a horizontal line at 0
datetick('x','keeplimits')
ylabel 'SST anomaly (\circC)';
ax = gca;
ax.FontSize = 24;

%% plot ICEN

figure
anomaly(time,ICEN,'thresh',[-1 0.4]);
axis tight; title('ICEN index [Nino 1+2]','fontsize',20);
hline(0,'k') % places a horizontal line at 0
datetick('x','keeplimits')
ylabel 'SST anomaly (\circC)';
ax = gca;
ax.FontSize = 24;
%% export
T= array2table(ICEN);
writetable(T,filename,'Sheet','MyNewSheet','WriteVariableNames',false);
% lon=LON(indxlon,1); lat=LAT(1,indxlat);
% pcolor(lon,lat,SSTs');shading flat;