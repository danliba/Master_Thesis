% Load the Pooler toolbox
load('rossrad.dat');
latross=rossrad(:,1); lonross=rossrad(:,2); r1=rossrad(:,4);
% Define the bin size (20km)
bin_size_km = 20;

% Convert bin size from kilometers to degrees (approximately)
bin_size_deg = bin_size_km / 111.32; % 1 degree of latitude is approximately 111.32 km

% Define the latitude and longitude grid
min_lat = min(latross);
max_lat = max(latross);
min_lon = min(lonross);
max_lon = max(lonross);

%min_lat=-33; max_lat=10; min_lon=-120; max_lon=-70;

% Create the latitude and longitude grid with bins of 20km
lat_grid = min_lat:0.5:max_lat;
lon_grid = min_lon:0.5:max_lon;

% 
for i = 1:length(lon_grid)
    for j = 1:length(lat_grid)
        
        loni=lon_grid(i);
        lati=lat_grid(j);
        
        indxlon=find(loni==lonross);
        indxlat=find(lati==latross);
        
        indx0=intersect(indxlon,indxlat);
        
        if ~isempty(indx0)==1
            rad(i,j)=r1(indx0);
            
        else
            rad(i,j)=NaN;
        end
        
    end
    disp(i)
end

%% 
rad2=inpaintn(rad,10);
pcolor(lon_grid',lat_grid',rad2'); shading flat;colorbar; 
caxis([10 230])
borders;
%%
clear indxlat indxlon
%% lets crop it 
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;

region1=[240 290 -33 10];

indxlat=find(lat_grid >= region1(3) & lat_grid<= region1(4));
indxlon=find(lon_grid >= region1(1) & lon_grid<= region1(2));

r1=rad(indxlon,indxlat);
lon_r=lon_grid(indxlon)-360;
lat_r=lat_grid(indxlat);

pcolor(lon_r,lat_r,r1'); shading flat; colorbar;

%% delete nans
%sum of nans
% nans=sum(isnan(r1),1);
% indx_nan=find(nans<100);
% 
% rr1=r1(:,indx_nan);
% lat_r=lat_r(indx_nan);
% 
% indx_nan=find(sum(isnan(r1),2)<80);
% rr1=rr1(indx_nan,:);
% 
% lon_r=lon_r(indx_nan);
% 
% 
% %% now interpolate it
% [LONr,LATr]=meshgrid(lon_r,lat_r);
% 
% R1 = interp2(LONr, LATr, rr1', LON', LAT', 'linear')';
% 
% [c,h]=contourf(LON,LAT,R1);shading interp;
% clabel(c,h);
% borders('countries','facecolor','white');
% axis([-90 -70 -33 10]); 


%% Using inpaintn
region1=[240 290 -33 10];

indxlat=find(lat_grid >= region1(3) & lat_grid<= region1(4));
indxlon=find(lon_grid >= region1(1) & lon_grid<= region1(2));

r2=rad2(indxlon,indxlat);
lon_r=lon_grid(indxlon)-360;
lat_r=lat_grid(indxlat);

[c,h]=contourf(lon_r,lat_r,r2'); shading flat; colorbar;
borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 
clabel(c,h);
title('Rossby radius of deformation Interpolation using Inpaintn function',...
    'fontsize',16);
%% we make it the same size of our desired model
[LONr,LATr]=meshgrid(lon_r,lat_r);

R2 = interp2(LONr, LATr, r2', LON', LAT', 'linear')';
R2=R2.*mask;

[c,h]=contourf(LON,LAT,R2);
clabel(c,h);
borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 


%%
save('rossby_radious_INPAINT.mat','R2','LONr','LATr');
