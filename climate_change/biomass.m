%% let's get the phytoplanknton and zooplankton

clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
%%
fn='Mean_Y1990M1.nc';
iy=1990; imo=1;
z = table2array(struct2table(load(sprintf('/Volumes/BM_2022_x/Hindcast_1990_2010/depths/Depth_Y%dM%d.mat',iy,imo),'z')));

cd /Volumes/BM_2022_x/Hindcast_1990_2010/means;

yr=1990:2010;
mo=1:12;
jj=0;

% SPHYTO=double(ncread(fn,'SPHYTO'));
% LPHYTO=double(ncread(fn,'LPHYTO'));
% SZOO=double(ncread(fn,'SZOO'));
% LZOO=double(ncread(fn,'LZOO'));
% 
% mld = double(ncread(fn,'hbl'));
% % ww=permute(w,[3 2 1 4]);
% sphyto = permute(SPHYTO,[3 2 1 4]);
% lphyto = permute(LPHYTO,[3 2 1 4]);
% szoo = permute(SZOO,[3 2 1 4]);
% lzoo = permute(LZOO,[3 2 1 4]);
%  
% % wmld=winterp_mld(ww, z,mld');
% sphyto_mld = winterp_mld(sphyto, z,mld');
% lphyto_mld = winterp_mld(lphyto, z,mld');
% szoo_mld = winterp_mld(szoo, z,mld');
% lzoo_mld = winterp_mld(lzoo, z,mld');
% 
theta_m  =0.020; CN_Phyt  = 6.625; coef =1.59;
% chla=theta_m*(sphyto_mld+lphyto_mld)*CN_Phyt*12.;
% chla(chla<=0)=NaN;
% chla=coef.*mask.*chla';

%%
flag=0;
if flag==1
subplot(2,2,1)
pcolor(LON,LAT,sphyto_mld'.*mask); shading flat;
axis([-90 -70 -20 -5]); caxis([0 5]);cmocean('turbid',41); colorbar;
title('NO3 at MLD mmol/m3');

subplot(2,2,2)
pcolor(LON,LAT,lphyto_mld'.*mask); shading flat;
axis([-90 -70 -20 -5]); caxis([0 5]);cmocean('turbid',41); colorbar;
title('NO2 at MLD mmol/m3');

subplot(2,2,3)
pcolor(LON,LAT,szoo_mld'.*mask); shading flat;
axis([-90 -70 -20 -5]); caxis([0 5]);cmocean('turbid',41); colorbar;
title('NH4 at MLD mmol/m3');

subplot(2,2,4)
pcolor(LON,LAT,chla.*mask); shading flat;
axis([-90 -70 -20 -5]); caxis([0 5]);cmocean('turbid',41); colorbar;
title('Chla');
end;
%% 
cd /Volumes/BM_2019_01/For_Daniel/biomass
yr=1992:2010;
mo=1:12;

for iy=yr(1):1:yr(end)
    
    for imo=mo(1):1:mo(end)
        
        fn=sprintf('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Mean_Y%dM%d.nc',iy,imo);
        %fn2=;
        disp(fn)
        jj=jj+1;
        
        SPHYTO=double(ncread(fn,'SPHYTO'));
        LPHYTO=double(ncread(fn,'LPHYTO'));
        SZOO=double(ncread(fn,'SZOO'));
        LZOO=double(ncread(fn,'LZOO'));
        
        
        sphyto = permute(SPHYTO,[3 2 1 4]);
        lphyto = permute(LPHYTO,[3 2 1 4]);
        szoo = permute(SZOO,[3 2 1 4]);
        lzoo = permute(LZOO,[3 2 1 4]);
        
        
        z = table2array(struct2table(load(sprintf('/Volumes/BM_2022_x/Hindcast_1990_2010/depths/Depth_Y%dM%d.mat',iy,imo),'z')));
        mld = table2array(struct2table(load(sprintf('/Volumes/BM_2022_x/Hindcast_1990_2010/depths/var_Y%dM%d.mat',iy,imo),'mld')));
        
        sphyto_mld = winterp_mld(sphyto, z,mld');
        lphyto_mld = winterp_mld(lphyto, z,mld');
        szoo_mld = winterp_mld(szoo, z,mld');
        lzoo_mld = winterp_mld(lzoo, z,mld');
        %
        chla=theta_m*(sphyto_mld+lphyto_mld)*CN_Phyt*12.;
        chla(chla<=0)=NaN;
        chla=coef.*mask.*chla';
        %Total_N(:,:,jj) = NO3_mld + NO2_mld + NH4_mld ;
        
        savename = sprintf('Biomass_Y%dM%d.mat',iy,imo);
        save(savename,'sphyto_mld','lphyto_mld','szoo_mld','lzoo_mld','chla');
        %
    end
end
%% 
% theta_m  =0.020; CN_Phyt  = 6.625; coef =1.59;
% chla=theta_m*(sphyto_mld+lphyto_mld)*CN_Phyt*12.;
% chla(chla<=0)=NaN;
% chla=coef.*mask.*chla';
