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

[Xv,Yv]=meshgrid(LON(:,1), LAT(1,1:end-1));

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
        
        v=ncread(fn,'v');
        
        for ik=1:1:size(v,3)
            V(:,:,ik) = interp2(Xv, Yv, v(:,:,ik)', LON', LAT', 'linear')';
            
        end
        
        vv=permute(V,[3 2 1 4]);
        
      jj=0;
        for ii=-25:-10:-500
            jj=jj+1;
            vnew(:,:,jj) = vinterp(vv,zz,ii);

            disp(ii)
        end
        
        % 6 to 3 S
        indxlat = find(LAT(1,:)>= -18 & LAT(1,:)<=-3);
        indxlon = find(LON(:,1)>= -82 & LON(:,1)<=-71);
      
        
        Vmean25_500(:,:,ij) = permute(sum(vnew,3,'omitnan'),[2 3 1]);
       
    end
end
%% 
cd /Users/dlizarbe/Documents/DANIEL/DanielLizarbe/IMARPE
LTM_Vmean = mean(Vmean25_500,3,'omitnan');

% lon2 = LON(indxlon,1); lat2 = LAT(1,indxlat);
% 
% [c,h]=contourf(lon2,lat2,ans,[-5:0.1:5],'linestyle','none'); 
% colorbar; cmocean('balance'); caxis([-0.5 0.5]);
% borders('countries','facecolor','white');
% axis([-82 -71 -18 -3]); 
%% 
%LTM_Vmean = mean(Vmean3,3,'omitnan');
%%
save('V_velocity25_500m','Vmean25_500','LTM_Vmean');
%%
arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

ind1=double(inpolygon(LON,LAT,lonb1,latb1));
ind1(ind1==0)=NaN;
nLTM_Vmean=LTM_Vmean.*ind1.*mask;

[~,ylab] = generateYLabels(18,3,3);
[~,xlab] = generateXLabels(84,71,3);
grey = [0.5 0.5 0.5];
%%
%nLTM_Vmean = 150*1000*nLTM_Vmean./10^6;

figure
P=get(gcf,'position');
P(3)=P(3)*1;
P(4)=P(4)*1.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(LON,LAT,nLTM_Vmean,[-5:0.1:5],'linestyle','none'); 
colorbar; cmocean('balance',13); caxis([-3 3]);
borders('countries','facecolor',grey);
set(gca,'ytick',[-18:3:-3],'yticklabel',ylab,'ylim',[-18 -3]);
set(gca,'xtick',[-84:3:-72],'xticklabel',xlab,'xlim',[-84 -71]);

colorbar
ax = gca;
ax.FontSize = 20;
ticks = -3:0.5:3;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = 'Alongshore transport ($Sv$)';
c.Label.Interpreter = 'latex';
title('LTM Integrated V velocity [25-500m]'); 

%% now in Sverdrup
nLTM_Vmean = 150*1000*nLTM_Vmean./10^6;
%%
figure
P=get(gcf,'position');
P(3)=P(3)*1;
P(4)=P(4)*1.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(LON,LAT,nLTM_Vmean,[-5:0.1:5],'linestyle','none'); 
colorbar; cmocean('balance',11); caxis([-0.5 0.5]);
borders('countries','facecolor',grey);
set(gca,'ytick',[-18:3:-3],'yticklabel',ylab,'ylim',[-18 -3]);
set(gca,'xtick',[-84:3:-72],'xticklabel',xlab,'xlim',[-84 -71]);

colorbar;
ax = gca;
ax.FontSize = 20;
ticks = -0.5:0.1:0.5;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = 'Alongshore transport ($Sv$)';
c.Label.Interpreter = 'latex';
title('LTM Integrated V velocity [25-500m]'); 
%% ----- Anomalies --------- %
time = generate_monthly_time_vector(1990, 2010)';
[~, VmeanAnom] = calculateClimatologyAndAnomalies(Vmean25_500, time);
%% Now under ENSO conditions

load('ENSO_DANTE_dates.mat');
timeNINO2(16)=[]; indxNINO2(16) = [];
%% V mean
%--- V velocity ---- %
Vmean_NINO = mean(Vmean25_500(:,:,indxNINO2),3,'omitnan');
Vmean_NINA = mean(Vmean25_500(:,:,indxNINA2),3,'omitnan');
Vmean_NEUTRO = mean(Vmean25_500(:,:,indxNEUTRO2),3,'omitnan');

%--- Monthly detrended --- % 
Vmean_NINOa = mean(VmeanAnom(:,:,indxNINO2),3,'omitnan');
Vmean_NINAa = mean(VmeanAnom(:,:,indxNINA2),3,'omitnan');
Vmean_NEUTROa = mean(VmeanAnom(:,:,indxNEUTRO2),3,'omitnan');

%------ Cut the Region -------- %
[~,~,VmeanNINO] = calculate_URegion(Vmean_NINO, LON, LAT, mask);
[~,~,VmeanNINA] = calculate_URegion(Vmean_NINA, LON, LAT, mask);
[~,~,VmeanNEUTRO] = calculate_URegion(Vmean_NEUTRO, LON, LAT, mask);

[~,~,VmeanNINOa] = calculate_URegion(Vmean_NINOa, LON, LAT, mask);
[~,~,VmeanNINAa] = calculate_URegion(Vmean_NINAa, LON, LAT, mask);
[~,~,VmeanNEUTROa] = calculate_URegion(Vmean_NEUTROa, LON, LAT, mask);


nVmeanNINO = 150*1000*VmeanNINO./10^6;
nVmeanNINA = 150*1000*VmeanNINA./10^6;
nVmeanNEUTRO = 150*1000*VmeanNEUTRO./10^6;

nVmeanNINOa = 150*1000*VmeanNINOa./10^6;
nVmeanNINAa = 150*1000*VmeanNINAa./10^6;
nVmeanNEUTROa = 150*1000*VmeanNEUTROa./10^6;

%% 
figure
P=get(gcf,'position');
P(3)=P(3)*1*3;
P(4)=P(4)*1.5*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');
%-------- NINO --------%
subplot(2,3,1)
[c,h]=contourf(LON,LAT,nVmeanNINO,[-5:0.1:5],'linestyle','none'); 
colorbar; cmocean('balance',11); caxis([-0.5 0.5]);
borders('countries','facecolor',grey);
set(gca,'ytick',[-18:3:-3],'yticklabel',ylab,'ylim',[-18 -3]);
set(gca,'xtick',[-84:3:-72],'xticklabel',xlab,'xlim',[-84 -71]);

colorbar;
ax = gca;
ax.FontSize = 20;
ticks = -0.5:0.1:0.5;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = 'Alongshore transport ($Sv$)';
c.Label.Interpreter = 'latex';
title('NINO Integrated V velocity [25-500m]'); 
%-----------NINA --------- %
subplot(2,3,2)
[c,h]=contourf(LON,LAT,nVmeanNINA,[-5:0.1:5],'linestyle','none'); 
colorbar; cmocean('balance',11); caxis([-0.5 0.5]);
borders('countries','facecolor',grey);
set(gca,'ytick',[-18:3:-3],'yticklabel',ylab,'ylim',[-18 -3]);
set(gca,'xtick',[-84:3:-72],'xticklabel',xlab,'xlim',[-84 -71]);

colorbar;
ax = gca;
ax.FontSize = 20;
ticks = -0.5:0.1:0.5;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = 'Alongshore transport ($Sv$)';
c.Label.Interpreter = 'latex';
title('NINA Integrated V velocity [25-500m]'); 

%--------NEUTRO ---------- %
subplot(2,3,3)
[c,h]=contourf(LON,LAT,nVmeanNEUTRO,[-5:0.1:5],'linestyle','none'); 
colorbar; cmocean('balance',11); caxis([-0.5 0.5]);
borders('countries','facecolor',grey);
set(gca,'ytick',[-18:3:-3],'yticklabel',ylab,'ylim',[-18 -3]);
set(gca,'xtick',[-84:3:-72],'xticklabel',xlab,'xlim',[-84 -71]);

colorbar;
ax = gca;
ax.FontSize = 20;
ticks = -0.5:0.1:0.5;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = 'Alongshore transport ($Sv$)';
c.Label.Interpreter = 'latex';
title('NEUTRO Integrated V velocity [25-500m]'); 


% %% Anomalies
% figure
% P=get(gcf,'position');
% P(3)=P(3)*1*3;
% P(4)=P(4)*1.5;
% set(gcf,'position',P);
% set(gcf,'PaperPositionMode','auto');
%-------- NINO --------%
subplot(2,3,4)
[c,h]=contourf(LON,LAT,nVmeanNINOa,[-5:0.01:5],'linestyle','none'); 
colorbar; cmocean('balance',9); caxis([-0.2 0.2]);
borders('countries','facecolor',grey);
set(gca,'ytick',[-18:3:-3],'yticklabel',ylab,'ylim',[-18 -3]);
set(gca,'xtick',[-84:3:-72],'xticklabel',xlab,'xlim',[-84 -71]);

colorbar;
ax = gca;
ax.FontSize = 20;
ticks = -0.2:0.05:0.2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = 'Alongshore transport ($Sv$)';
c.Label.Interpreter = 'latex';
title('NINO Integrated V velocity [25-500m]'); 
%-----------NINA --------- %
subplot(2,3,5)
[c,h]=contourf(LON,LAT,nVmeanNINAa,[-5:0.01:5],'linestyle','none'); 
colorbar; cmocean('balance',9); caxis([-0.2 0.2]);
borders('countries','facecolor',grey);
set(gca,'ytick',[-18:3:-3],'yticklabel',ylab,'ylim',[-18 -3]);
set(gca,'xtick',[-84:3:-72],'xticklabel',xlab,'xlim',[-84 -71]);

colorbar;
ax = gca;
ax.FontSize = 20;
ticks = -0.2:0.05:0.2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = 'Alongshore transport ($Sv$)';
c.Label.Interpreter = 'latex';
title('NINA Integrated V velocity [25-500m]'); 

%--------NEUTRO ---------- %
subplot(2,3,6)
[c,h]=contourf(LON,LAT,nVmeanNEUTROa,[-5:0.01:5],'linestyle','none'); 
colorbar; cmocean('balance',9); caxis([-0.2 0.2]);
borders('countries','facecolor',grey);
set(gca,'ytick',[-18:3:-3],'yticklabel',ylab,'ylim',[-18 -3]);
set(gca,'xtick',[-84:3:-72],'xticklabel',xlab,'xlim',[-84 -71]);

colorbar;
ax = gca;
ax.FontSize = 20;
ticks = -0.2:0.05:0.2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = 'Alongshore transport ($Sv$)';
c.Label.Interpreter = 'latex';
title('NEUTRO Integrated V velocity [25-500m]'); 




