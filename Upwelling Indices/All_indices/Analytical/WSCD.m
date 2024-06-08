%% Now lets calculatew the ekman pump
addpath  /Users/dlizarbe/Documents/DANIEL/2001_2010
clear all; close all; clc;
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
%% 
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
hdir=dir('M*.nc');
[Xu,Yu]=meshgrid(LON(1:end-1,1), LAT(1,:));
[Xv,Yv]=meshgrid(LON(:,1), LAT(1,1:end-1));

WSCD_sum=0;
for i=1:1:length(hdir)
    fn=hdir(i).name;
    %winds
    uwind=double(ncread(fn,'uwnd'));
    vwind=double(ncread(fn,'vwnd'));
    
    %regrid uwind
    
    U = interp2(Xu, Yu, uwind', LON', LAT', 'linear')';
    %regrid vwind
    V = interp2(Xv, Yv, vwind', LON', LAT', 'linear')';
    %% wind stress
    Cd = 1.3e-3;
    %% now the wind stress curl and wind-stress-curl-driven upwelling
    
    rho_seawater = 1025;
    
    [Taux,Tauy] = windstress(U,V);
    
    C = cdtcurl(LAT,LON,Taux,Tauy);
    C = C.*sign(LAT);
    
    f=coriolisf(LAT);
    % Define the components of wind stress
    
    % Calculate the gradient of the wind stress curl
    [d_wind_stress_curl_dx, d_wind_stress_curl_dy] = gradient(C); % Partial derivatives of wind stress curl with respect to x and y
    
    % Calculate the divergence of the gradient to obtain the pressure gradient force
    PGF = -(d_wind_stress_curl_dx + d_wind_stress_curl_dy);
    
    WSCD_upwelling=PGF./ (rho_seawater .* f);
    
    WSCD_sum=WSCD_upwelling+WSCD_sum;
    WSCD2(:,:,i)=WSCD_upwelling;
    disp(fn);
end
%% WSCD
W_scd=WSCD_sum./length(hdir);
%WSCD2_mean = mean(WSCD2,3,'omitnan');

U=double(ncread('Wind_average.nc','uwnd'));
V=double(ncread('Wind_average.nc','vwnd'));

U = interp2(Xu, Yu, U', LON', LAT', 'linear')';
%regrid vwind
V = interp2(Xv, Yv, V', LON', LAT', 'linear')';

Humboldt_ports
load('Mean_199709_2010_chlor');
%% 
long_degrees=5;
figure
[c,h]=contourf(LON,LAT,W_scd.*86400.*mask,[-10:0.2:2]);shading flat; colorbar; 
cmocean('balance',13); set(h,'LineColor','none');
title('Long-term mean of ocean WSCD transport','fontsize',16); 
caxis([-1.6 1.6]);
hold on
quiversc(LON,LAT,U,V,'k');hold on;
[c,h]=contour(lon,lat,chloro',[0.5 2 5 10],'g','linewidth',2);
clabel(c,h);
borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 
ax = gca;
ax.FontSize = 16; 
c=colorbar;
c.Label.String='m/day';
hold on
for i = 1:length(Puertos)
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 12); % Plot text
%     xx=[floor(x)-long_degrees,x];
%     yy=[y-0.2, y+0.2];
%     hold on
%     plot_square(xx(1),xx(2)-0.2,yy(1),yy(2));
%     xsq{i,1}=xx; ysq{i,1}=yy;
%     distance_km(i,1) = calculate_longitudinal_distance(Puertos{i,2}(1),long_degrees);%lat, long_degrees
% end

end

%% 
%save('WSCD.mat','W_scd','LON','LAT','mask','U','V','lon','lat','chloro','WSCD2');
% Uwstress = double(ncread(fn,'sustr'));
% Vwstress = double(ncread(fn,'svstr'));
% Ustr = interp2(Xu, Yu, Uwstress', LON', LAT', 'linear')';
% %regrid vwind
% Vstr = interp2(Xv, Yv, Vwstress', LON', LAT', 'linear')';
% 
% 
% pcolor(LON,LAT,PGF.*mask); shading flat;
% title('Pressure Gradient','fontsize',16);colorbar;