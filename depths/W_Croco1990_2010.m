
clear all; close all; clc

cd /Volumes/BM_2022_x/Hindcast_1990_2010/depths
mask=ncread('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Mean_Y2010M12.nc','mask_rho');
LON=ncread('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Mean_Y2010M12.nc','lon_rho'); %lon lat s_rho time
LAT=ncread('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Mean_Y2010M12.nc','lat_rho');

mask(mask==0)=NaN;

hdir=dir('Depth_Y*.mat');
vardir=dir('var_Y*.mat');

yr=1990:2010;
mo=1:12;

Wmld=zeros(size(LON,2),size(LON,1),length(hdir));
%wind=zeros(size(LON,2),size(LON,1),length(hdir));

%figure
jj=0;
Wmld_sum=0;
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
save('MLD_W_1990_2010.mat','Wmld');
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
sumData=0;
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
save('Z_1990_2010.mat','Z_mean');

