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

%load('/Users/dlizarbe/Documents/DANIEL/2001_2010/Z_2002_2010.mat');
g=9.81;

yr=1990:2010;
mo=1:12;

%x=dist2coast(LAT,LON);
%[dx, dy] = gradient(x);
%coastline_orientation_angle = atan2(dy, dx); %radian
[dx,dy] = cdtdim(LAT,LON);
%load('rossby_radious_INPAINT.mat');
jj=0;
for iy=yr(1):1:yr(end)
    
    for imo=mo(1):1:mo(end)
        jj=jj+1;
        fn=sprintf('Mean_Y%dM%d.nc',iy,imo);
        disp(fn)

    %wind stress
    uwind=double(ncread(fn,'sustr'));
    vwind=double(ncread(fn,'svstr'));
    
    %regrid uwind
    
    Taux = interp2(Xu, Yu, uwind', LON', LAT', 'linear')'.*mask; %m/s
    %regrid vwind
    Tauy = interp2(Xv, Yv, vwind', LON', LAT', 'linear')'.*mask; %m/s
    
    %%
    % D=abs(mean(Z_mean,3,'omitnan'))'./1000;%in km
    %
    % R1=sqrt(g*D.*mask)./f;
    
    % pcolor(LON,LAT,R2);shading flat;colorbar;
    % title('Baroclinic Rossby radius of deformation R in Km (Chelton 1998)','fontsize',16);
    f=double(ncread(fn,'f'));
    %x=dist2coast(LAT,LON);
    
    %[Taux,Tauy] = windstress(U,V);
    rho_seawater = 1025;
    
    Ue=(Tauy./(rho_seawater.*f));
    Ve=-(Taux./(rho_seawater.*f));
    
%     dVdx = gradient(Ve, dx, 2); 
%     dUdy = gradient(Ue, dy, 1);
%     
%     curl_V_Ekman = dVdx - dUdy;
    %% 
    for k = 1:size(Tauy,3)
        [~,dUdy] = gradient(Tauy(:,:,k)./dy);
        [dVdx,~] = gradient(Taux(:,:,k)./dx);
        Cz(:,:,k) = dVdx-dUdy;
    end
    %Czz = Cz.*sign(LAT);
    D = dUdy +  dVdx;
    C = cdtcurl(LAT,LON,Taux,Tauy).*mask;
    D = D.*sign(LAT);
    Curl (:,:,jj) = C;
    Divergence (:,:,jj) = D; 
    
    Crosshore_wind(:,:,jj) = Taux;
    VTauy(:,:,jj) = Tauy;
    EK_pump(:,:,jj) = C./(rho_seawater.*f);
    UEK(:,:,jj) = Ue;
    VEK(:,:,jj) = Ve;
    end
end
%% LTM

LTM_ekpump = mean(EK_pump,3,'omitnan');

save('EKMAN_pump_April.mat','EK_pump','UEK','VEK','LTM_ekpump','Curl','Crosshore_wind','Divergence','VTauy');
%% 
flag =0;
if flag ==1
    Humboldt_ports;
    
    [c,h]=contourf(LON,LAT,LTM_ekpump.*mask.*86400,[-3:0.2:3]);colorbar;
    set(h,'LineColor','none');
    title('Long-term mean of ocean (1990-2010) WSCD (Wcurl)','fontsize',16);
    cmocean('balance',13);
    caxis([-1.6 1.6]); hold on;
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
    end
    
end
