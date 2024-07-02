clear all; close all; clc;
cd /Users/dlizarbe/Documents/DANIEL/2001_2010
[mask,LON,LAT,path1]=lets_get_started;
%% 
cd /Users/dlizarbe/Documents/DANIEL/2001_2010

load('MLD_W');
Wmld_mean=mean(Wmld,3,'omitnan').*86400;
%Wmld_mean=mean(Wmld,3,'omitnan');
wind_mean=mean(wind,3,'omitnan');

load('Mean_199709_2010_chlor')
load('/Users/dlizarbe/Documents/DANIEL/winds/Ekman_winds.mat')
load('Z_2002_2010.mat')

WE_mean=wE_mean.*86400;

[LONi,LATi]=meshgrid(loni,lati);
Humboldt_ports
long_degrees=5;%around 500km
%% 
figure
P=get(gcf,'position');
P(3)=P(3)*1.2;
P(4)=P(4)*2.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(LON',LAT',Wmld_mean.*mask',[-3:0.2:3]);colorbar;
set(h,'LineColor','none');
title('Long-term mean of ocean (2002-2010) W velocity at MLD','fontsize',16); 
cmocean('balance',13);
caxis([-1.6 1.6]);
hold on
quiversc(loni,lati,U_mean',V_mean','k');hold on;
[c,h]=contour(lon,lat,chloro',[0.5 2 5 10],'g','linewidth',2);
clabel(c,h);
borders('countries','facecolor','white');
axis([-90 -70 -33 10]); 
ax = gca;
ax.FontSize = 16; 
c=colorbar;
c.Label.String='m/day';
hold on

for i = 1:length(Puertos)
    key = Puertos{i,1}; % Get port name
    x = Puertos{i,2}(2); % Get longitude
    y = Puertos{i,2}(1); % Get latitude
    plot(x,y,'ko--','markerfacecolor','m');
    text(x+0.2, y, key, 'FontSize', 12); % Plot text
    xx=[floor(x)-long_degrees,x];
    yy=[y-0.2, y+0.2];
    hold on
    plot_square(xx(1),xx(2)-0.2,yy(1),yy(2));
    xsq{i,1}=xx; ysq{i,1}=yy;
    distance_km(i,1) = calculate_longitudinal_distance(Puertos{i,2}(1),long_degrees);%lat, long_degrees
end
%% %% let's create a struct
port_names = Puertos(:, 1);
num_ports = numel(port_names);
ports = struct; % Initialize empty struct

for i = 1:num_ports
    port_name = port_names{i};
    ports.(port_name) = struct; % Create empty struct with port name as field
end
%% lets extract the variables 400km from the coast
%[xi,yi]=create_square(xsq{ii,1}(1), xsq{ii,1}(2),ysq{ii,1}(1), ysq{ii,1}(2));

for ii=1:1:numel(port_names)
    
    %---- find the area W_mld
    indxlon_wmld=find(LON(:,1)>=xsq{ii,1}(1) & LON(:,1)<=xsq{ii,1}(2));%
    indxlat_wmld=find(LAT(1,:)>=ysq{ii,1}(1) & LAT(1,:)<=ysq{ii,1}(2));
    %Winds
    indxloni=find(loni>=xsq{ii,1}(1) & loni<=xsq{ii,1}(2));%
    indxlati=find(lati>=ysq{ii,1}(1) & lati<=ysq{ii,1}(2));
    %chlor
    indxlon=find(lon>=xsq{ii,1}(1) & lon<=xsq{ii,1}(2));%
    indxlat=find(lat>=ysq{ii,1}(1) & lat<=ysq{ii,1}(2));
    %Ekman upwelling velocity
    indxlon_wE=find(LONi(1,:)>=xsq{ii,1}(1) & LONi(1,:)<=xsq{ii,1}(2));%
    indxlat_wE=find(LATi(:,1)>=ysq{ii,1}(1) & LATi(:,1)<=ysq{ii,1}(2));
    
    %cut the variable
    Wmld_port=mean(Wmld_mean(indxlat_wmld,indxlon_wmld),1,'omitnan'); %W_mld
    V_port=V_mean(indxloni,indxlati);%v wind
    chlor_port=mean(chloro(indxlon,indxlat),2,'omitnan');%chlor
    WE_port=mean(WE_mean(indxlat_wE,indxlon_wE),1,'omitnan')';%ekman
    
    %z 
    cut_z=Z_mean(indxlat_wmld,indxlon_wmld,:);
    Z_port=mean(squeeze(mean(cut_z,1,'omitnan')),2); %W_mld
    
    %distance to coast
    dist_wmld=flip(linspace(0,distance_km(ii),length(Wmld_port)));
    dist_wind=flip(linspace(0,distance_km(ii),length(V_port)));
    dist_chlor=flip(linspace(0,distance_km(ii),length(chlor_port)));
    dist_ekman=flip(linspace(0,distance_km(ii),length(WE_port)));
    dist_Z=flip(linspace(0,distance_km(ii),length(Z_port)));
    
    % depth
    
%     plot(dist,Wmld_port);
%     set(gca, 'XDir','reverse'); xlim([0 400]);
    
    %fieldnames
    fieldName1 = 'Wmld';
    fieldName2 = 'Vwind';
    fieldName3 = 'chlor';
    fieldName4 = 'wE';
    fieldName5 = 'dist_wmld';
    fieldName6 = 'dist_wind';
    fieldName7 = 'dist_chlor';
    fieldName8 = 'dist_ekman';
    fieldName9 = 'Z';
    fieldName10 = 'dist_Z';
    %struct
    ports.(port_names{ii, 1}).(fieldName1)=Wmld_port;
    ports.(port_names{ii, 1}).(fieldName2)=V_port;
    ports.(port_names{ii, 1}).(fieldName3)=chlor_port;
    ports.(port_names{ii, 1}).(fieldName4)=WE_port;
    ports.(port_names{ii, 1}).(fieldName5)=dist_wmld;
    ports.(port_names{ii, 1}).(fieldName6)=dist_wind;
    ports.(port_names{ii, 1}).(fieldName7)=dist_chlor;
    ports.(port_names{ii, 1}).(fieldName8)=dist_ekman;
    ports.(port_names{ii, 1}).(fieldName9)=Z_port;
    ports.(port_names{ii, 1}).(fieldName10)=dist_Z;
    
end

%% 
%pcolor(LON(indxWmld_lon,1),LAT(1,indxWmld_lat),Wmld_mean(indxWmld_lat,indxWmld_lon)); shading flat;
save('ports_Z.mat','ports');
