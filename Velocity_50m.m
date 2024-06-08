%% GET the W velocity at 50m depth 

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

%% lets get the vertical velocity at 50m 

w=ncread([path1,dir1(1).name],'w'); 
ww=permute(w,[3 2 1 4]);


wnew = vinterp(ww(:,:,:,1),z(:,:,:,1),50);

pcolor(LON,LAT,wnew'.*mask); shading flat; colorbar;
title('W velocity at 50m depth');

%% now the MLD----correct it

mld=ncread([path1,dir1(1).name],'hbl'); 

MLD=squeeze(mld(:,:,1));
pcolor(LON,LAT,MLD.*mask); shading flat; colorbar;
title('MLD');

%% 
arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/15mn.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

ind1=inpolygon(LON,LAT,lonb1,latb1);

%ii1=double(repmat(ind1,1,size(velint,3)));ii1(ii1==0)=NaN;

%pcolor(LON,LAT,double(ind1));shading flat;

% w=ncread([path1,dir1(1).name],'w'); 
% ww=permute(w,[3 2 1 4]);
% 
% 
% wnew = vinterp(ww(:,:,:,1),z(:,:,:,1),50);

wcut=wnew'.*mask.*ind1;
wcut(wcut==0)=NaN;

pcolor(LON,LAT,wcut); shading flat; colorbar;
title('W velocity at 50m depth');
xlim([-90 -70]);

aa=nanmean(wcut,1)';
plot(LAT(1,:),aa);

%% some hovmoller plots
%----------- W velocity at 50m -----------%

jj=0;
for iy=yr(1):1:yr(end)
    
    for imo=mo(1):1:mo(end)
        
        filename=sprintf('croco_avg_Y%dM%d.nc',iy,imo);
        disp(filename)
        
        for st=1:1:timestep
            jj=jj+1;
%             [z(:,:,:,jj)]=get_depths([path1,filename],[path1,filename],st,'rho'); %we get the depths using all the rho variables
%             [zw(:,:,:,jj)]=get_depths([path1,filename],[path1,filename],st,'w'); %we get the depths using all the wi variables
            w=ncread([path1,filename],'w'); 
            ww=permute(w,[3 2 1 4]);
            wnew= vinterp(ww(:,:,:,st),z(:,:,:,jj),50);
            
            wcut=wnew'.*mask.*ind1;
            wcut(wcut==0)=NaN;
            w_cum(:,jj)=nanmean(wcut,1)';
            disp(st)
        end
    end
end
%% plotting
%---- days ----%

times=linspace(1990,1992,240);

figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*2.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

pcolor(times,LAT(1,:),w_cum);shading flat;
ylim([-25 -3]);ylabel('Latitude','fontsize',15); xlabel('time','fontsize',15);
title('3 day average W velocity at 50m depth, 15nm off the coast','fontsize',15); 
cmocean balance; colorbar;

% print('hov_w_50m.png','-dpng','-r500');

%% Now MLD

jj=0;
for iy=yr(1):1:yr(end)
    
    for imo=mo(1):1:mo(end)
        
        filename=sprintf('croco_avg_Y%dM%d.nc',iy,imo);
        disp(filename)
        
        for st=1:1:timestep
            jj=jj+1;
%             [z(:,:,:,jj)]=get_depths([path1,filename],[path1,filename],st,'rho'); %we get the depths using all the rho variables
%             [zw(:,:,:,jj)]=get_depths([path1,filename],[path1,filename],st,'w'); %we get the depths using all the wi variables
            mld=ncread([path1,filename],'hbl'); 
           
            mld_new= squeeze(mld(:,:,st));
            
            mldcut=mld_new.*mask.*ind1;
            mldcut(mldcut==0)=NaN;
            mld_cum(:,jj)=nanmean(mldcut,1)';
            disp(st)
        end
    end
end
%% plot
figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*2.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

pcolor(times,LAT(1,:),mld_cum);shading interp;
ylim([-25 -3]);ylabel('Latitude','fontsize',15); xlabel('time','fontsize',15);
title('3 day average MLD, 15nm off the coast','fontsize',15); 
cmocean balance; colorbar;


