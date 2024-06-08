clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,f,path1]=lets_get_started;
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
load('MLD.mat');
%save('MLD.mat','MLD','LON','LAT','time');
%% 
arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

ind1=double(inpolygon(LON,LAT,lonb1,latb1));
ind1(ind1==0)=NaN;

lati=LAT(1,:); loni=LON(:,1);
indxlat=find(lati>=-21 & lati<=-4);

nMLD=MLD.*ind1.*mask;
cMLD=nMLD(:,indxlat,:);
nf = f.*ind1.*mask;
cf = nf(:,indxlat,:);

Mean_MLD=permute(mean(cMLD,1,'omitnan'),[2 3 1]);
%% climato
climatoMLD = calculate_climatology(Mean_MLD, time);
% time=time';
timeclim=1:12;

figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*3;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(timeclim,lati(indxlat),climatoMLD);shading flat; colorbar; 
cmocean('delta'); clabel(c,h,'fontsize',15);set(h,'LineColor','white'); 
title('MLD Climatology 150km offshore','fontsize',16); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Months');
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Time');
ax = gca;
ax.FontSize = 20; 
c=colorbar;
c.Label.String='m';

% time2=linspace(1990,2010,length(time))';
% %pcolor(time2,Mean_Bakun); shading flat;
% latBakun=lati(indxlat);
% 
% Long_term_Mean_MLD=nanmean(cMLD,3);
%% 
% figure
% [c,h]=contourf(loni,lati(indxlat),Long_term_Mean_MLD');shading flat; colorbar; 
% cmocean('delta',13); set(h,'LineColor','none');
% axis([-90 -70 -20 -5]);
% 
% title('MLD 150km offshore','fontsize',16); 
%caxis([-1.5 1.5]);

%%
%save('Cuti_MLD.mat','cMLD','Mean_MLD','latBakun','loni','Long_term_Mean_MLD','time','time2');
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
%% 
arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

ind1=double(inpolygon(LON,LAT,lonb1,latb1));
ind1(ind1==0)=NaN;

lati=LAT(1,:); loni=LON(:,1);
indxlat=find(lati>=-21 & lati<=-4);

nSSH=SSH.*ind1.*mask;
cSSH=nSSH(:,indxlat,:);
latCUTI=lati(indxlat);
%% 
pcolor(loni,latCUTI,squeeze(cSSH(:,:,1))'); shading flat;
grid minor
set(gca, 'layer', 'top');
axis([-84 -70 -20 -5]); colorbar; cmocean('delta');
caxis([-0.2 0.1]);

%% climato\
Mean_SSH=permute(mean(cSSH,1,'omitnan'),[2 3 1]);

climatoSSH = calculate_climatology(Mean_SSH, time);
% time=time';
timeclim=1:12;

figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*3;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(timeclim,lati(indxlat),climatoSSH);shading flat; colorbar; 
cmocean('delta'); clabel(c,h,'fontsize',15);set(h,'LineColor','white'); 
title('SSH Climatology 150km offshore','fontsize',16); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Months');
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Time');
ax = gca;
ax.FontSize = 20; 
c=colorbar;
c.Label.String='m';


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

SSH1=cSSH(:,indx1,:);
SSH2=cSSH(:,indx2,:);

cSSH2=abs(SSH1-SSH2);

%% distance between -4 to -21
% Define the latitudes
lat1 = latSSH; % Lower latitude
lat2 = latSSH2; % Higher latitude

% Earth's average radius in kilometers
R = 6371;

% Calculate the distance of 1 degree of latitude
distance_per_degree = (2 * pi * R) / 360;

% Calculate the distance between the latitudes
distance_between_latitudes = abs(lat2 - lat1) .* distance_per_degree; %km

distance_Array=repmat(distance_between_latitudes*1000,1,size(cSSH2,1))';%m

latiCUTI=repmat(lat1,1,size(cSSH2,1))';
%%
%load('/Volumes/BM_2022_x/Hindcast_1990_2010/means/MLD/Cuti_MLD.mat');

mld = cMLD(:,indx2,:); %select the latitudes -5 -20
f2=cf(:,indx2,:);
ugeo=(g.*cSSH2)./(f2.* distance_Array);
Ugeo= ugeo.* mld;

Ugeo_mean=permute(nanmean(Ugeo,1),[2 3 1]);
ugeo_vec=nanmean(ugeo,1);
%% 
plot(squeeze(ugeo_vec(1,:,1)),latSSH2,'o-'); title('ugeo m^{2}/s','fontsize',16);
ax = gca; ax.FontSize = 16; 

time2=linspace(1990,2010,length(time));
pcolor(time2,latSSH2,Ugeo_mean); shading flat;
%% 
figure
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*1.2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(time2,latSSH2,Ugeo_mean,[-10:0.5:10]);colorbar; 
cmocean('delta'); set(h,'LineColor','none'); clabel(c,h);
title('Monthly U geo 150km offshore','fontsize',16); 
ax = gca;
ax.FontSize = 16;
ylabel('Latitude'); xlabel('Time');
ax = gca;
ax.FontSize = 16; 
c=colorbar;
c.Label.String='m^{2}/s';

%% save
save('Ugeo.mat','Ugeo_mean','time2','latSSH2');
%% 
clear all; close all; clc
load('Ugeo.mat');

