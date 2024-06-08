path1='./';
fn='mean.nc';

LON=ncread(fn,'lon_rho');
LAT=ncread(fn,'lat_rho');
s_rho=ncread(fn,'s_rho'); 
s_w=ncread(fn,'s_w'); 

mask=ncread(fn,'mask_rho');
mask(mask==0)=NaN;

%% 
timestep=1;
yr=2010;
mo=9;
st=1;

z=zeros(length(s_rho),size(LON,2),size(LON,1),timestep*length(mo)*length(yr),'single'); %between layers - 32
zw=zeros(length(s_w),size(LON,2),size(LON,1),timestep*length(mo)*length(yr),'single'); %edge of layers - 33

[z(:,:,:,1)]=get_depths([path1,fn],[path1,fn],st,'rho'); %we get the depths using all the rho variables
[zw(:,:,:,1)]=get_depths([path1,fn],[path1,fn],st,'w'); %we get the depths using all the wi variables
%% Velocity
w=ncread([path1,fn],'w'); 
ww=permute(w,[3 2 1 4]);


wnew = vinterp(ww,z,50);

pcolor(LON,LAT,wnew'.*mask); shading flat; colorbar;
title('W velocity at 50m depth'); cmocean delta

%% now the MLD----correct it

mld=ncread([path1,dir1(1).name],'hbl'); 

MLD=squeeze(mld(:,:,1));
pcolor(LON,LAT,MLD.*mask); shading flat; colorbar;
title('MLD');

