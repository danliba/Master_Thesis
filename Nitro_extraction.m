clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
%%
cd /Volumes/BM_2022_x/Hindcast_1990_2010/means;
% hdir=dir('M*.nc');
% [Xu,Yu]=meshgrid(LON(1:end-1,1), LAT(1,:));
% [Xv,Yv]=meshgrid(LON(:,1), LAT(1,1:end-1));
% 
% %load('/Users/dlizarbe/Documents/DANIEL/2001_2010/Z_2002_2010.mat');
% g=9.81;

yr=1990:2010;
mo=1:12;
jj=0;

%% lets get the nitrogen at the base of the MLD %NO3 + NO2 + NH4 

% NO3=double(ncread(fn,'NO3'));
% NO2=double(ncread(fn,'NO2'));
% NH4=double(ncread(fn,'NH4'));
% 
% mld = double(ncread(fn,'hbl'));
% ww=permute(w,[3 2 1 4]);
% nno3 = permute(NO3,[3 2 1 4]);
% nno2 = permute(NO2,[3 2 1 4]);
% nnh4 = permute(NH4,[3 2 1 4]);
% 
% wmld=winterp_mld(ww, z,mld');
% NO3_mld = winterp_mld(nno3, z,mld');
% NO2_mld = winterp_mld(nno2, z,mld');
% NH4_mld = winterp_mld(nnh4, z,mld');
% 
% Total_N = NO3_mld + NO2_mld + NH4_mld ;
%% plot
% subplot(1,2,1)
% pcolor(LON,LAT,wmld'.*mask.*86400); shading flat;
% axis([-90 -70 -20 -5]); caxis([-2 2]);cmocean('balance',41); colorbar;
flag==0;
if flag==1
subplot(2,2,1)
pcolor(LON,LAT,NO3_mld'.*mask); shading flat;
axis([-90 -70 -20 -5]); caxis([0 5]);cmocean('turbid',41); colorbar;
title('NO3 at MLD mmol/m3');

subplot(2,2,2)
pcolor(LON,LAT,NO2_mld'.*mask); shading flat;
axis([-90 -70 -20 -5]); caxis([0 5]);cmocean('turbid',41); colorbar;
title('NO2 at MLD mmol/m3');

subplot(2,2,3)
pcolor(LON,LAT,NH4_mld'.*mask); shading flat;
axis([-90 -70 -20 -5]); caxis([0 5]);cmocean('turbid',41); colorbar;
title('NH4 at MLD mmol/m3');

subplot(2,2,4)
pcolor(LON,LAT,Total_N'.*mask); shading flat;
axis([-90 -70 -20 -5]); caxis([0 5]);cmocean('turbid',41); colorbar;
title('Total N at MLD mmol/m3');
end;
%% 
%cd /Volumes/BM_2022_x/Hindcast_1990_2010/nitrogen
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BEUTI
yr=1990:2010;
mo=1:12;

for iy=yr(1):1:yr(end)
    
    for imo=mo(1):1:mo(end)
        
        fn=sprintf('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Mean_Y%dM%d.nc',iy,imo);
        %fn2=;
        disp(fn)
        jj=jj+1;

        NO3=double(ncread(fn,'NO3'));
        NO2=double(ncread(fn,'NO2'));
        NH4=double(ncread(fn,'NH4'));
    
        nno3 = permute(NO3,[3 2 1 4]);
        nno2 = permute(NO2,[3 2 1 4]);
        nnh4 = permute(NH4,[3 2 1 4]);
        
        z = table2array(struct2table(load(sprintf('/Volumes/BM_2022_x/Hindcast_1990_2010/depths/Depth_Y%dM%d.mat',iy,imo),'z')));        
        mld = table2array(struct2table(load(sprintf('/Volumes/BM_2022_x/Hindcast_1990_2010/depths/var_Y%dM%d.mat',iy,imo),'mld')));        
        
        NO3_mld(:,:,jj) = winterp_mld(nno3, z,mld');
        NO2_mld(:,:,jj) = winterp_mld(nno2, z,mld');
        NH4_mld(:,:,jj) = winterp_mld(nnh4, z,mld');
        
        %Total_N(:,:,jj) = NO3_mld + NO2_mld + NH4_mld ;

%         savename = sprintf('Nitro_Y%dM%d.mat',iy,imo);
%         save(savename,'NO3_mld','NO2_mld','NH4_mld','Total_N');
%         
    end
end
%% save

Total_N= NO3_mld + NO2_mld + NH4_mld;

save('Nitrogen.mat','NO3_mld','NO2_mld','NH4_mld','Total_N');