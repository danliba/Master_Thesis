load('CUTI_1D.mat')
load('CUTI_HR.mat')
%% 
%ylab ={'20S','18S','16S','14S','12S','10S','8S','6S','4S'} ;
ylab={'20S','15S','10S','5S'};

figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*2.2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(2,1,2)
[c,h]=contourf(time2,latCUTI,Mean_CUTI_HR,[-30:0.1:30]);colorbar; 
cmocean('balance',21); set(h,'LineColor','none'); clabel(c,h);
title('Monthly CUTI Index','fontsize',22); 
ax = gca;
ax.FontSize = 24;
ylabel('Latitude'); xlabel('Time');
ax = gca;
ax.FontSize = 24; 
caxis([-10 10]);
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String='m^{2}/s';
c.Label.FontSize = 24;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);


subplot(2,1,1)
[c,h]=contourf(time2,latiCUTI,Mean_CUTI,[-30:0.1:30]);colorbar; 
cmocean('balance',21); set(h,'LineColor','none'); clabel(c,h);
title('Monthly CUTI 1 degree','fontsize',22); 
ax = gca;
ax.FontSize = 24;
ylabel('Latitude'); xlabel('Time');
ax = gca;
ax.FontSize = 24; 
caxis([-10 10]);
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String='m^{2}/s';
c.Label.FontSize = 24;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);

%% 
ylab = generateYLabels();

subplot(1,2,2)
plot(CUTI_latitudinal,latCUTI,'mo-','markerfacecolor','m');
ylabel('Latitude','fontsize',14); xlabel('Transport m^{2}s^{-1}','fontsize',14);
ax = gca;
ax.FontSize = 20; grid on; title('LTM CUTI index');
 ylim([-20 -5]);
set(gca,'ytick',[-20:1:-5],'yticklabel',ylab,'ylim',[-20 -5]);

subplot(1,2,1)
plot(CUTI_latitudinal_LR,latiCUTI,'mo-','markerfacecolor','m');
ylabel('Latitude','fontsize',14); xlabel('Transport m^{2}s^{-1}','fontsize',14);
ax = gca;
ax.FontSize = 20; grid on; title('LTM CUTI 1 degree');
set(gca,'ytick',[-20:1:-5],'yticklabel',ylab,'ylim',[-20 -5]);


