fn='Mean_Y1990M3.nc';
uwind=double(ncread(fn,'sustr'));
vwind=double(ncread(fn,'svstr'));
[Xu,Yu]=meshgrid(LON(1:end-1,1), LAT(1,:));
[Xv,Yv]=meshgrid(LON(:,1), LAT(1,1:end-1));

U = interp2(Xu, Yu, uwind', LON', LAT', 'linear')'; %m/s
%regrid vwind
V = interp2(Xv, Yv, vwind', LON', LAT', 'linear')'; %m/s

quiversc(LON,LAT,U,V);