clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
%% ------------ Integrated Biomass --------------- %%
cd /Volumes/BM_2019_01/For_Daniel/biomass
yr=1990:2010;
mo=1:12;

jj=0;
for iy=yr(1):1:yr(end)
    
    for imo=mo(1):1:mo(end)
        
        fn=sprintf('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Mean_Y%dM%d.nc',iy,imo);
        %fn2=;
        disp(fn)
        jj=jj+1;
        
        SPHYTO=permute(double(ncread(fn,'SPHYTO')),[3 2 1 4]);
        LPHYTO=permute(double(ncread(fn,'LPHYTO')),[3 2 1 4]);
        SZOO=permute(double(ncread(fn,'SZOO')),[3 2 1 4]);
        LZOO=permute(double(ncread(fn,'LZOO')),[3 2 1 4]);
        s_rho=ncread(fn,'s_rho');
        s_w=ncread(fn,'s_w');
        
        zr=get_depths(fn,fn,1,'rho'); %we get the depths using all the rho variables
        zw=get_depths(fn,fn,1,'w'); %we get the depths using all the wi variables
        
        [sphyto,~]=vintegr2(SPHYTO,zw,zr,NaN,NaN);
        [lphyto,~]=vintegr2(LPHYTO,zw,zr,NaN,NaN);
        [szoo,~]=vintegr2(SZOO,zw,zr,NaN,NaN);
        [lzoo,~]=vintegr2(LZOO,zw,zr,NaN,NaN);
        
        phyto(:,:,jj) = sphyto + lphyto;
        zoo(:,:,jj) = szoo + lzoo;
    end
end
%save 

save('Biomass_integrated.mat','phyto','zoo')
%% ------------- Surface Biomass ------------------- %% 
clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
cd /Volumes/BM_2019_01/For_Daniel/biomass

theta_m  =0.020; CN_Phyt  = 6.625; coef =1.59;


yr=1990:2010;
mo=1:12;

jj=0;
for iy=yr(1):1:yr(end)
    
    for imo=mo(1):1:mo(end)
        
        fn=sprintf('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Mean_Y%dM%d.nc',iy,imo);
        %fn2=;
        disp(fn)
        jj=jj+1;
        
        SPHYTO=permute(double(ncread(fn,'SPHYTO')),[3 2 1 4]);
        LPHYTO=permute(double(ncread(fn,'LPHYTO')),[3 2 1 4]);
        SZOO=permute(double(ncread(fn,'SZOO')),[3 2 1 4]);
        LZOO=permute(double(ncread(fn,'LZOO')),[3 2 1 4]);
        s_rho=ncread(fn,'s_rho');
        s_w=ncread(fn,'s_w');
        
        zr=get_depths(fn,fn,1,'rho'); %we get the depths using all the rho variables
        zw=get_depths(fn,fn,1,'w'); %we get the depths using all the wi variables
        
        [sphyto,~]=vintegr2(SPHYTO,zw,zr,-0.0001,0);
        [lphyto,~]=vintegr2(LPHYTO,zw,zr,-0.0001,0);
        [szoo,~]=vintegr2(SZOO,zw,zr,-0.0001,0);
        [lzoo,~]=vintegr2(LZOO,zw,zr,-0.0001,0);
        
        phyto(:,:,jj) = sphyto + lphyto;
        zoo(:,:,jj) = szoo + lzoo;
        
        chla=theta_m.*squeeze(SPHYTO(1,:,:))+squeeze(LPHYTO(1,:,:)).*CN_Phyt.*12;
        chla(chla<=0)=NaN;
        chla=coef.*mask'.*chla;
        
        chla2(:,:,jj) = chla;

    end
end


save('Biomass_surface.mat','phyto','zoo','chla2');

%% %% ------------- Again Surface Biomass but with diff croco tools ------------------- %% 
clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
cd /Volumes/BM_2019_01/For_Daniel/biomass

theta_m  =0.020; CN_Phyt  = 6.625; coef =1.59;


yr=1990:2010;
mo=1:12;

jj=0;
for iy=yr(1):1:yr(end)
    
    for imo=mo(1):1:mo(end)
        
        fn=sprintf('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Mean_Y%dM%d.nc',iy,imo);
        %fn2=;
        disp(fn)
        jj=jj+1;
 
        [phyto,zoo,~,chla]=get_biomass_chla(fn,fn,1,-0.001,coef);
        
        Sphyto(:,:,jj) = phyto;
        Szoo(:,:,jj) = zoo;
        Schla(:,:,jj) = chla;

    end
end



%% 
save('Biomass_surface_GOOD.mat','Sphyto','Szoo','Schla');
