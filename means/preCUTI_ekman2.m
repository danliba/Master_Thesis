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
%% --- U ekman -- %% 
%load('rossby_radious_INPAINT.mat');
% jj=0;
% for iy=yr(1):1:yr(end)
%     
%     for imo=mo(1):1:mo(end)
%         jj=jj+1;
%         fn=sprintf('MeanWind_Y%dM%d.nc',iy,imo);
%         %fn2=;
%         disp(fn)
%         
%         %uwspeed=;
%         %vwspeed=;
%         uwind=double(ncread(fn,'uwnd'));
%         vwind=double(ncread(fn,'vwnd'));
%         
%         %regrid uwind
%         
%         U = interp2(Xu, Yu, uwind', LON', LAT', 'linear')'; %N/m2
%         %regrid vwind
%         V = interp2(Xv, Yv, vwind', LON', LAT', 'linear')'; %N/m2
%         
%         
%         f=coriolisf(LAT);
%         %x=dist2coast(LAT,LON);
%         
%         [Taux,Tauy] = windstress(U,V);
%         rho_seawater = 1025;
%         
%         Ue=(Tauy./(rho_seawater.*f));
%         Ve=-(Taux./(rho_seawater.*f));
%         
%         UE(:,:,jj)=Ue;
%         time(jj)=datenum(iy,imo,15);
%         [Uek,~,Wek]=ekman(LAT,LON,U,V);
%         
%         UEK(:,:,jj)=Uek;
%         WEK(:,:,jj)=Wek;
%     end
% end
%% 
arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

ind1=double(inpolygon(LON,LAT,lonb1,latb1));
ind1(ind1==0)=NaN;

lati=LAT(1,:); loni=LON(:,1);
indxlat=find(lati>=-21 & lati<=-4);

nUe=UEK.*ind1.*mask;
cUe=nUe(:,indxlat,:);
latCUTI=lati(indxlat);

%%
pcolor(loni,latCUTI,squeeze(cUe(:,:,1))'); shading flat;
grid minor
set(gca, 'layer', 'top');
axis([-84 -70 -20 -5]); colorbar; cmocean('delta');
%caxis([-0.2 0.1]);
%% SSH var
lati=LAT(1,:); loni=LON(:,1);

target_latitudes=[-5:-1:-20]';

for ii=1:numel(target_latitudes)
    [~,b]=min(abs(abs(latCUTI)-abs(target_latitudes(ii))));
    indx0(ii,1)=b;
end
indx1=cat(1,length(latCUTI),indx0);% we put the first latitude 4 to 20
indx2=cat(1,indx0,1); %from 5 to 21

latSSH=latCUTI(indx1)';% latitude from 4 to 20
latSSH2=latCUTI(indx2)';% lat from 5 to 21

Uekman = cUe(:,indx2,:); %select the latitudes -5 -20

Uekman_mean=permute(nanmean(Uekman,1),[2 3 1]);

%% 
plot(squeeze(Uekman_mean(:,1)),latSSH2,'o-'); title('U ekman m^{2}/s','fontsize',16);
ax = gca; ax.FontSize = 16; 

time2=linspace(1990,2010,length(time));
pcolor(time2,latSSH2,Uekman_mean); shading flat;
%%
figure
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*1.2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(time2,latSSH2,Uekman_mean);colorbar; 
cmocean('delta'); set(h,'LineColor','none'); clabel(c,h);
title('Monthly U ekman 150km offshore','fontsize',16); 
ax = gca;
ax.FontSize = 16;
ylabel('Latitude'); xlabel('Time');
ax = gca;
ax.FontSize = 16; 
c=colorbar;
c.Label.String='m^{2}/s';

%% Now CUTI
load('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Ugeo.mat');

CUTI = Uekman_mean+Ugeo_mean;

figure
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*1.2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(time2,latSSH2,CUTI);colorbar; 
cmocean('delta'); set(h,'LineColor','none'); clabel(c,h);
title('Monthly CUTI 150km offshore 1 degree bin','fontsize',16); 
ax = gca;
ax.FontSize = 16;
ylabel('Latitude'); xlabel('Time');
ax = gca;
ax.FontSize = 16; 
c=colorbar;
c.Label.String='m^{2}/s';

%%
%%
jj=0;
[yr,mo]=datevec(time');

for imo=1:1:12
    
    indxclim=find(mo==imo);
    
    climCUTI(:,imo)=mean(CUTI(:,indxclim),2,'omitnan');
    
end

%%
timeclim=1:12;

figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*3;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(timeclim,latSSH2,climCUTI);shading flat; colorbar; 
cmocean('delta'); clabel(c,h);set(h,'LineColor','white'); 
title('Bakun Index Climatology 150km offshore','fontsize',16); 
ax = gca;
ax.FontSize = 16;
ylabel('Latitude'); xlabel('Months');

