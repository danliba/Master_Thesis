function get_PP_flux(inpath)
[mask,LON,LAT,~]=lets_get_started_CC;
mask(mask==0)=NaN;

cd(inpath)
hdir = dir('*diabio_avg*');

%% loni
indxlon = find(LON(:,1)>= -85 & LON(:,1)<=-75);
loni = LON(indxlon,1);
%%

ij=0;
for ik=1:1:length(hdir)
    fn=hdir(ik).name;
    disp(fn)
    
    
    s_rho=ncread(fn,'s_rho');
    s_w=ncread(fn,'s_w');
    
    %     zz=get_depths(fn,fn,1,'rho'); %we get the depths using all the rho variables
    zr=get_depths(fn,fn,1,'rho'); %we get the depths using all the rho variables
    zw=get_depths(fn,fn,1,'w'); %we get the depths using all the wi variables

      
    %--- small phyto
    NO3P1=permute(double(ncread(fn,'NFlux_ProdNO3P1')),[3 2 1 4]);
    NO3P2=permute(double(ncread(fn,'NFlux_ProdNO3P2')),[3 2 1 4]);
    NO2P1=permute(double(ncread(fn,'NFlux_ProdNO2P1')),[3 2 1 4]);
    NO2P2=permute(double(ncread(fn,'NFlux_ProdNO2P2')),[3 2 1 4]);
    NH4P1=permute(double(ncread(fn,'NFlux_ProdNH4P1')),[3 2 1 4]);
    NH4P2=permute(double(ncread(fn,'NFlux_ProdNH4P2')),[3 2 1 4]);
    
    [no3p1,~]=vintegr2(NO3P1,zw,zr,NaN,NaN);
    [no3p2,~]=vintegr2(NO3P2,zw,zr,NaN,NaN);
    [no2p1,~]=vintegr2(NO2P1,zw,zr,NaN,NaN);
    [no2p2,~]=vintegr2(NO2P2,zw,zr,NaN,NaN);
    [nh4p1,~]=vintegr2(NH4P1,zw,zr,NaN,NaN);
    [nh4p2,~]=vintegr2(NH4P2,zw,zr,NaN,NaN);
    ij = ij+1;
    PP_fluxes(:,:,ij) = no3p1+no3p2+no2p1+no2p2+nh4p1+nh4p2;
end    


% %%
% nPP_flux = calculate_URegion2(PP_fluxes, LON, LAT, mask);
% TS_ppflux = mean(nPP_flux,1)'*86400;
% 
% PPFlux = mean(TS_ppflux,'omitnan');

save('PP_flux_int.mat','PP_fluxes');
end