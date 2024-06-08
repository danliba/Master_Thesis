%% Ekman transport from Croco
%% winds
clear all; close all; clc;
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
%% 
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
hdir=dir('M*.nc');
[Xu,Yu]=meshgrid(LON(1:end-1,1), LAT(1,:));
[Xv,Yv]=meshgrid(LON(:,1), LAT(1,1:end-1));

parfor ii=1:1:length(hdir)
    fn=hdir(ii).name
    %winds
    uwind=double(ncread(fn,'uwnd'));
    vwind=double(ncread(fn,'vwnd'));
    
    %windstress
    uwindstr=double(ncread(fn,'sustr'));
    vwindstr=double(ncread(fn,'svstr'));
    
    %regrid uwind
    
    U = interp2(Xu, Yu, uwind', LON', LAT', 'linear')';
    %Ustress = interp2(X, Y, uwindstr', LON', LAT', 'linear')';
    
    %regrid vwind
    
    V = interp2(Xv, Yv, vwind', LON', LAT', 'linear')';
    %Vstress=interp2(X, Y, vwindstr', LON', LAT', 'linear')';
    
    [UE,VE,wE,dE] = ekman(LAT,LON,U,V);
    wE_c(:,:,ii)=wE;
    %clear uwind vwind U V
end
%% 
wE_mean=mean(wE_c,3,'omitnan');

save('Ekman_Croco.mat','wE_mean');
%% 
figure
[c,h]=contourf(LON,LAT,wE_mean.*86400.*mask,[-10:0.2:2]);shading flat; colorbar; 
cmocean('balance',13); set(h,'LineColor','none');
title('Long-term mean of ocean (1990-2010) Ekman transport velocity','fontsize',16); 
caxis([-1.6 1.6]);
% hold on
% quiversc(LON,LAT,U,V);
