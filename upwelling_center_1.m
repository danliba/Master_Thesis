cd /Volumes/BM_2022_x/Hindcast_1990_2010/means

%% Monthly average

clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
%cd /Volumes/BM_2022_x/Hindcast_1990_2010/means/MLD

cd /Volumes/BM_2022_x/Hindcast_1990_2010/means
dir1=dir('Mean*.nc');
%% from 6 to 3 S
% dates_6_3 = ['2008M5', '2008M6', '2008M10', '2009M3', '2009M4', '2009M6', '2009M7', 
% '2009M8', '2009M9','2010M1','2010M2','2010M3','','','', ];
%sampling sites 8-10, 12-14
yrst=1990;
most=1;
yren=2010;
moen=12;
moen0=moen;

ij=0;
for iy=yrst:1:yren
    
    if iy>yrst
        most=1;
    end
    % if iy is equal to yren, then let most is moen0,
    if iy==yren
        moen=moen0;
        % otherwise 12
    else
        moen=12;
    end
    
    for imo=most:1:moen
        ij=ij+1;
        fn=sprintf('Mean_Y%dM%d.nc',iy,imo);
        disp(fn)

        %fn='Mean_Y2008M5.nc';
        
        s_rho=ncread(fn,'s_rho');
        s_w=ncread(fn,'s_w');
        
        zz=get_depths(fn,fn,1,'rho'); %we get the depths using all the rho variables
        
        w=ncread(fn,'w');
        ww=permute(w,[3 2 1 4]);
        
 
        
      jj=0;
        for ii=0:-10:-500
            jj=jj+1;
            wnew(:,:,jj) = vinterp(ww,zz,ii);

            disp(ii)
        end
        
        % 6 to 3 S
        indxlat = find(LAT(1,:)>= -14 & LAT(1,:)<=-12);
        indxlon = find(LON(:,1)>= -82 & LON(:,1)<=-77);
      
        
        Wmean_12_14(:,:,ij) = permute(mean(wnew(indxlat,indxlon,:),1,'omitnan'),[2 3 1]);
       
    end
end

%% LTM
cd /Users/dlizarbe/Documents/DANIEL/DanielLizarbe/IMARPE;

LTM_W = mean(Wmean_12_14,3,'omitnan');
save('W_vel_12S14S.mat','Wmean_12_14','LTM_W');
%% 
Zi=[0:-10:-500]';
distance_km12 = calculate_longitudinal_distance(-13,5); %latitude, longitude
disti12 = flip(linspace(0,distance_km12,size(LTM_W,1)));

subplot(1,2,1)
pcolor(disti12,Zi,LTM_W'*86400); shading interp; cmocean('balance',18);
caxis([-2 2]);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([Zi(end) 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('12S-14S Upwelling Center');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));

subplot(1,2,2)
pcolor(disti12,Zi,LTM_W'*86400); shading interp; cmocean('balance',18);
caxis([-2 2]);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([-100 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('12S-14S Upwelling Center');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));

%%  ------------- Load ENSO by DANTE ----------------- %%

load('ENSO_DANTE_dates.mat');
indxNINO2(16)=[];

time = generate_monthly_time_vector(1990, 2010)';
WmeanNINO = mean(Wmean_12_14(:,:,indxNINO2),3,'omitnan');
WmeanNINA = mean(Wmean_12_14(:,:,indxNINA2),3,'omitnan');
WmeanNUETRO = mean(Wmean_12_14(:,:,indxNEUTRO2),3,'omitnan');

%% Now Nino, Nina and NEUTRO with anomalies
figure
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(1,3,1)
pcolor(disti12,Zi,WmeanNINO'*86400); shading interp; cmocean('balance',18);
caxis([-2 2]);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([Zi(end) 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('NINO: 12S-14S Upwelling Center');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));

subplot(1,3,2)
pcolor(disti12,Zi,WmeanNINA'*86400); shading interp; cmocean('balance',18);
caxis([-2 2]);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([Zi(end) 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('NINA: 12S-14S Upwelling Center');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));

subplot(1,3,3)
pcolor(disti12,Zi,WmeanNUETRO'*86400); shading interp; cmocean('balance',18);
caxis([-2 2]);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([Zi(end) 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('NEUTRO: 12S-14S Upwelling Center');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));

%% --- climatology ---- %% 

jj=0;
[yr,mo]=datevec(time');

for imo=1:1:12
    
    indxclim=find(mo==imo);
    
    climW(:,:,imo)=mean(Wmean_12_14(:,:,indxclim),3,'omitnan');
    
end

%% Anomalies
jj = 0;
for iy=yr(1):yr(end)
    for imo=mo(1):mo(end)
        
        indxAnom = find(iy==yr & imo==mo);
        disp(datestr(time(indxAnom)))
        
        jj=jj+1;
        anomW(:,:,jj) = Wmean_12_14(:,:,indxAnom) - climW(:,:,imo);
    end
end
%% Nino nina neutro

WmeanNINO_a = mean(anomW(:,:,indxNINO2),3,'omitnan');
WmeanNINA_a = mean(anomW(:,:,indxNINA2),3,'omitnan');
WmeanNUETRO_a = mean(anomW(:,:,indxNEUTRO2),3,'omitnan');

%% 
figure
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(1,3,1)
pcolor(disti12,Zi,WmeanNINO_a'*86400); shading interp; cmocean('balance',17);
caxis([-1.6 1.6]);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([Zi(end) 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('NINO: 12S-14S Upwelling Center');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -1.6:0.4:1.6;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));

subplot(1,3,2)
pcolor(disti12,Zi,WmeanNINA_a'*86400); shading interp; cmocean('balance',17);
caxis([-1.6 1.6]);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([Zi(end) 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('NINA: 12S-14S Upwelling Center');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -1.6:0.4:1.6;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));

subplot(1,3,3)
pcolor(disti12,Zi,WmeanNUETRO_a'*86400); shading interp; cmocean('balance',17);
caxis([-1.6 1.6]);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
ylim([Zi(end) 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('NEUTRO: 12S-14S Upwelling Center');
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -1.6:0.4:1.6;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));



