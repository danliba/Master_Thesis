% Andreas idea to get the w velocity at different depths
% clear all; close all; clc;
% addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
% cd /Volumes/BM_2019_01/climate;

function get_Upwelling_profile(inpath,infile)
[mask,LON,LAT,~]=lets_get_started_CC;
mask(mask==0)=NaN;
%cd /Volumes/BM_2022_x/Hindcast_1990_2010/Presentation

arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
R1=kml2struct(arch_kml_zona1);
lonb1=R1.Lon; latb1=R1.Lat;

% Create indicator matrix based on polygon
ind1 = double(inpolygon(LON, LAT, lonb1, latb1));
ind1(ind1 == 0) = NaN;
%-- lati loni
indxlat12 = find(LAT(1,:)>= -16 & LAT(1,:)<=-5);
indxlon12 = find(LON(:,1)>= -85 & LON(:,1)<=-70);

%loni=LON(indxlon12,1); lati =LAT(1,indxlat12)';
%%
cd(inpath);
%inpath = '/Volumes/BM_2019_01/climate/ref';
%infile = 'croco_avg_Y*';
hdir = dir(infile);
ij=0;
for ifloat= 1:1:length(hdir)
    
    ij=ij+1;
    fn=hdir(ifloat).name;
    disp(fn)
    
    %-------------
    s_rho=ncread(fn,'s_rho');
    s_w=ncread(fn,'s_w');
    
    zz=get_depths(fn,fn,1,'rho'); %we get the depths using all the rho variables
    
    % 12 S
    indxlat12 = find(LAT(1,:)>= -16 & LAT(1,:)<=-5);
    indxlon12 = find(LON(:,1)>= -85 & LON(:,1)<=-70);
    
    start_lon = min(indxlon12);
    count_lon = length(indxlon12);
    start_lat = min(indxlat12);
    count_lat = length(indxlat12);
    
    start_time = 1;  % Assuming we want to start from the first time step
    count_time = Inf;  % Use Inf to read all time steps
    
    w = ncread(fn, 'w', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time]);
    ww=permute(w,[3 2 1 4]);
    zz1 = zz(:,indxlat12,indxlon12);
    
    %----w50 and w30m----%
    jj=0;
    for ii=0:-10:-300
        
        jj=jj+1;
        %     w_20m=get_W_m(fn,-50);
        %             jj=jj+1;
        w2 = vinterp(ww,zz1,ii); w2(w2==0)=NaN;
        w22(:,:,jj) = w2;
    end
    cWMLD = permute(w22,[2 1 3]) .* ind1(indxlon12,indxlat12) .* mask(indxlon12,indxlat12);
    wnew2(:,ij) = squeeze(mean(mean(cWMLD,2,'omitnan'),1,'omitnan'))';
end
%% save
depths = [0:-10:-300];
save('W_perfil_5_16','wnew2','depths');
end
