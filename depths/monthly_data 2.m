clear all; close all; clc;
cd /Volumes/BM_2022_x/Hindcast_1990_2010
addpath /Volumes/BM_2022_x/Hindcast_1990_2010
addpath /Volumes/BM_2022_x/CDT-master/cdt

path1='./';
cd /Users/dlizarbe/Documents/DANIEL/croco_tools
start
cd /Volumes/BM_2022_x/Hindcast_1990_2010
JM='/Volumes/BM_2022_x/Hindcast_1990_2010/all_time';
%% 
cd /Volumes/BM_2022_x/Hindcast_1990_2010/means
hdir=dir('M*.nc');

timestep=10;

for ii=1:1:length(hdir)
    flist=hdir(ii).name;
    disp(flist)
    
    zz=get_depths([path1,flist],[path1,flist],1,'rho'); %we get the depths using all the rho variables
    zww=get_depths([path1,flist],[path1,flist],1,'w'); %we get the depths using all the wi variables
    
    z=mean(zz,4,'omitnan');
    zw=mean(zww,4,'omitnan');
    %disp(list_files(ii))
    
    fname=['Depth_' flist(6:13) '.mat'];
    mfile=fullfile(JM,fname);
    save(mfile,'z','zw');
end
%% MLD, w extraction

cd /Volumes/BM_2022_x/Hindcast_1990_2010/means
hdir=dir('M*.nc');

timestep=10;

for ii=1:1:length(hdir)
    flist=hdir(ii).name;
    disp(flist)
    
    mld=mean(ncread([path1,flist],'hbl'),3,'omitnan');
%     Vwind=mean(ncread([path1,flist],'wind10'),3,'omitnan');
%     Uwind
    w=mean(ncread([path1,flist],'w'),4,'omitnan');
    %disp(list_files(ii))
    
    fname=['var_' flist(6:13) '.mat'];
    mfile=fullfile(JM,fname);
    save(mfile,'mld','w');
end
%% WINDS

% cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout
% hdir=dir('M*.nc');
% 
% timestep=10;
% 
% for ii=1:1:length(hdir)
%     flist=hdir(ii).name;
%     disp(flist)
%     
%      Vwind=mean(ncread([path1,flist],'vwnd'),3,'omitnan');
%      Uwind
%     %disp(list_files(ii))
%     
%     fname=['Wind_' flist(6:13) '.mat'];
%     mfile=fullfile(JM,fname);
%     save(mfile,'mld','w');
% end


