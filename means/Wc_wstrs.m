%% wc de Borbard
clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
%%
cd /Volumes/BM_2022_x/Hindcast_1990_2010/means;
hdir=dir('M*.nc');
[Xu,Yu]=meshgrid(LON(1:end-1,1), LAT(1,:));
[Xv,Yv]=meshgrid(LON(:,1), LAT(1,1:end-1));

load('/Users/dlizarbe/Documents/DANIEL/2001_2010/Z_2002_2010.mat');
g=9.81;

load('rossby_radious_INPAINT.mat');
WcSum=0;
%% LOOP

yr=1990:1:2010;
mo=1:1:12;

jj=0;
for iy=yr(1):1:yr(end)
    
    for imo=mo(1):1:mo(end)
        fn=sprintf('Mean_Y%dM%d.nc',iy,imo);
        disp(fn)
        %winds
        uwind=double(ncread(fn,'sustr'));
        vwind=double(ncread(fn,'svstr'));
        
        %regrid uwind
        
        Taux = interp2(Xu, Yu, uwind', LON', LAT', 'linear')'; %m/s
        %regrid vwind
        Tauy = interp2(Xv, Yv, vwind', LON', LAT', 'linear')'; %m/s
        
        %pcolor(LON,LAT,Taux);shading flat;colorbar;
        %%
        % D=abs(mean(Z_mean,3,'omitnan'))'./1000;%in km
        %
        % R1=sqrt(g*D.*mask)./f;
        
        % pcolor(LON,LAT,R2);shading flat;colorbar;
        % title('Baroclinic Rossby radius of deformation R in Km (Chelton 1998)','fontsize',16);
        f=coriolisf(LAT);
        %f=2.*(7.2921e-5).*sin(deg2rad(LAT)); %rad/s
        %% now the Wc
        x=dist2coast(LAT,LON);
        % [c,h]=contourf(LON,LAT,x.*mask,[0:50:1000]); colorbar;
        % clabel(c,h);
        % axis([-90 -70 -33 10]);
        % caxis([0 900])
        % title('Distance to coast in Km','fontsize',16);
        %%
        %[Taux,Tauy] = windstress(U,V);
        rho_seawater = 1025;
        
        Ue=(Tauy./(rho_seawater.*f));
        Ve=-(Taux./(rho_seawater.*f));
        
        %[UE,VE,~]=ekman(LAT,LON,U,V);%m/s
        
        %now the cross-shore
        % Calculate gradient of distance grid
        
        [dx, dy] = gradient(x);
        
        % Compute angle of coastline orientation
        coastline_orientation_angle = atan2(dy, dx);
        
        % Convert angle to degrees
        %coastline_orientation_angle_deg = rad2deg(coastline_orientation_angle);
        
        % pcolor(LON,LAT,coastline_orientation_angle_deg.*mask); shading flat; colorbar;
        % title('Angle of the coastline orientation (θ) in degrees','fontsize',16);
        % axis([-90 -70 -33 10]);
        
        %%
        %now km/s
        
        % [c,h]=contourf(LON,LAT,UE.*mask,[-10:1:10]); colorbar;
        % clabel(c,h);
        % caxis([-10 10]);
        % title('U component of Ekman (U-cross shore)','fontsize',16);
        % axis([-90 -70 -33 10]);
        %%
        ny=cos(coastline_orientation_angle);
        %Ucross_shore=UE.*cos(coastline_orientation_angle) + VE.*sin(coastline_orientation_angle);%m/s
        Ucross_shore=Ue.*ny; %m/s
        %Ucross_shore2=UE.*ny; %m/s
        %     pcolor(LON,LAT,Ucross_shore.*mask); colorbar; shading flat;
        %     caxis([-5 5]);
        %     title('U component of Ekman (U-cross shore) m/s','fontsize',16);
        %     axis([-90 -70 -33 10]);
        
        %%
        r1=R2.*1000; %in meters
        e1=2.7182818284;
        x1=x.*1000; %in meters
        Wc=(2.07*(Ucross_shore)./r1).*(e1.^(-(2.3026.*x1)./r1)); %m/s
        %check the units
        %figure;pcolor(LON,LAT,Wc);shading flat; caxis([-10 10]);
        %Wc2=(2.07*(Ucross_shore2)./r2).*(e1.^((2.3026.*x1)./r2));
        jj=jj+1;
        WcSum=Wc+WcSum;
        WcMean(:,:,jj)=Wc;
    end
end
%% 
Wc_mean=WcSum./length(hdir);
%WcMeani=mean(WcMean,3,'omitnan');
%WcMean=WcSum2./length(hdir);
%% ------------------------------- Cut off the offshore -------------------------%% 
% figure
% [c,h]=contourf(LON,LAT,Wc.*86400.*mask,[-10:0.2:5]);shading flat; colorbar; 
% cmocean('balance',13); set(h,'LineColor','none');
% title('WC transport velocity','fontsize',16); 
% caxis([-5 5]);

%% 
%Wc(abs(Wc)>10^-2)=NaN;
% [c,h]=contourf(LON,LAT,Wc.*mask);clabel(c,h);
% %caxis([1*10e-5 6*10e-5])
% axis([-90 -70 -33 10]); 
% title('Wc','fontsize',16); colorbar;
%% 
%Wc(Wc>10^-3 & Wc<10^-3)=NaN;
% pcolor(LON,LAT,Wc_mean.*mask); shading flat; colorbar;
% caxis([-8*10^-6 8*10^-6]);
% hold on
% [c,h]=contour(LON,LAT,x.*mask,[100 100],'k'); 
% clabel(c,h);
% axis([-90 -70 -33 10]);
% title('Mean Wc','fontsize',16);

%% 
figure
[c,h]=contourf(LON,LAT,Wc_mean.*86400.*mask,[-3:0.2:3]);shading flat; colorbar; 
cmocean('balance',13); set(h,'LineColor','none');
title('Mean Wc transport velocity','fontsize',16); 
caxis([-1.6 1.6]);
hold on
[c,h]=contour(LON,LAT,x.*mask,[100 100],'k','linewidth',2); 
clabel(c,h);
axis([-90 -70 -33 10]);
%% 
%WC_mean2 and WC_mean are the same 
save('Wc_mean_wstrss.mat','LON','LAT','Wc_mean','x','mask','WcMean');
%% we extract 100km 
