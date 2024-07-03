function PP_CrossShore_CC(inpath)
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
    
    zz=get_depths(fn,fn,1,'rho'); %we get the depths using all the rho variables
    
    
    %fn = 'diabio_avg_Y1990M01.nc';
    indxlat = find(LAT(1,:)>= -16 & LAT(1,:)<=-5);
    indxlon = find(LON(:,1)>= -85 & LON(:,1)<=-75);
    
    start_lon = min(indxlon);
    count_lon = length(indxlon);
    start_lat = min(indxlat);
    count_lat = length(indxlat);
    
    start_time = 1;  % Assuming we want to start from the first time step
    count_time = Inf;  % Use Inf to read all time steps
    
    %--- small phyto
    NO3P1=permute(double(ncread(fn,'NFlux_ProdNO3P1', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time])),[3 2 1 4]);
    NO3P2=permute(double(ncread(fn,'NFlux_ProdNO3P2', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time])),[3 2 1 4]);
    NO2P1=permute(double(ncread(fn,'NFlux_ProdNO2P1', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time])),[3 2 1 4]);
    NO2P2=permute(double(ncread(fn,'NFlux_ProdNO2P2', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time])),[3 2 1 4]);
    NH4P1=permute(double(ncread(fn,'NFlux_ProdNH4P1', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time])),[3 2 1 4]);
    NH4P2=permute(double(ncread(fn,'NFlux_ProdNH4P2', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time])),[3 2 1 4]);
    
    zz1 = zz(:,indxlat,indxlon);
    
    jj=0;
    for ii=0:-10:-500
        
        jj=jj+1;
        %vnew1 = vinterp(vv,zz1,ii);  vnew1(vnew1==0)=NaN;
        NO3P1_new1 = vinterp(NO3P1,zz1,ii); NO3P1_new1(NO3P1_new1==0)=NaN;
        NO3P2_new1 = vinterp(NO3P2,zz1,ii); NO3P2_new1(NO3P2_new1==0)=NaN;
        NO2P1_new1 = vinterp(NO2P1,zz1,ii); NO2P1_new1(NO2P1_new1==0)=NaN;
        NO2P2_new1 = vinterp(NO2P2,zz1,ii); NO2P2_new1(NO2P2_new1==0)=NaN;
        NH4P1_new1 = vinterp(NH4P1,zz1,ii); NH4P1_new1(NH4P1_new1==0)=NaN;
        NH4P2_new1 = vinterp(NH4P2,zz1,ii); NH4P2_new1(NH4P2_new1==0)=NaN;
        
        
        no3p1 = shift_coast_to_0km_ver2(NO3P1_new1);
        no3p2 = shift_coast_to_0km_ver2(NO3P2_new1);
        no2p1 = shift_coast_to_0km_ver2(NO2P1_new1);
        no2p2 = shift_coast_to_0km_ver2(NO2P2_new1);
        nh4p1 = shift_coast_to_0km_ver2(NH4P1_new1);
        nh4p2 = shift_coast_to_0km_ver2(NH4P2_new1);
        
        PP_flux(:,:,jj) = no3p1+no3p2+no2p1+no2p2+nh4p1+nh4p2;
        disp(ii)
    end
    
    %PP_flux(:,:,ij) = no3p1+no3p2+no2p1+no2p2+nh4p1+nh4p2;
    
    PP_fluxes(:,:,ik) = permute(mean(PP_flux,1,'omitnan'),[2 3 1]);
    
    
end
%%

save('PP_flux_Cross_shore.mat','PP_fluxes');
end