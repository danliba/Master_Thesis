p1 ='/Volumes/BM_2019_01/climate/ref';
p2 = '/Volumes/BM_2019_01/climate/T+';
p3 = '/Volumes/BM_2019_01/climate/wind-';
p4 = '/Volumes/BM_2019_01/climate/wind+';
p5 = '/Volumes/BM_2022_x/Hindcast_1990_2010/Presentation';

load('W_perfil_5_16.mat', 'depths');
%Velocity profile
ref = mean(struct2array(load(fullfile(p1,'W_perfil_5_16.mat'), 'wnew2')),2,'omitnan')*86400;
T = mean(struct2array(load(fullfile(p2,'W_perfil_5_16.mat'), 'wnew2')),2,'omitnan')*86400;
W_ = mean(struct2array(load(fullfile(p3,'W_perfil_5_16.mat'), 'wnew2')),2,'omitnan')*86400;
W = mean(struct2array(load(fullfile(p4,'W_perfil_5_16.mat'), 'wnew2')),2,'omitnan')*86400;
%% 
load('NINO9798.mat');
EN = struct2array(load(fullfile(p5,'W_perfil_5_16.mat'), 'wnew2'));
EN97 = double(mean(EN(:,EN9798_index),2,'omitnan'));
noNINOIndex = cat(1,[1:87]',[107:252]');

NEUTRAL = mean(EN(:,noNINOIndex),2,'omitnan');
%EN = mean(wnew2(:,EN9798_index),2,'omitnan');
matblue = [0, 0.4470, 0.7410];
matred = [0.8500, 0.3250, 0.0980];
matyellow = [0.9290 0.6940 0.1250];
%%
figure
P=get(gcf,'position');
P(3)=P(3)*1.5;
P(4)=P(4)*1.2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');hold on;

subplot(1,2,1); hold on;
a=plot(ref,depths,'linewidth',3,'Color','k');
b=plot(T,depths,'linewidth',2,'Color',matred);
c=plot(W_,depths,'linewidth',2,'Color',matyellow);
d=plot(W,depths,'linewidth',2,'Color',matblue);
e=plot(EN97*86400,depths,'linewidth',2,'Color','red','linestyle','--');
ylim([-200 0]); grid on;
xlabel('m/day');
ax = gca;
ax.FontSize = 20; 
title('Upwelling Velocity');
legend([a,b,d,c,e],{'ref','T+','W +','W -','EN 97-98'});
ylabel('Depth [m]');
set(gca,'ytick',[-200:20:0],'yticklabel',[-200:20:0],'ylim',[-200 0]);
box on;

subplot(1,2,2); hold on
%a=plot(ref,depths,'linewidth',2,'Color','k');
b=plot([T-ref],depths,'linewidth',2,'Color',matred);
c=plot([W_-ref],depths,'linewidth',2,'Color',matyellow);
d=plot([W-ref],depths,'linewidth',2,'Color',matblue);
e=plot([EN97-NEUTRAL]*86400,depths,'linewidth',2,'Color','red','linestyle','--');
ylim([-200 0]); grid on;
xlabel('m/day');
ax = gca;
ax.FontSize = 20; 
title('Anomaly');
legend([b,d,c,e],{'T+','W +','W -','EN 97-98'});
ylabel('Depth [m]');
set(gca,'ytick',[-200:20:0],'yticklabel',[-200:20:0],'ylim',[-200 0]);
box on;

