%% Estimating width and vertical velocity for a wind-driven upwelling zone along an eastern boundary

% Sample density profile (example data)
depth = [0, 10, 20, 30, 40, 50];  % Depth in meters
density = [1025, 1024, 1023.5, 1023, 1022.5 1020];  % Density in kg/m^3

% Calculate density gradient
density_gradient = gradient(density) ./ gradient(depth);

% Manually specify threshold density gradient
threshold_gradient = 0.05;  % Adjust as needed

% Find the depth range associated with the upper layer
upper_layer_depth_range = depth(abs(density_gradient) > threshold_gradient);

% Calculate thickness of the upper layer
upper_layer_thickness = max(upper_layer_depth_range) - min(upper_layer_depth_range);
%% 
path1='./';
fn='Mean_Y1990M2.nc';

z=get_depths([path1,fn],[path1,fn],1,'rho'); %we get the depths using all the rho variables

temp=double(ncread(fn,'temp'));
salt=double(ncread(fn,'salt'));
LON=ncread([path1,fn],'lon_rho'); %lon lat s_rho time
LAT=ncread([path1,fn],'lat_rho');
% pt = theta(sal,temp,abs(z),0);
sigma=sigmat(temp,salt);

for ilon=1:1:size(LON,1)
    for ilat=1:1:size(LAT,2)
        
        tt=squeeze(sigma(ilon,ilat,:));
        zz=squeeze(z(:,ilat,ilon));
        zz=zz(18:32);
        %plot(squeeze(sigma(1,1,:)),squeeze(z(:,1,1)));
        
        grad=gradient(tt(18:32),zz);
        if sum(grad)==0
            upperlayer(ilon,ilat)=NaN;
            lowerlayer(ilon,ilat)=NaN;
        else
            upperlayer(ilon,ilat)=zz(find(max(grad)==grad));
            lowerlayer(ilon,ilat)=zz(find(min(grad)==grad));
        end
    end
    disp(ilon)
end