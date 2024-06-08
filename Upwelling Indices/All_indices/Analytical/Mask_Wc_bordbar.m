%% Creating a mask of 100km
load('WC_mean.mat');

clear c;
X=x.*mask;

%% 
range0=[-115 -70 -33 10];
loni=LON(:,1); lati=LAT(1,:);

maskWc=double(range0(1)<=loni & loni<=range0(2) &...
    range0(3)<=lati & lati<=range0(4));
maskWc(maskWc==0)=NaN;


[lonk, latk]=Extract_CoastLine(X.*maskWc, loni, lati,600); %150 km

% compute the distance between neighboring two points along the
% Kuroshio Axis
% dx=distance(latk(2:end),lonk(2:end),latk(1:end-1),lonk(1:end-1)).*60.*1852;
% % compute the distance from the north of Taiwan by cumulative sum
% distx=cat(2,0,cumsum(dx));
% 
% % Because defined Kuroshio axis by Extract_KuroshioAxis.m is
% % irregular in its distance, now the lon and lat along the axis is
% % interpolated with respect to the distance, with the uniform
% % distance resolution
% disti=0:5000:6e7;
% 
% lonki=interp1(distx,lonk,disti);
% latki=interp1(distx,latk,disti);
% 
% plot(lonki,latki,'.');
% hold on
% plot(lonk,latk,'r');
% 
% % Perform interpolation
% latki_interp = interp1(1:numel(latki), latki, linspace(1, numel(latki), numel(lati)));
% lonki_interp = interp1(1:numel(lonki), lonki, linspace(1, numel(lonki), numel(loni)));


%% convert to KML
% Sample latitude and longitude data
latitude = cat(2,latk,latk(1)); % Example latitude values
longitude = cat(2,lonk,lonk(1)+40); % Example longitude values

% Create a KML file
%filename = 'Peru_100km.kml';
% fid = fopen(filename, 'w');
% fprintf(fid, '<?xml version="1.0" encoding="UTF-8"?>\n');
% fprintf(fid, '<kml xmlns="http://www.opengis.net/kml/2.2">\n');
% fprintf(fid, '<Document>\n');
% fprintf(fid, '<name>Placemark Export</name>\n');
% 
% % Write placemarks for each coordinate
% for i = 1:numel(latitude)
%     fprintf(fid, '<Placemark>\n');
%     fprintf(fid, '<name>Point %d</name>\n', i);
%     fprintf(fid, '<Point>\n');
%     fprintf(fid, '<coordinates>%f,%f,0</coordinates>\n', longitude(i), latitude(i));
%     fprintf(fid, '</Point>\n');
%     fprintf(fid, '</Placemark>\n');
% end
% 
% % Close KML tags and file
% fprintf(fid, '</Document>\n');
% fprintf(fid, '</kml>\n');
% fclose(fid);
% 
% % Display confirmation message
% disp(['KML file saved as: ' filename]);

% Create a KML file
filename = 'BK600km.kml';
fid = fopen(filename, 'w');
fprintf(fid, '<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(fid, '<kml xmlns="http://www.opengis.net/kml/2.2">\n');
fprintf(fid, '<Document>\n');
fprintf(fid, '<name>Polygon Export</name>\n');

% Write the polygon geometry to the KML file
fprintf(fid, '<Placemark>\n');
fprintf(fid, '<name>Polygon</name>\n');
fprintf(fid, '<Polygon>\n');
fprintf(fid, '<outerBoundaryIs>\n');
fprintf(fid, '<LinearRing>\n');
fprintf(fid, '<coordinates>\n');
for i = 1:numel(longitude)
    fprintf(fid, '%f,%f,0\n', longitude(i), latitude(i));
end
fprintf(fid, '</coordinates>\n');
fprintf(fid, '</LinearRing>\n');
fprintf(fid, '</outerBoundaryIs>\n');
fprintf(fid, '</Polygon>\n');
fprintf(fid, '</Placemark>\n');

% Close KML tags and file
fprintf(fid, '</Document>\n');
fprintf(fid, '</kml>\n');
fclose(fid);

% Display confirmation message
disp(['KML file saved as: ' filename]);
%% 
east_indices = loni > lonk;
masknan=double(rot90(east_indices));
masknan(masknan==0)=NaN;

figure; pcolor(masknan);shading flat;
%we create a latk
latk2 = interp1(1:numel(latk), latk, linspace(1, numel(latk), numel(loni)));

[Xi,Yi]=meshgrid(lonk,latk2);

mask_interp = interp2(Xi, Yi, masknan', LON', LAT', 'linear')';


Wc_interp = interp2(LON', LAT',Wc_mean',Xi, Yi,'linear')';

figure; pcolor(Xi,Yi,Wc_interp');shading flat; colorbar;
figure; pcolor(LON,LAT,Wc_mean);shading flat; colorbar;


%% 
% [lonki,latki]=meshgrid(lonk,latk);
% tf=double(island(lonki,latki));
% 
% pcolor(lonki,latki,tf);shading flat;
% %% 
% % now create a mask 
% loni=LON(:,1);
% xi = 1:numel(lonk);  % Indices of lonk
% xq = linspace(1, numel(lonk), numel(LAT(1,:)));  % Indices for interpolated values
% 
% % Perform linear interpolation
% lonk_interpolated = interp1(xi, lonk, xq, 'linear');
% 
% 
% %% 
% east_indices = loni > lonk_interpolated;
% masknan=double(rot90(east_indices));
% masknan(masknan==0)=NaN;
% 
% resized_mask = imresize(masknan, [542,602]);
% 
% figure; pcolor(LON,LAT,masknan'.*mask);shading flat; colorbar;
% 
% [lonis,lonkis]=meshgrid(loni,lonk);
% maski = interp2(lonis, lonkis, masknan', LON', LAT', 'linear')';
% 
% %% 
% pcolor(LON,LAT,Wc.*mask.*resized_mask'); shading flat; colorbar;
% caxis([-8*10^-4 8*10^-4]);
% hold on
% [c,h]=contour(LON,LAT,x.*mask,[100 100],'k'); 
% clabel(c,h);
% axis([-90 -70 -33 10]); 

%% 

arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/BK200nm.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

ind1=double(inpolygon(LON,LAT,lonb1,latb1));
ind1(ind1==0)=NaN;
pcolor(LON,LAT,Wc_mean.*ind1.*mask);shading flat;

%%
figure
[c,h]=contourf(LON,LAT,Wc_mean.*86400.*mask.*ind1,[-10:0.2:2]);shading flat; colorbar; 
cmocean('balance',13); set(h,'LineColor','none');
title('Mean Wc transport velocity','fontsize',16); 
caxis([-1.6 1.6]);
hold on
[c,h]=contour(LON,LAT,x.*mask,[100 100],'k','linewidth',2); 
clabel(c,h);
axis([-90 -70 -33 10]);

%% 
Wc_shore=Wc_mean.*mask.*ind1;

figure
[c,h]=contourf(LON,LAT,Wc_shore.*86400,[-10:0.2:2]);shading flat; colorbar; 
cmocean('balance',13); set(h,'LineColor','none');
title('Long term Mean of Wc transport velocity','fontsize',16); 
caxis([-1.6 1.6]);
hold on
[c,h]=contour(LON,LAT,x.*mask,[100 100],'k','linewidth',2); 
clabel(c,h);
axis([-90 -70 -33 10]);

save('Wc_shore.mat','Wc_shore','LON','LAT','Wc_mean','x','mask');
