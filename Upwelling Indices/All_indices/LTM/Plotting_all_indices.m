a=openfig('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/All_indices/LTM/LTM_analytical.fig');
b=openfig('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/All_indices/LTM/BUI_LTM.fig');
cc=openfig('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/All_indices/LTM/LTM_CUTI_UI.fig');
d=openfig('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/All_indices/LTM/LTM_BEUTI_UI.fig');
e=openfig('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/All_indices/LTM/CUI_SST_LTM.fig');
f=openfig('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/All_indices/LTM/LTM_HUI2.fig');

%% ----- Plotting ------ %%

[~,ylab] = generateYLabels(20,5,5);
[~,xlab] = generateXLabels(90,70,5);

figure
% P=get(gcf,'position');
% P(3)=P(3)*2.5;
% P(4)=P(4)*1.3;
% set(gcf,'position',P);
% set(gcf,'PaperPositionMode','auto');
% ---- Analytical Velocity ---- %
subplot(2, 3, 1);
copyobj(allchild(get(a, 'CurrentAxes')), gca);
xlim([-90 -70]); cmocean('balance',13);
title('Analytical Velocity','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitudes');
caxis([-3 3]);
ticks = -3:1:3;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);

%--- Bakun Index ----%
subplot(2,3,2);
copyobj(allchild(get(b, 'CurrentAxes')), gca);
xlim([-90 -70]); cmocean('balance',17);
title('Bakun Index','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitudes');
caxis([-2 2]);
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = 'm$^{2}$/s';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);


%--- CUTI ----%
subplot(2,3,3); 
copyobj(allchild(get(cc, 'CurrentAxes')), gca);
xlim([-90 -70]); cmocean('balance',21);
title('CUTI','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitudes');
caxis([-10 10]);
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = 'm$^{2}$/s';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);

%---- BEUTI ---- %
subplot(2,3,4);

copyobj(allchild(get(d, 'CurrentAxes')), gca);
xlim([-90 -70]); cmocean('balance',21);
title('BEUTI','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitudes');
caxis([-100 100]);
ticks = -100:20:100;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mu mol \cdot m^{-1} \cdot s^{-1}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);

% ----- CUI ------%
subplot(2,3,5)
copyobj(allchild(get(e, 'CurrentAxes')), gca);
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
colorbar; cmocean('thermal',11);
caxis([16 26])
title('CUI');
ticks = 16:2:26;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$^\circ C$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);

% ---- HUI ----% 
subplot(2,3,6)
copyobj(allchild(get(f, 'CurrentAxes')), gca);
caxis([-3 3]); cmocean('balance',11); colorbar;
title('HUI'); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Longitude');
ticks = -3:1:3;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);



