%% Monthly average
%% GET the W velocity at 50m depth 

clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
%cd /Volumes/BM_2022_x/Hindcast_1990_2010/means/MLD

cd /Volumes/BM_2022_x/Hindcast_1990_2010/means
dir1=dir('Mean*.nc');
%% first year 1990
% hdir=[dir1(1:12)];
fn='Mean_Y2008M5.nc';

%% 
timestep=1; %3 day average per month, 10 day average every month 
n=3;
%band=24
%ncdisp([path1,dir1(n).name]); 
LON=ncread([path1,dir1(n).name],'lon_rho'); %lon lat s_rho time
LAT=ncread([path1,dir1(n).name],'lat_rho');
s_rho=ncread(fn,'s_rho'); 
s_w=ncread(fn,'s_w'); 

% mask=ncread([path1,dir1(n).name],'mask_rho');
% mask(mask==0)=NaN;

%mask2=mask(201:398,216:338);
% cd /Users/dlizarbe/Documents/DANIEL/croco_tools
% start
% cd /Volumes/BM_2022_x/Hindcast_1990_2010
zz=get_depths(fn,fn,1,'rho'); %we get the depths using all the rho variables
zww=get_depths([path1,filename],[path1,filename],st,'w'); %we get the depths using all the wi variables

%zz=permute(zz,[3 2 1]).*mask;

v=ncread(fn,'v'); 
vv=permute(v,[3 2 1 4]);

jj=0;
for ii=-50:-10:-500
    jj=jj+1;
    vnew(:,:,jj) = vinterp(vv,zz,ii);
    disp(ii)
end

Z=[-50:-10:-500]';
indxlat = find(LAT(1,:)>= -6 & LAT(1,:)<=-3);
indxlon = find(LON(:,1)>= -85 & LON(:,1)<=-80);

Vmean = permute(mean(vnew(indxlat,indxlon,:),1,'omitnan'),[2 3 1]);
%% plot V
distance_km = calculate_longitudinal_distance(-4.5,5);

%dist=flip(linspace(0,distance_km*-1,length(LON(:,1))));
Er=6371000; % earth radius

% calculate distance from coast
%dist = deg2km(5, Er*10^-3*cos(deg2rad(-4.5)));
disti = flip(linspace(0,distance_km,size(Vmean,1)));
%% 
[c,h]=contourf(disti,Z,Vmean'.*100,[-12:1:12],'linestyle','none');colorbar;
cmocean('balance',21);
caxis([-10 10]); %xlim([-85 -80]);
set(gca, 'XDir','reverse'); xlim([0 250]);
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));

%% 
yr=1990:2001;
mo=1:12;

z=zeros(length(s_rho),size(LON,2),size(LON,1),length(mo)*length(yr),'single'); %between layers - 32
zw=zeros(length(s_w),size(LON,2),size(LON,1),length(mo)*length(yr),'single'); %edge of layers - 33

jj=0; 
for iy=yr(1):1:yr(end)
    
    for imo=mo(1):1:mo(end)
        jj=jj+1;
        filename=sprintf('croco_avg_Y%dM%d.nc',iy,imo);
        disp(filename)
        
        for st=1:1:timestep
         
            zz(:,:,:,st)=get_depths([path1,filename],[path1,filename],st,'rho'); %we get the depths using all the rho variables           
            zww(:,:,:,st)=get_depths([path1,filename],[path1,filename],st,'w'); %we get the depths using all the wi variables
            
            disp(st)
        end
        z(:,:,:,jj)=mean(zz,4,'omitnan');
        zw(:,:,:,jj)=mean(zww,4,'omitnan');
        clear zz zww
    end
end
%% 
times=linspace(1990,2001,length(mo)*length(yr));
save('Depth_points.mat','z','zw','times');

