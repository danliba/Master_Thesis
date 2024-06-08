a=openfig('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BEUTI/BEUTI_1D_clim.fig','new');
b=openfig('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BEUTI/BEUTI_clim.fig');
%%
ylab={'20S','15S','10S','5S'};
xlab={'J','F','M','A','M','J','J','A','S','O','N','D'};

figure
P=get(gcf,'position');
P(3)=P(3)*2.5;
P(4)=P(4)*1.3;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');
% Create subplot with two rows and one column
subplot(1, 2, 1);
% Copy the first figure into the subplot
copyobj(allchild(get(a, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',21);
title('BEUTI 1 degree Climatology','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Months');
caxis([-100 100]);
ticks = -100:20:100;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mu mol \cdot m^{-1} \cdot s^{-1}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);

% Create subplot with two rows and one column
subplot(1, 2, 2);
% Copy the second figure into the subplot
copyobj(allchild(get(b, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',21);
title('BEUTI Climatology','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Months');
caxis([-100 100]);
ticks = -100:20:100;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mu mol \cdot m^{-1} \cdot s^{-1}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
