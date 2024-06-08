%% Mean costal angle 200 nm
load('Wc_mean.mat'); %Wc
arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

ind1=double(inpolygon(LON,LAT,lonb1,latb1));
ind1(ind1==0)=NaN;

x=dist2coast(LAT,LON);
[dx, dy] = gradient(x);
coastline_orientation_angle = atan2(dy, dx);
%%
pcolor(LON,LAT,coastline_orientation_angle.*mask);shading flat;
title('Coastline orientation angle (radians)','fontsize',16);
ax = gca;
ax.FontSize = 16;
%%
lati=LAT(1,:); loni=LON(:,1);
indxlat=find(lati>=-15 & lati<=-5);
new_costline_angle=coastline_orientation_angle.*ind1.*mask;

cut_coastline_angle=new_costline_angle(:,indxlat);

pcolor(loni,lati(indxlat),rad2deg(cut_coastline_angle'));shading flat;
xlim([-90 -70]);

%Mean costal angle 150 nm
%degrees 
mean_coastal_angle=rad2deg(nanmean(nanmean(cut_coastline_angle)));
disp(mean_coastal_angle);
%% create an array with 2 angles as it shifts. First 5 to 15 is -111.7578 and 
% 15 to 20 is -113.2616
