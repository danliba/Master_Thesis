clear all; close all; clc;
%% ---- plot of the Study Regio ----- %%
[mask,LON,LAT,f,path1]=lets_get_started_CC;
mask(mask==0)=NaN;
cd /Volumes/BM_2019_01/climate

%% 
p1 ='/Volumes/BM_2019_01/climate/ref';
p2 = '/Volumes/BM_2019_01/climate/T+';
p3 = '/Volumes/BM_2019_01/climate/wind-';
p4 = '/Volumes/BM_2019_01/climate/wind+';

ref=mean(struct2array(load(fullfile(p1,'WMLD_MLD.mat'), 'WMLD')),3,'omitnan');
Tplus=mean(struct2array(load(fullfile(p2,'WMLD_MLD.mat'), 'WMLD')),3,'omitnan');
Wminus=mean(struct2array(load(fullfile(p3,'WMLD_MLD.mat'), 'WMLD')),3,'omitnan');
Wplus=mean(struct2array(load(fullfile(p4,'WMLD_MLD.mat'), 'WMLD')),3,'omitnan');

%% 
indxlat1 = find(LAT(1,:)>= -16 & LAT(1,:)<=-5);
indxlon1 = find(LON(:,1)>= -85 & LON(:,1)<=-75);

%Wmld = permute(Wmld ,[2 1 3]);
ref = ref';
wvelmld = ref(indxlon1,indxlat1,:);
loni1 = LON(indxlon1,indxlat1); 
lati1 = LAT(indxlon1,indxlat1);

nw = mean(calculate_URegion2(wvelmld, loni1, lati1, mask(indxlon1,indxlat1)),1,'omitnan').*86400;
%% 
Tplus = Tplus';
wvelmld = Tplus(indxlon1,indxlat1,:);
loni1 = LON(indxlon1,indxlat1); 
lati1 = LAT(indxlon1,indxlat1);

nw = mean(calculate_URegion2(wvelmld, loni1, lati1, mask(indxlon1,indxlat1)),1,'omitnan').*86400

%% 
Wminus = Wminus';
wvelmld = Wminus(indxlon1,indxlat1,:);
loni1 = LON(indxlon1,indxlat1); 
lati1 = LAT(indxlon1,indxlat1);

nw = mean(calculate_URegion2(wvelmld, loni1, lati1, mask(indxlon1,indxlat1)),1,'omitnan').*86400
%% 
Wplus = Wplus';
wvelmld = Wplus(indxlon1,indxlat1,:);
loni1 = LON(indxlon1,indxlat1); 
lati1 = LAT(indxlon1,indxlat1);

nw = mean(calculate_URegion2(wvelmld, loni1, lati1, mask(indxlon1,indxlat1)),1,'omitnan').*86400