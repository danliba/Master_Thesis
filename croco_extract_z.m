cd E:\Hindcast_1990_2010
%%
%% Monthly average

%% GET the W velocity at 50m depth

clear all; close all; clc;
cd E:\Hindcast_1990_2010
addpath E:\Hindcast_1990_2010
addpath E:\CDT-master

path1='./';
dir1=dir([path1,'croco*.nc']);
%% first year 1990
% hdir=[dir1(1:12)];
fn='croco_avg_Y1990M2.nc';
%%

timestep=10; %3 day average per month, 10 day average every month
n=3;
%band=24
%ncdisp([path1,dir1(n).name]);
LON=ncread([path1,dir1(n).name],'lon_rho'); %lon lat s_rho time
LAT=ncread([path1,dir1(n).name],'lat_rho');
s_rho=ncread([path1,dir1(n).name],'s_rho');
s_w=ncread([path1,dir1(n).name],'s_w');
mask=ncread([path1,dir1(n).name],'mask_rho');

mask(mask==0)=NaN;
%mask2=mask(201:398,216:338);
cd 'D:\Maestria\MER\master thesis\GEOMAR_BIOGEOCHEMICAL_LAB\Upwelling_Indexes\croco_tools'
start
cd E:\Hindcast_1990_2010
%%

yr=2000:2001;
mo=1:12;
%z=gpuArray(zeros(length(s_rho),size(LON,2),size(LON,1),length(mo)*length(yr),'single')); %between layers - 32
%zw=gpuArray(zeros(length(s_w),size(LON,2),size(LON,1),length(mo)*length(yr),'single')); %edge of layers - 33

jj=0;

for iy=yr(1):1:yr(end)

    for imo=mo(1):1:mo(end)

        jj=jj+1;
        filename=sprintf('croco_avg_Y%dM%d.nc',iy,imo);
        disp(filename)

        parfor st=1:1:timestep
            zz(:,:,:,st)=gpuArray(get_depths([path1,filename],[path1,filename],st,'rho')); %we get the depths using all the rho variables
            zww(:,:,:,st)=gpuArray(get_depths([path1,filename],[path1,filename],st,'w')); %we get the depths using all the wi variables
            disp(st)
        end

        z(:,:,:,jj)=mean(zz,4,'omitnan');
        zw(:,:,:,jj)=mean(zww,4,'omitnan');
        %clear zz zww
    end
end

%%

times=linspace(1990,2001,length(mo)*length(yr));
save('Depth_points_2000M1_2001M11.mat','z','zw','-v7.3');