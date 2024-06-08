clear all; close all; clc

addpath /Volumes/BM_2022_x/Hindcast_1990_2010
addpath /Volumes/BM_2022_x/CDT-master/cdt

path1='./';
cd /Users/dlizarbe/Documents/DANIEL/croco_tools
start
cd /Users/dlizarbe/Documents/DANIEL/depths

%% load
mask=ncread('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Mean_Y2010M12.nc','mask_rho');
LON=ncread('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Mean_Y2010M12.nc','lon_rho'); %lon lat s_rho time
LAT=ncread('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Mean_Y2010M12.nc','lat_rho');

load('var_Y2010M12.mat');
load('Depth_Y2010M12.mat');
ww=permute(w,[3 2 1 4]);

wnew = vinterp(ww,z,-50); %50 m depth

%% lets find the MLD
mask(mask==0)=NaN;

figure
pcolor(LON,LAT,mld.*mask); shading flat; colorbar;
title('MLD'); cmocean thermal;

%% MLD greater than 50m NaN;
% indxmld=find(mld(:,478)<=50);
% MLD=mld(indxmld);
% 
loni=LON';
lati=LAT';
mldi=mld';

for ilong=1:size(loni,2)
    for ilat=1:size(lati,1)

        indxmld=mldi(ilat,ilong)<=10;

        if indxmld==0
            nn=NaN;
        else

            nn=mldi(ilat,ilong);
        end
        MLD(ilat,ilong)=nn;
    end
    disp(ilong)
end

pcolor(LON',LAT',MLD.*mask'); shading flat; colorbar;
title('MLD');
%% W at MLD and W velocity at 50m 
aa=ones(542,602);
aa(aa==1)=50; 
w_interp_mld50 = winterp_mld(ww, z, aa);

w_interp_mld = winterp_mld(ww, z,mld');
%w_interp_mld2 = winterp_mld2(ww, z,mld');

figure
subplot(1,3,1)
pcolor(LON',LAT',w_interp_mld.*mask'); shading flat; colorbar;
title('W velocity at MLD'); cmocean deep;
caxis([-1*10^(-4) 1*10^(-4)]);

subplot(1,3,2)
pcolor(LON',LAT',w_interp_mld50.*mask'); shading flat; colorbar;
title('W velocity at 50m depth'); cmocean deep;
caxis([-1*10^(-4) 1*10^(-4)]);

subplot(1,3,3)
pcolor(LON,LAT,wnew'.*mask); shading flat; colorbar;
title('W velocity at 50m depth'); cmocean deep;
caxis([-1*10^(-4) 1*10^(-4)]);

%% now the monthly values from 1990 to 2010
%w is in meter/second
% now we find the long term mean

clear all; close all; clc

cd /Users/dlizarbe/Documents/DANIEL/depths
mask=ncread('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Mean_Y2010M12.nc','mask_rho');
LON=ncread('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Mean_Y2010M12.nc','lon_rho'); %lon lat s_rho time
LAT=ncread('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Mean_Y2010M12.nc','lat_rho');

mask(mask==0)=NaN;

hdir=dir('Depth_Y*.mat');
vardir=dir('var_Y*.mat');

yr=2000:2010;
mo=1:12;

Wmld=zeros(size(LON,2),size(LON,1),length(hdir));
%wind=zeros(size(LON,2),size(LON,1),length(hdir));

%figure
jj=0;
for iy=yr(1):1:yr(end)
    
    for imo=mo(1):1:mo(end)
        
        fn_depth=sprintf('Depth_Y%dM%d.mat',iy,imo);
        fn_var=sprintf('var_Y%dM%d.mat',iy,imo);
        disp(fn_var)
        
        z=struct2array(load(fn_depth,'z'));
        load(fn_var);
        ww=permute(w,[3 2 1 4]);
                
        
        w_interp_mld = winterp_mld(ww, z,mld');
        
%         pcolor(LON',LAT',w_interp_mld.*mask'); shading flat; colorbar;
%         title(['W velocity at MLD - ' fn_var(5:end-4)]); cmocean deep;
%         caxis([-1*10^(-4) 1*10^(-4)]);
%         
%         pause(1)
%         clf
        
        jj=jj+1;
        Wmld(:,:,jj)=w_interp_mld;
        %wind(:,:,jj)=wind10';
    end
    
end
%% 
%save('MLD_W.mat','Wmld','wind');
save('MLD_W.mat','Wmld');
%% 
clear all; close all; clc

cd /Users/dlizarbe/Documents/DANIEL/depths
% mask=ncread('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Mean_Y2010M12.nc','mask_rho');
% LON=ncread('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Mean_Y2010M12.nc','lon_rho'); %lon lat s_rho time
% LAT=ncread('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Mean_Y2010M12.nc','lat_rho');

%mask(mask==0)=NaN;

hdir=dir('Depth_Y*.mat');
%vardir=dir('var_Y200*.mat');

yr=1990:2010;
mo=1:12;

%jj=0;
for iy=yr(1):1:yr(end)
    
    for imo=mo(1):1:mo(end)
        
        fn_depth=sprintf('Depth_Y%dM%d.mat',iy,imo);
        z=struct2array(load(fn_depth,'z'));
        zz=permute(z,[2 3 1]);
        disp(fn_depth)
        
        %jj=jj+1;    
        %z_all(:,:,:,jj)=zz;
        
        sumData=sumData+zz;
    end
    
end
%% 
Z_mean=sumData./length(hdir);
save('Z_all.mat','Z_mean');
%% 
% Z_mean=mean(z_all,4,'omitnan');
% 


