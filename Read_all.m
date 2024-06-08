clear all; close all; clc;
cd /Volumes/BM_2022_x/Hindcast_1990_2010
addpath /Volumes/BM_2022_x/Hindcast_1990_2010
addpath /Volumes/BM_2022_x/CDT-master/cdt


path1='./';
dir1=dir([path1,'croco*.nc']);
%% first year 1990
% hdir=[dir1(1:12)];
fn='croco_avg_Y1990M2.nc';

%% 
timestep=10 %3 day average per month, 10 day average every month 
month=12 % months
yr=10 % year
n=3
%band=24
%ncdisp([path1,dir1(n).name]); 
LON=ncread([path1,dir1(n).name],'lon_rho'); %lon lat s_rho time
LAT=ncread([path1,dir1(n).name],'lat_rho');
s_rho=ncread([path1,dir1(n).name],'s_rho'); 
s_w=ncread([path1,dir1(n).name],'s_w'); 

mask=ncread([path1,dir1(n).name],'mask_rho');
mask(mask==0)=NaN;

%mask2=mask(201:398,216:338);

cd /Users/dlizarbe/Documents/DANIEL/croco_tools
start
cd /Volumes/BM_2022_x/Hindcast_1990_2010
%% 
yr=1990:1991;
mo=1:12;

z=zeros(length(s_rho),size(LON,2),size(LON,1),timestep*length(mo)*length(yr),'single'); %between layers - 32
zw=zeros(length(s_w),size(LON,2),size(LON,1),timestep*length(mo)*length(yr),'single'); %edge of layers - 33

jj=0;
for iy=yr(1):1:yr(end)
    
    for imo=mo(1):1:mo(end)
        
        filename=sprintf('croco_avg_Y%dM%d.nc',iy,imo);
        disp(filename)
        
        for st=1:1:timestep
            jj=jj+1;
            [z(:,:,:,jj)]=get_depths([path1,filename],[path1,filename],st,'rho'); %we get the depths using all the rho variables
            [zw(:,:,:,jj)]=get_depths([path1,filename],[path1,filename],st,'w'); %we get the depths using all the wi variables
            disp(st)
        end
    end
end

%%
%-------------read data--------------%
% for n=1:month*yr
%     n1=(n-1)*timestep+1;
%     %n2=n*timestep;
%     for st=1:timestep
%     [z(:,:,:,n1+st-1)]=get_depths([path1,dir1(n).name],[path1,dir1(n).name],st,'rho'); %we get the depths using all the rho variables
%     [zw(:,:,:,n1+st-1)]=get_depths([path1,dir1(n).name],[path1,dir1(n).name],st,'w'); %we get the depths using all the wi variables
%     end      
% 
%     n
% end



[z(:,:,:,jj)]=get_depths([path1,dir1(31).name],[path1,dir1(31).name],st,'rho'); %we get the depths using all the rho variables
a(:,:,:,1)=get_depths([path1,dir1(31).name],[path1,dir1(31).name],st,'rho');

%% 

a=squeeze(z(1,:,:,1));
pcolor(a); shading flat;
