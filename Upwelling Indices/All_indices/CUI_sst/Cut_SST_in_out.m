load('/Volumes/BM_2022_x/Hindcast_1990_2010/inout/WC_mean.mat');
filename = 'BK111km.kml';
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/SST
create_KML_polygon(x, LON, LAT, filename, 111);
%% 
arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/SST/BK600km.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

arch_kml_zona2='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/SST/BK500km.kml';
R2=kml2struct(arch_kml_zona2); lonb2=R2.Lon; latb2=R2.Lat;


plot(lonb1,latb1);
hold on
plot(lonb2,latb2);
