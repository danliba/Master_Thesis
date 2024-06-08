a=openfig('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/All_indices/climatology/Analytical_vel.fig');
b=openfig('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/All_indices/climatology/BUI_clim.fig');
cc=openfig('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/All_indices/climatology/CUTI_clim_UI.fig');
d=openfig('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/All_indices/climatology/BEUTI_clim_UI.fig');
e=openfig('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/All_indices/climatology/CUI_SST_clim.fig');
f=openfig('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/All_indices/climatology/HUI_climato.fig');
%% ------ Plotting ------ %% 

timeclim=1:12;
ylab={'20S','15S','10S','5S'};
xlab={'J','F','M','A','M','J','J','A','S','O','N','D'};

figure
% ---- Analytical Velocity ---- %
subplot(2, 3, 1);
copyobj(allchild(get(a, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',13);
title('Analytical Velocity','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Month');
caxis([-3 3]);
ticks = -3:1:3;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);

%--- Bakun Index ----%
subplot(2,3,2);
copyobj(allchild(get(b, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',17);
title('Bakun Index','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Month');
caxis([-2 2]);
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = 'm$^{2}$/s';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);

%--- CUTI ----%
subplot(2,3,3);
copyobj(allchild(get(cc, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',21);
title('CUTI','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Month');
caxis([-10 10]);
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = 'm$^{2}$/s';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);

%---- BEUTI ---- %
subplot(2,3,4);

copyobj(allchild(get(d, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',21);
title('BEUTI','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Month');
caxis([-100 100]);
ticks = -100:20:100;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$mmol \cdot m^{-1} \cdot s^{-1}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);

% ----- CUI ------%
subplot(2,3,5)
copyobj(allchild(get(e, 'CurrentAxes')), gca);
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Month');
colorbar; cmocean('balance',21);
caxis([-10 10])
title('CUI');
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$^\circ C$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);

% ---- HUI ----% 
subplot(2,3,6)
copyobj(allchild(get(f, 'CurrentAxes')), gca);
caxis([-3 3]); cmocean('balance',13); colorbar;
title('HUI'); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Month');
ticks = -3:1:3;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);

