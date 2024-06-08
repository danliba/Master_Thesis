a=openfig('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/CUTI/CUTI_1degree/clim_CUTI_1deg.fig','new');
b=openfig('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/CUTI/clim_CUTI.fig');
%%
ylab={'20S','15S','10S','5S'};
xlab={'J','F','M','A','M','J','J','A','S','O','N','D'};

figure;
% Create subplot with two rows and one column
subplot(1, 2, 1);
% Copy the first figure into the subplot
copyobj(allchild(get(a, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',41);
title('CUTI 1 degree Climatology','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Months');
caxis([-10 10]);
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String='m^{2}/s';
c.Label.FontSize = 18;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);

% Create subplot with two rows and one column
subplot(1, 2, 2);
% Copy the second figure into the subplot
copyobj(allchild(get(b, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',41);
title('CUTI Climatology','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Months');
caxis([-10 10]);
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String='m^{2}/s';
c.Label.FontSize = 18;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);

