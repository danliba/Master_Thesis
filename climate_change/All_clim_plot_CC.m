%Let's plot all the climatologies
%Analytical velocity
a=openfig('/Volumes/BM_2019_01/climate/ref/Analytical_vel_clim.fig');
b=openfig('/Volumes/BM_2019_01/climate/T+/Analytical_vel_clim.fig');
cc=openfig('/Volumes/BM_2019_01/climate/wind-/Analytical_vel_clim.fig');
d=openfig('/Volumes/BM_2019_01/climate/wind+/Analytical_vel_clim.fig');

%Bakun
a2=openfig('/Volumes/BM_2019_01/climate/ref/BUI_clim.fig');
b2=openfig('/Volumes/BM_2019_01/climate/T+/BUI_clim.fig');
cc2=openfig('/Volumes/BM_2019_01/climate/wind-/BUI_clim.fig');
d2=openfig('/Volumes/BM_2019_01/climate/wind+/BUI_clim.fig');

%% ------ Plotting ------ %% 

timeclim=1:12;
ylab={'20S','15S','10S','5S'};
xlab={'J','F','M','A','M','J','J','A','S','O','N','D'};

figure
P=get(gcf,'position');
P(3)=P(3)*4;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');
% ---- Analytical Velocity ---- %
subplot(2, 4, 1);
copyobj(allchild(get(a, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',13);
title('Analytical Velocity [ref]','fontsize',22); 
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
set(gca, 'TickDir', 'out'); % Set the ticks to be outside
%--T +
subplot(2, 4, 2);
copyobj(allchild(get(b, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',13);
title('Analytical Velocity [T+]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Month');
caxis([-3 3]);
ticks = -3:1:3;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside
%--- Wind -
subplot(2, 4, 3);
copyobj(allchild(get(cc, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',13);
title('Analytical Velocity [Wind -]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Month');
caxis([-3 3]);
ticks = -3:1:3;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside
%-- Wind +
subplot(2, 4, 4);
copyobj(allchild(get(d, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',13);
title('Analytical Velocity [Wind +]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Month');
caxis([-3 3]);
ticks = -3:1:3;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%--- Bakun Index ----%
subplot(2,4,5);
copyobj(allchild(get(a2, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',17);
title('Bakun Index [ref]','fontsize',22); 
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
set(gca, 'TickDir', 'out'); % Set the ticks to be outside
%--- T+
subplot(2,4,6);
copyobj(allchild(get(b2, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',17);
title('Bakun Index [T+]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Month');
caxis([-2 2]);
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = 'm$^{2}$/s';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside
%---- wind -
subplot(2,4,7);
copyobj(allchild(get(cc2, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',17);
title('Bakun Index [Wind -]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Month');
caxis([-2 2]);
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = 'm$^{2}$/s';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside
%---- wind +
subplot(2,4,8);
copyobj(allchild(get(d2, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',17);
title('Bakun Index [Wind +]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Month');
caxis([-2 2]);
ticks = -2:0.5:2;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = 'm$^{2}$/s';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside
%% %%%%%%%%%%%%%% -------- CUTI and BEUTI ------------ %%
%CUTI
a3=openfig('/Volumes/BM_2019_01/climate/ref/climato_CUTI.fig');
b3=openfig('/Volumes/BM_2019_01/climate/T+/climato_CUTI.fig');
cc3=openfig('/Volumes/BM_2019_01/climate/wind-/climato_CUTI.fig');
d3=openfig('/Volumes/BM_2019_01/climate/wind+/climato_CUTI.fig');

%BEUTI
a4=openfig('/Volumes/BM_2019_01/climate/ref/BEUTI_clim.fig');
b4=openfig('/Volumes/BM_2019_01/climate/T+/BEUTI_clim.fig');
cc4=openfig('/Volumes/BM_2019_01/climate/wind-/BEUTI_clim.fig');
d4=openfig('/Volumes/BM_2019_01/climate/wind+/BEUTI_clim.fig');
%% 
figure
P=get(gcf,'position');
P(3)=P(3)*4;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

%--- CUTI ----%
subplot(2,4,1);
copyobj(allchild(get(a3, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',17);
title('CUTI [ref]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Month');
caxis([-8 8]);
ticks = -8:2:8;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = 'm$^{2}$/s';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%-- T +
subplot(2,4,2);
copyobj(allchild(get(b3, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',17);
title('CUTI [T+]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Month');
caxis([-8 8]);
ticks = -8:2:8;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = 'm$^{2}$/s';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%---  wind -
subplot(2,4,3);
copyobj(allchild(get(cc3, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',17);
title('CUTI [wind-]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Month');
caxis([-8 8]);
ticks = -8:2:8;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = 'm$^{2}$/s';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%--- wind +
subplot(2,4,4);
copyobj(allchild(get(d3, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',17);
title('CUTI [wind+]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Month');
caxis([-8 8]);
ticks = -8:2:8;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = 'm$^{2}$/s';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%---- BEUTI
subplot(2,4,5);
copyobj(allchild(get(a4, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',21);
title('BEUTI [ref]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Month');
caxis([-100 100]);
ticks = -100:20:100;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$mmol \cdot m^{-1} \cdot s^{-1}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%--- T +
subplot(2,4,6);
copyobj(allchild(get(b4, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',21);
title('BEUTI [T+]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Month');
caxis([-100 100]);
ticks = -100:20:100;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$mmol \cdot m^{-1} \cdot s^{-1}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%--- wind -
subplot(2,4,7);
copyobj(allchild(get(cc4, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',21);
title('BEUTI [wind-]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Month');
caxis([-100 100]);
ticks = -100:20:100;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$mmol \cdot m^{-1} \cdot s^{-1}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%--- wind +
subplot(2,4,8);
copyobj(allchild(get(d4, 'CurrentAxes')), gca);
xlim([1 12]); cmocean('balance',21);
title('BEUTI [wind+]','fontsize',22); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Month');
caxis([-100 100]);
ticks = -100:20:100;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$mmol \cdot m^{-1} \cdot s^{-1}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;

set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%% %%%%% ------ CUI and HUI ---------- %%
%CUI
a5=openfig('/Volumes/BM_2019_01/climate/ref/CUI_climatology.fig');
b5=openfig('/Volumes/BM_2019_01/climate/T+/CUI_climatology.fig');
cc5=openfig('/Volumes/BM_2019_01/climate/wind-/CUI_climatology.fig');
d5=openfig('/Volumes/BM_2019_01/climate/wind+/CUI_climatology.fig');

%HUI
a6=openfig('/Volumes/BM_2019_01/climate/ref/HUI_clim.fig');
b6=openfig('/Volumes/BM_2019_01/climate/T+/HUI_clim.fig');
cc6=openfig('/Volumes/BM_2019_01/climate/wind-/HUI_clim.fig');
d6=openfig('/Volumes/BM_2019_01/climate/wind+/HUI_clim.fig');

%% plot 
figure
P=get(gcf,'position');
P(3)=P(3)*4;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

%CUI ref
subplot(2,4,1)
copyobj(allchild(get(a5, 'CurrentAxes')), gca);
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Month');
colorbar; cmocean('balance',21);
caxis([-10 10])
title('CUI [ref]');
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$^\circ C$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%--- T + 
subplot(2,4,2)
copyobj(allchild(get(b5, 'CurrentAxes')), gca);
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Month');
colorbar; cmocean('balance',21);
caxis([-10 10])
title('CUI [T+]');
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$^\circ C$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%--- wind -
subplot(2,4,3)
copyobj(allchild(get(cc5, 'CurrentAxes')), gca);
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Month');
colorbar; cmocean('balance',21);
caxis([-10 10])
title('CUI [wind-]');
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$^\circ C$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%--- wind +
subplot(2,4,4)
copyobj(allchild(get(d5, 'CurrentAxes')), gca);
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Month');
colorbar; cmocean('balance',21);
caxis([-10 10])
title('CUI [wind+]');
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$^\circ C$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%HUI ref
subplot(2,4,5)
copyobj(allchild(get(a6, 'CurrentAxes')), gca);
caxis([-3 3]); cmocean('balance',13); colorbar;
title('HUI [ref]'); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Month');
ticks = -3:1:3;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%--- T +
subplot(2,4,6)
copyobj(allchild(get(b6, 'CurrentAxes')), gca);
caxis([-3 3]); cmocean('balance',13); colorbar;
title('HUI [T+]'); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Month');
ticks = -3:1:3;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%--- Wind -
subplot(2,4,7)
copyobj(allchild(get(cc6, 'CurrentAxes')), gca);
caxis([-3 3]); cmocean('balance',13); colorbar;
title('HUI [wind-]'); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Month');
ticks = -3:1:3;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside

%--- wind +
subplot(2,4,8)
copyobj(allchild(get(d6, 'CurrentAxes')), gca);
caxis([-3 3]); cmocean('balance',13); colorbar;
title('HUI [wind+]'); 
ax = gca;
ax.FontSize = 20;
%ylabel('Latitude'); 
xlabel('Month');
ticks = -3:1:3;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 20;
set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
set(gca, 'TickDir', 'out'); % Set the ticks to be outside
