cd /Volumes/BM_2022_x/Hindcast_1990_2010;
%% 
clear all;close all;clc

path01='/Volumes/BM_2022_x/Hindcast_1990_2010';
hdir=dir(fullfile(path01,'c*'));



%for icroco=1:1:size(hdir,1)
    icroco=1;
    fn=hdir(icroco).name;
    
    time=double(ncread(fn,'time'));
    xi_rho=double(ncread(fn,'xi_rho')); %x-grid
    eta_rho=double(ncread(fn,'eta_rho')); % y grid
    s_rho=double(ncread(fn,'s_rho')); %represents the vertical variations in density (by using buoyancy frequency to define the vertical layers).
    %S(end) is the surface and S(1) is the bottom
    h=double(ncread(fn,'h')); %theoretical surface that would coincide with mean sea level in the absence of tides

    lat_rho=double(ncread(fn,'lat_rho'));
    lon_rho=double(ncread(fn,'lon_rho'));
    sal=double(ncread(fn,'salt')); %lon,lat,sigma layer (s_rho),

%%
sal(sal==0)=NaN;

figure
for ii=length(s_rho):-1:1
    pcolor(lon_rho,lat_rho,sal(:,:,ii,1)); shading flat;
    caxis([33 35.5]);
    colorbar;
    pause(1)
    clf
end

    %% 
    figure
    pcolor(lon_rho,lat_rho,h); shading flat; colorbar; title('Bathymetry at RHO-points')
    





    
    



%end
%% 
%addpath /Users/txue/Nextcloud/Functions
% %path1='./';
% dir1=dir([path01,'croco*.nc']);
% timestep=1
% month=12
% yr=5
% n=1
% band=24
% z=zeros(32,464,398,timestep*month*yr,'single');
% zw=zeros(33,464,398,timestep*month*yr,'single');
% ncdisp([path01,hdir(n).name]); 
% LON=ncread([path1,dir1(n).name],'lon_rho');
% LAT=ncread([path1,dir1(n).name],'lat_rho');
% mask=ncread([path1,dir1(n).name],'mask_rho');
% mask2=mask(201:398,216:338);
% 
% 
% %-------------read data--------------%
% for n=1:month*yr
%     n1=(n-1)*timestep+1;
%     n2=n*timestep;
%     for st=1:timestep
%     [z(:,:,:,n1+st-1)]=get_depths([path1,dir1(n).name],[path1,dir1(n).name],st,'rho');
%     [zw(:,:,:,n1+st-1)]=get_depths([path1,dir1(n).name],[path1,dir1(n).name],st,'w');
%     end      
% 
%     n
% end
