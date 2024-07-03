
function nitro_crossShore(inpath, pattern)
cd /Volumes/BM_2019_01/climate

%% Monthly average
[mask,LON,LAT,~]=lets_get_started_CC;
mask(mask==0)=NaN;

cd(inpath)
dir1=dir(pattern);

indxlat = find(LAT(1,:)>= -16 & LAT(1,:)<=-5);
indxlon = find(LON(:,1)>= -85 & LON(:,1)<=-75);

lati=LAT(1,indxlat); loni = LON(indxlon,1);
[LONi,LATi]=meshgrid(loni,lati);

%% from 6 to 3 S
% dates_6_3 = ['2008M5', '2008M6', '2008M10', '2009M3', '2009M4', '2009M6', '2009M7', 
% '2009M8', '2009M9','2010M1','2010M2','2010M3','','','', ];


ij=0;
for ik=1:1:length(dir1)
    
    ij=ij+1;
    fn=dir1(ik).name;
    disp(fn)
    
    %fn='Mean_Y2008M5.nc';
    
    s_rho=ncread(fn,'s_rho');
    s_w=ncread(fn,'s_w');
    
    zz=get_depths(fn,fn,1,'rho'); %we get the depths using all the rho variables
    
    % 12 S
    indxlat12 = find(LAT(1,:)>= -16 & LAT(1,:)<=-5);
    indxlon12 = find(LON(:,1)>= -85 & LON(:,1)<=-75);
    
    start_lon = min(indxlon12);
    count_lon = length(indxlon12);
    start_lat = min(indxlat12);
    count_lat = length(indxlat12);
    
    start_time = 1;  % Assuming we want to start from the first time step
    count_time = Inf;  % Use Inf to read all time steps
    
    NO3 = ncread(fn, 'NO3', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time]);
    NO2 = ncread(fn,'NO2', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time]);
    NH4 = ncread(fn,'NH4', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time]);
    
    no3=permute(NO3,[3 2 1 4]);
    no2=permute(NO2,[3 2 1 4]);
    nh4=permute(NH4,[3 2 1 4]);
    zz1 = zz(:,indxlat12,indxlon12);
    
    jj=0;
    for ii=0:-10:-500
        jj=jj+1;
        NO3_2 = vinterp(no3,zz1,ii); NO3_2(NO3_2==0)=NaN;
        NO3new(:,:,jj) = shift_coast_to_0km_ver2(NO3_2);
        
        NO2_1 = vinterp(no2,zz1,ii);  NO2_1(NO2_1==0)=NaN;
        NO2new(:,:,jj) = shift_coast_to_0km_ver2(NO2_1);
        
        NH4_1 = vinterp(nh4,zz1,ii); NH4_1(NH4_1==0)=NaN;
        NH4new(:,:,jj) = shift_coast_to_0km_ver2(NH4_1);
        
        disp(ii)
    end
    
    NO3_1415(:,:,ij) = permute(mean(NO3new,1,'omitnan'),[2 3 1]);
    NO2_1415(:,:,ij) = permute(mean(NO2new,1,'omitnan'),[2 3 1]);
    NH4_1415(:,:,ij) = permute(mean(NH4new,1,'omitnan'),[2 3 1]);
    
    
end


%% 
Total_N1415= NO3_1415 + NO2_1415 + NH4_1415;
save('Cross_shore_N_composit_5_16.mat','Total_N1415','NO3_1415','NO2_1415','NH4_1415');
end