clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
cd /Volumes/BM_2022_x/Hindcast_1990_2010/means/MLD

load('MLD.mat');
%% ---- Upwelling Region --- %
arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

ind1=double(inpolygon(LON,LAT,lonb1,latb1));
ind1(ind1==0)=NaN;

lati=LAT(1,:); loni=LON(:,1);
indxlat=find(lati>=-20 & lati<=-5);

nMLD=MLD.*ind1.*mask;
cMLD=nMLD(:,indxlat,:);

%% ------- MLD ------ % 

time = generate_monthly_time_vector(1990, 2010)';

Mean_MLD=permute(mean(cMLD,1,'omitnan'),[2 3 1]);
MLD_ts = mean(Mean_MLD,1,'omitnan')';
lat_MLD = mean(Mean_MLD,2,'omitnan');

%% Climatology

jj=0;
[yr,mo]=datevec(time);

for imo=1:1:12
    
    indxclim=find(mo==imo);
    
    climMLD(imo,:)=mean(MLD_ts(indxclim,:),1,'omitnan');
    climMeanMLD(:,imo) = mean(Mean_MLD(:,indxclim),2,'omitnan');
end

%% ------ Anomalies ----- %% 
jj=0;
for iy=yr(1):yr(end)
    
    for imo=mo(1):mo(end)
        
        jj=jj+1;
        indxAnom = find(iy==yr & imo ==mo);
        
        MLD_anom(jj,:) = MLD_ts(indxAnom) - climMLD(imo);
        MLDMean_anom(:,jj) = Mean_MLD(:,indxAnom) - climMeanMLD(:,imo);
    end
end

%% latitudinal anomaly
lat_MLD_anom = mean(MLDMean_anom,2,'omitnan');

save('MLD_processed.mat','lat_MLD_anom','MLD_ts','Mean_MLD','lat_MLD',...
    'MLD_anom','MLDMean_anom');



