clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
%%
cd /Volumes/BM_2022_x/Hindcast_1990_2010/means;
hdir=dir('M*.nc');
%[Xu,Yu]=meshgrid(LON(1:end-1,1), LAT(1,:));
%[Xv,Yv]=meshgrid(LON(:,1), LAT(1,1:end-1));

%load('/Users/dlizarbe/Documents/DANIEL/2001_2010/Z_2002_2010.mat');
g=9.81;

yr=1990:2010;
mo=1:12;
%% --- MLD -- %% 
%load('rossby_radious_INPAINT.mat');
jj=0;
for iy=yr(1):1:yr(end)
    
    for imo=mo(1):1:mo(end)
        jj=jj+1;
        fn=sprintf('Mean_Y%dM%d.nc',iy,imo);
        disp(fn)
        
        mld=double(ncread(fn,'hbl')); 
        
        MLD(:,:,jj)=mld;
        time(jj)=datenum(iy,imo,15);
    end
end
%%
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/CUTI
save('MLD.mat','MLD','time');
%% ---------------------- U geo ---------------------------- %% 
%upload SSH, check my journal for details.

%load('rossby_radious_INPAINT.mat');
jj=0;
for iy=yr(1):1:yr(end)
    
    for imo=mo(1):1:mo(end)
        jj=jj+1;
        fn=sprintf('Mean_Y%dM%d.nc',iy,imo);
        disp(fn)
        
        ssh=double(ncread(fn,'zeta')); 
        
        SSH(:,:,jj)=ssh;
        time(jj)=datenum(iy,imo,15);
    end
end
%% save
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/CUTI

save('SSH_croco.mat','SSH','LON','LAT','time');
%% 
LTM_ssh = mean(SSH,3,'omitnan')*100;
LTM_mld = mean(MLD,3,'omitnan');
Humboldt_ports;

%% plot
figure
P=get(gcf,'position');
P(3)=P(3)*1.2;
P(4)=P(4)*2.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

pcolor(LON,LAT,LTM_mld.*mask); shading flat;
hold on
[c,h]=contour(LON,LAT,LTM_mld.*mask,[0:10:80],'k');
clabel(c,h);
cmocean('delta');
borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 
ax = gca;
ax.FontSize = 18; 
c=colorbar;
c.Label.String='m';
c.Label.FontSize = 20;
hold on
for i = 1:length(Puertos)
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end
title('Long-term mean of ocean (1990-2010) MLD','fontsize',16); 
%% load SSH
figure
P=get(gcf,'position');
P(3)=P(3)*1.2;
P(4)=P(4)*2.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

pcolor(LON,LAT,LTM_ssh.*mask); shading flat;
hold on
[c,h]=contour(LON,LAT,LTM_ssh.*mask,[-30:2:30],'k');
clabel(c,h);
cmocean('delta');
borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 
ax = gca;
ax.FontSize = 18; 
c=colorbar;
c.Label.String='cm';
c.Label.FontSize = 20;
hold on
for i = 1:length(Puertos)
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 14); % Plot text
end
title('Long-term mean of ocean (1990-2010) SSH','fontsize',16); 
caxis([-30 30]);

%% 

