%clc,clear
cd /Volumes/BM_2022_x/Hindcast_1990_2010
addpath /Volumes/BM_2022_x/Hindcast_1990_2010
addpath /Volumes/BM_2022_x/CDT-master/cdt


path1='./';
dir1=dir([path1,'croco*.nc']);
%% first year 1990
hdir=[dir1(1:12)];
fn='croco_avg_Y1990M2.nc';

%% 
timestep=10 %3 day average per month
month=12 % months
yr=2% year
n=3
%band=24
%ncdisp([path1,dir1(n).name]); 
LON=ncread([path1,hdir(n).name],'lon_rho'); %lon lat s_rho time
LAT=ncread([path1,hdir(n).name],'lat_rho');
s_rho=ncread([path1,hdir(n).name],'s_rho'); 
s_w=ncread([path1,hdir(n).name],'s_w'); 

mask=ncread([path1,hdir(n).name],'mask_rho');

z=zeros(32,size(LON,2),size(LON,1),timestep*month*yr,'single'); %between layers - 32
zw=zeros(33,size(LON,2),size(LON,1),timestep*month*yr,'single'); %edge of layers - 33

%mask2=mask(201:398,216:338);

cd /Users/dlizarbe/Documents/DANIEL/croco_tools
start
cd /Volumes/BM_2022_x/Hindcast_1990_2010
%-------------read data--------------%
for n=1:month*yr
    n1=(n-1)*timestep+1;
    n2=n*timestep;
    for st=1:timestep
    [z(:,:,:,n1+st-1)]=get_depths([path1,hdir(n).name],[path1,hdir(n).name],st,'rho'); %we get the depths using all the rho variables
    [zw(:,:,:,n1+st-1)]=get_depths([path1,hdir(n).name],[path1,hdir(n).name],st,'w'); %we get the depths using all the wi variables
    end      

    n
end

%% corrupted 1992M8 is corrupted

Z=permute(z,[2 3 1 4]);

Z(Z>=-0.6253)=NaN;

aviobj = QTWriter('Z.mov','FrameRate',2);%aviobj.Quality = 100;
figure
for ii=1:1:size(Z,3)
    zi=Z(:,:,ii,1);
    pcolor(LON,LAT,zi');shading flat; colorbar;
    title(['S_rho layer' num2str(s_rho(ii))]);
    hold on
    borders('peru')
    M1=getframe(gcf);
    writeMovie(aviobj, M1);
    pause(0.5)
    clf
end

close(aviobj);
%% 

Zw=permute(zw,[2 3 1 4]);

%Z(Z>=-0.6253)=NaN;

figure
for ii=1:1:size(Zw,3)
    zwi=abs(Zw(:,:,ii,1));
    pcolor(LON,LAT,zwi');shading flat; colorbar;
    title(['w layer ' num2str(s_w(ii))])
    hold on
    borders('peru'); %caxis([0 2000])
    pause(1)
    clf
end

%% let calculated the integrated phytoplankton biomass in the water masses
% biomas array has to be the same size as the zw

sphyto=ncread(fn,'SPHYTO');
lphyto=ncread(fn,'LPHYTO');

biomass=sphyto+lphyto; 
biomass=permute(biomass,[3 2 1 4]);

z01=-1500; z02=-1;
%[bio] = integrate_cal(biomass(:,:,:,1),zw(:,:,:,1),z(:,:,:,1),z01,z02);

for icroco=1:1:size(biomass,4)
    [bio(:,:,:,icroco),h0(:,:,:,icroco)]=vintegr2(biomass(:,:,:,icroco),zw(:,:,:,icroco),z(:,:,:,icroco),z01,z02);
    disp(icroco)
end

%% figure
year=fn(12:15); mo=fn(17:18); days=[3:3:30];

h0(h0==0)=NaN;
bio(bio<=0)=NaN;

figure
P=get(gcf,'position');
P(3)=P(3)*2.5;
P(4)=P(4)*2.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

for ii=1:1:size(bio,4)
    subplot(1,2,1)
    pcolor(LON,LAT,bio(:,:,:,ii)'); shading flat;
    hold on; colorbar; %caxis([-10 40]);
    borders('peru','facecolor','black');
    title('Integrated Biomass 1m to 1500m');
    disp([year '/' mo '/' num2str(days(ii))])
    
    subplot(1,2,2)
    pcolor(LON,LAT,h0(:,:,:,ii)'); shading flat;
    hold on; colorbar; %caxis([-10 40]);
    borders('peru','facecolor','black')
    title('H0 layer thickness');
    
    pause(0.5)
    clf
end
%% Avances para manana
% Extract MLD--done
% Extract velocity--done
% make videos of the whole time series and Hovmoller plot -- in progress 
% correct the corrupted file


