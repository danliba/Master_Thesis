cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BEUTI/;
load('BEUTI_1D.mat');
load('BEUTI_HR.mat');
%%
ylab={'20S','15S','10S','5S'};

figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*2.2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(2,1,2)
[c,h]=contourf(time2,latCUTI,Mean_BEUTI_HR,[-700:1:700]);colorbar; 
cmocean('balance',21); set(h,'LineColor','none'); clabel(c,h);
title('Monthly BEUTI','fontsize',22); 
ax = gca;
ax.FontSize = 24;
ylabel('Latitude'); xlabel('Time');
ax = gca;
ax.FontSize = 24; 
caxis([-160 160]);
ticks = -160:40:160;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mu mol \cdot m^{-1} \cdot s^{-1}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 24;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);


subplot(2,1,1)
[c,h]=contourf(time2,latiCUTI,Mean_BEUTI,[-700:1:700]);colorbar; 
cmocean('balance',21); set(h,'LineColor','none'); clabel(c,h);
title('Monthly BEUTI 1 degree','fontsize',22); 
ax = gca;
ax.FontSize = 24;
ylabel('Latitude'); xlabel('Time');
ax = gca;
ax.FontSize = 24; 
caxis([-160 160]);
ticks = -160:40:160;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mu mol \cdot m^{-1} \cdot s^{-1}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 24;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);

