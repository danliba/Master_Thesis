%% 
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

x=dist2coast(LAT,LON);
[dx, dy] = gradient(x);
coastline_orientation_angle = atan2(dy, dx); %radian
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
    
    Taux = interp2(Xu, Yu, uwind', LON', LAT', 'linear')'; %m/s
    %regrid vwind
    Tauy = interp2(Xv, Yv, vwind', LON', LAT', 'linear')'; %m/s
    
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
    %[UE,VE,wE]=ekman(LAT,LON,U,V);
    % Calculate gradient of distance grid
    %[dx, dy] = gradient(x);
    
    % Compute angle of coastline orientation
    %coastline_orientation_angle = atan2(dy, dx);
    
    % Mean Coastline angle 150km 5S to 20S
    theta=-112.2699; %change according to the upwelling lengthscale
    %relative alfa angle in radians
    %alfa = theta_w - coastline_orientation_angle;
    
    %alfa_deg=rad2deg(alfa);
    %Bakun Index
    BUI(:,:,jj) = Ue.*cosd(theta);    
    time(jj)=datenum(iy,imo,15);
    UE(:,:,jj) = Ue;
    %cut BUI  
    %SSH --> zeta  
    end
end
%% save
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices
save('BakunIndex_Final.mat','LON','LAT','BUI','mask','time','UE');
%% 
clear all; close all; clc;
load('BakunIndex_Final.mat')
Humboldt_ports;
LTM_BUI = mean(BUI,3,'omitnan');

LTM_UE = mean(UE,3,'omitnan');
%% UE 

figure
P=get(gcf,'position');
P(3)=P(3)*1;
P(4)=P(4)*2.4;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(LON,LAT,LTM_UE.*mask,[-10:0.1:10]);shading flat; colorbar; 
cmocean('balance',41); set(h,'LineColor','none'); clabel(c,h);

title('Long Term Mean [1990 - 2010] Ekam U cross-shore','fontsize',16); 
%caxis([-1.5 1.5]);
borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 
ax = gca;
ax.FontSize = 18; 
hold on
for i = 1:length(Puertos)
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end
caxis([-6, 6]);
ticks = -6:0.5:6;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String='m^{2}/s';
c.Label.FontSize = 18;

%% 
grey = [0.2 0.2 0.2];
figure
P=get(gcf,'position');
P(3)=P(3)*1;
P(4)=P(4)*2.4;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(LON,LAT,LTM_BUI.*mask,[-10:0.1:10]);shading flat; colorbar; 
cmocean('balance',41); set(h,'LineColor','none'); clabel(c,h);

title('Long Term Mean [1990 - 2010] Bakun Index','fontsize',16); 
%caxis([-1.5 1.5]);
borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 
ax = gca;
ax.FontSize = 18; 
% c=colorbar;
% c.Label.String='m^{2}/day';
% c.Label.FontSize = 10;
hold on
for i = 1:length(Puertos)
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end
caxis([-1.6, 1.6]);
ticks = -1.6:0.2:1.6;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = 'm$^{2}$/s';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 18;
%% 
arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

ind1=double(inpolygon(LON,LAT,lonb1,latb1));
ind1(ind1==0)=NaN;

lati=LAT(1,:); loni=LON(:,1);
indxlat=find(lati>=-20 & lati<=-5);

nBUI=BUI.*ind1.*mask;
cBUI=nBUI(:,indxlat,:);
%% 
figure
[c,h]=contourf(loni,lati(indxlat),squeeze(cBUI(:,:,100)'),[-10:0.2:10]);shading flat; colorbar; 
cmocean('balance',13); set(h,'LineColor','none');
axis([-90 -70 -20 -5]);

title('Bakun Index','fontsize',16); 
caxis([-1.5 1.5]);
%% 
time=time';
Mean_Bakun=permute(mean(cBUI,1,'omitnan'),[2 3 1]);

time2=linspace(1990,2010.99,length(time))';
%pcolor(time2,Mean_Bakun); shading flat;
latBakun=lati(indxlat);

%% 
figure
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*1.2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(time2,latBakun,Mean_Bakun,[-2:0.1:2]);colorbar; 
cmocean('balance',41); set(h,'LineColor','none'); clabel(c,h);
title('Monthly Bakun Index 150km offshore','fontsize',16); 
ax = gca;
ax.FontSize = 16;
ylabel('Latitude'); xlabel('Time');
ax = gca;
ax.FontSize = 16; 
caxis([-3 3]);
ticks = -3:0.5:3;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String='m^{2}/s';
c.Label.FontSize = 18;
%datetick('x');
%% Climatology

jj=0;
[yr,mo]=datevec(time');

for imo=1:1:12
    
    indxclim=find(mo==imo);
    
    climBUI(:,imo)=mean(Mean_Bakun(:,indxclim),2,'omitnan');
    
end

%% 
timeclim=1:12;

figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*3;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(timeclim,latBakun,climBUI,[-3:0.1:3]);shading flat; colorbar; 
cmocean('balance',41); clabel(c,h);set(h,'LineColor',grey); clabel(c,h);
title('Bakun Index Climatology 150km offshore','fontsize',16); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Months');
caxis([-1.6 1.6]);
ticks = -1.6:0.2:1.6;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String='m^{2}/day';
c.Label.FontSize = 18;
%% 
save('BUI_hvmoller_U_150km.mat','time2','latBakun','Mean_Bakun','time');