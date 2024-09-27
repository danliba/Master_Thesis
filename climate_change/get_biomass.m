function get_biomass(in_path,fname)
[mask,LON,LAT,~,~]=lets_get_started_CC;
cd(in_path);
mask(mask==0)=NaN;
%% ------------ Integrated Biomass --------------- %%
hdir = dir(fname);

jj=0;
for icroco = 1:1:length(hdir)
    fn = hdir(icroco).name;
        disp(fn)
        %fn2=;
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


save('Biomass_integrated.mat','phyto','zoo')
%% ------------- Surface Biomass ------------------- %% 

theta_m  =0.020; CN_Phyt  = 6.625; coef =1.59;

jj=0;
for icroco = 1:1:length(hdir)
    fn = hdir(icroco).name;
    disp(fn)
    jj=jj+1;
    
    [phyto,zoo,~,chla]=get_biomass_chla(fn,fn,1,-0.001,coef);
    
    Sphyto(:,:,jj) = phyto;
    Szoo(:,:,jj) = zoo;
    Schla(:,:,jj) = chla;
    
end

save('Biomass_surface_GOOD.mat','Sphyto','Szoo','Schla');
