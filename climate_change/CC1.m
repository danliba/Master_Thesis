clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started_CC;
mask(mask==0)=NaN;
cd /Volumes/BM_2019_01/climate/wind+
%% Lets extract what we need for the indices 
%SST
%w at mld
%windstress
%mld
%nitrogen at mld
hdir = dir('avg_Y*');
for ii=1:1:length(hdir)
    fn=hdir(ii).name;
    disp(fn)
    %----wmld and mld----%
    [mld,w_interp_mld]=get_W(fn);
    MLD(:,:,ii)=mld;
    WMLD(:,:,ii)=w_interp_mld;
    disp('Ready el MLD y WMLD')
    %---- SST and SSH -----------%
    [sst,ssh]=get_SST_SSH(fn);
    SST(:,:,ii)=sst;
    SSH(:,:,ii)=ssh;
    disp('Ready el SST y SSH')
    
    %---- Nitrogen ------ %
    [TN_mld,TN_S]=get_nitrogen(fn);
    
    TN_MLD(:,:,ii) = TN_mld;
    TN_Surf(:,:,ii) = TN_S;
    
    disp('Ready el nitrogeno')
    
end
%% 
save('WMLD_MLD.mat','WMLD','MLD');
save('SST_SSH.mat','SST','SSH');
save('Nitrogen.mat','TN_MLD','TN_Surf');