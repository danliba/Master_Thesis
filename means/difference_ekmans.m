%% difference between ekman winds and ekman stress 
load('Ekman_pump.mat');
load('Ekman_We_wind.mat');

diference = Mean_ekpump - Mean_We; %windstress - winds

figure
[c,h]=contourf(LON,LAT,diference.*86400.*mask,[-10:0.2:2]);shading flat; colorbar;
cmocean('balance',13); set(h,'LineColor','none');
title('Ekman Wind stress - Ekman Winds ','fontsize',16);
caxis([-0.5 0.5]);

