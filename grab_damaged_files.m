% grab the z and zw of the damaged files
clear all; close all; clc;
cd /Volumes/BM_2022_x/Hindcast_1990_2010
addpath /Volumes/BM_2022_x/Hindcast_1990_2010
addpath /Volumes/BM_2022_x/CDT-master/cdt

path1='./';
cd /Users/dlizarbe/Documents/DANIEL/croco_tools
start
cd /Volumes/BM_2022_x/Hindcast_1990_2010
JM='/Volumes/BM_2022_x/Hindcast_1990_2010/depths';
%% 
% list_files={'croco_avg_Y1998M10.nc','croco_avg_Y1998M12.nc',...
%     'croco_avg_Y1999M4.nc','croco_avg_Y1999M5.nc','croco_avg_Y1999M6.nc',...
%     'croco_avg_Y1999M7.nc','croco_avg_Y1999M8.nc','croco_avg_Y1999M9.nc',...
%     'croco_avg_Y2000M12.nc','croco_avg_Y2000M2.nc','croco_avg_Y2000M3.nc',...
%     'croco_avg_Y2000M4.nc','croco_avg_Y2000M8.nc','croco_avg_Y2000M9.nc',...
%     'croco_avg_Y2001M1.nc'};

list_files={'croco_avg_Y2000M12.nc','croco_avg_Y2000M2.nc','croco_avg_Y2000M3.nc',...
    'croco_avg_Y2000M4.nc','croco_avg_Y2000M8.nc','croco_avg_Y2000M9.nc',...
    'croco_avg_Y2001M1.nc'};

timestep=10;
for ii=1:1:length(list_files)
    flist=char(list_files(ii));
    disp(flist)
    for st=1:1:timestep
        
        zz(:,:,:,st)=get_depths([path1,flist],[path1,flist],st,'rho'); %we get the depths using all the rho variables
        zww(:,:,:,st)=get_depths([path1,flist],[path1,flist],st,'w'); %we get the depths using all the wi variables
        
        disp(st)
    end
    z=mean(zz,4,'omitnan');
    zw=mean(zww,4,'omitnan');
    %disp(list_files(ii))
    
    fname=['Depth_' flist(11:18) '.mat'];
    mfile=fullfile(JM,fname);
    save(mfile,'z','zw');
end

%% 

%% MLD,w and wind
%'croco_avg_Y1999M9.nc' --> corrupted not working (not on the list)
%'croco_avg_Y1992M4.nc --> corrupted not working (3)
%croco_avg_Y1992M5.nc --> corrupted not working (4)
% croco_avg_Y1993M1.nc --> corrupted not working (6)
% croco_avg_Y1993M10.nc --> corrupted not working (7)
% croco_avg_Y1993M6.nc --> corrupted not working (10)
% croco_avg_Y1993M7.nc --> corrupted not working (11)
% croco_avg_Y1993M8.nc --> corrupted not working (12) mld
% croco_avg_Y1994M4.nc --> corrupted not working (15) wind
% croco_avg_Y1994M5.nc --> corrupted not working (16) hbl
% croco_avg_Y1994M6.nc --> corrupted not working (17) hbl
% croco_avg_Y1995M4.nc --> corrupted not working (21) hbl
% croco_avg_Y1995M5.nc --> corrupted not working (22) w10
% croco_avg_Y1995M6.nc --> corrupted not working (23) w10
% croco_avg_Y1995M7.nc --> corrupted not working (24) mld
% croco_avg_Y1995M8.nc --> corrupted not working (24) hbl
% croco_avg_Y1997M2.nc --> corrupted not working (24) hbl
% croco_avg_Y1997M2.nc --> corrupted not working (35) hbl
% croco_avg_Y1997M3.nc --> corrupted not working (36) hbl
% croco_avg_Y1997M4.nc --> corrupted not working (37) hbl
% croco_avg_Y1997M5.nc --> corrupted not working (38) hbl
% croco_avg_Y1997M6.nc --> corrupted not working (39) hbl
% croco_avg_Y1997M7.nc --> corrupted not working (40) hbl
% croco_avg_Y1997M8.nc --> corrupted not working (41) hbl
% croco_avg_Y1998M8.nc --> corrupted not working (51) hbl
% croco_avg_Y1999M4.nc --> corrupted not working (52) hbl
% croco_avg_Y1999M5.nc --> corrupted not working (53) hbl
% croco_avg_Y1999M6.nc --> corrupted not working (54) hbl
% croco_avg_Y2000M12.nc --> corrupted not working (57) hbl
% croco_avg_Y2000M2.nc --> corrupted not working (58) hbl
% croco_avg_Y2000M4.nc --> corrupted not working (60) hbl
% croco_avg_Y2000M8.nc --> corrupted not working (61) hbl
% croco_avg_Y2001M1.nc --> corrupted not working (63) hbl

load('corrupted_list.mat');

for ii=62:1:length(list)
    flist=char(list(ii));
    disp(flist)
    
    mld=mean(ncread([path1,flist],'hbl'),3,'omitnan');
    wind10=mean(ncread([path1,flist],'wind10'),3,'omitnan');
    w=mean(ncread([path1,flist],'w'),4,'omitnan'); 
%     MLD=mean(mld,3,'omitnan');
%     wind=mean(wind10,3,'omitnan');
%     w_vel=mean(w,4,'omitnan');
    
    fname=['var_' flist(11:18) '.mat'];
    mfile=fullfile(JM,fname);
    save(mfile,'mld','wind10','w');
    
end

