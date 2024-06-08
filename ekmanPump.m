%% Now lets calculatew the ekman pump

clear all; close all; clc;
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
%% 
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
hdir=dir('M*.nc');
[Xu,Yu]=meshgrid(LON(1:end-1,1), LAT(1,:));
[Xv,Yv]=meshgrid(LON(:,1), LAT(1,1:end-1));

fn=hdir(1).name;
%winds
uwind=double(ncread(fn,'uwnd'));
vwind=double(ncread(fn,'vwnd'));

%regrid uwind

U = interp2(Xu, Yu, uwind', LON', LAT', 'linear')';
%regrid vwind
V = interp2(Xv, Yv, vwind', LON', LAT', 'linear')';
%% wind stress
Cd = 1.3e-3; 
[x,y]=calculate_wind_stress(U,V,1.2,Cd);

%% now the wind stress curl and wind-stress-curl-driven upwelling

rho_seawater = 1025; 

[Taux,Tauy] = windstress(U,V);

C = cdtcurl(LAT,LON,Taux,Tauy);
C = C.*sign(LAT);

f=coriolisf(LAT);
% Define the components of wind stress

% % Calculate the gradient of the wind stress components
% [d_tau_y_dx, d_tau_y_dy] = gradient(tau_y); % Partial derivatives of tau_y with respect to x and y
% [d_tau_x_dx, d_tau_x_dy] = gradient(tau_x); % Partial derivatives of tau_x with respect to x and y
% 
% % Calculate the wind stress curl
% wind_stress_curl = d_tau_y_dx - d_tau_x_dy;
% 
% Calculate the gradient of the wind stress curl
[d_wind_stress_curl_dx, d_wind_stress_curl_dy] = gradient(C); % Partial derivatives of wind stress curl with respect to x and y

% Calculate the divergence of the gradient to obtain the pressure gradient force
PGF = -(d_wind_stress_curl_dx + d_wind_stress_curl_dy);

WSCD_upwelling=PGF./ (rho_seawater .* f);

%%
figure
[c,h]=contourf(LON,LAT,WSCD_upwelling.*86400.*mask,[-10:0.2:2]);shading flat; colorbar; 
cmocean('balance',13); set(h,'LineColor','none');
title(' WSCD transport velocity','fontsize',16); 
caxis([-1.6 1.6]);
%% wc de Borbard
%clear all;
load('/Users/dlizarbe/Documents/DANIEL/2001_2010/Z_2002_2010.mat');
g=9.81;

load('rossby_radious_INPAINT.mat');
% D=abs(mean(Z_mean,3,'omitnan'))'./1000;%in km
% 
% R1=sqrt(g*D.*mask)./f;

% pcolor(LON,LAT,R2);shading flat;colorbar; 
% title('Baroclinic Rossby radius of deformation R in Km (Chelton 1998)','fontsize',16); 

%% now the Wc
x=dist2coast(LAT,LON);
% [c,h]=contourf(LON,LAT,x.*mask,[0:50:1000]); colorbar;
% clabel(c,h);
% axis([-90 -70 -33 10]); 
% caxis([0 900])
% title('Distance to coast in Km','fontsize',16);
%% 
%Ue=(Tauy./(rho_seawater.*f)).*Cd;

[UE,~,~]=ekman(LAT,LON,U,V);%m/s 

%now km/s
UEkm=UE./1000;
Uekm=Ue./1000;
% [c,h]=contourf(LON,LAT,UE.*mask,[-10:1:10]); colorbar;
% clabel(c,h);
% caxis([-10 10]);
% title('U component of Ekman (U-cross shore)','fontsize',16);
% axis([-90 -70 -33 10]); 
%% 
e1=2.7182818284;

Wc=(2.07*UEkm./R2).*(e1.^(2.3026.* x./R2)); %km/s
Wc1=Wc.*1000; %m/s

Upwelling_total=Wc1+WSCD_upwelling;
%% 
figure
[c,h]=contourf(LON,LAT,Upwelling_total.*86400.*mask,[-10:0.2:2]);shading flat; colorbar; 
cmocean('balance',13); set(h,'LineColor','none');
title('WC transport velocity','fontsize',16); 
caxis([-1.6 1.6]);
%% 
figure
[c,h]=contourf(LON,LAT,Wc1.*86400.*mask,[-10:0.2:2]);shading flat; colorbar; 
cmocean('balance',13); set(h,'LineColor','none');
title('Wc transport velocity','fontsize',16); 
axis([-90 -70 -33 10]); 
borders('countries','facecolor','white');
caxis([-1.6 1.6]);