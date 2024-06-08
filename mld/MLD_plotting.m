cd /Volumes/BM_2022_x/Hindcast_1990_2010/means/MLD;
%% 
load('MLD_processed.mat');
%%
%% ------------- Load ENSO by DANTE ----------------- %%
load('ENSO_DANTE_dates.mat');
timeNINO2(16)=[];
fsize=20;
[~,ylab] = generateYLabels(20,4,2);

grey = [0.5 0.5 0.5];
brown = [165, 42, 42] ./ 255;
dark_green = [0, 100, 0] ./ 255;
blue_green = [0, 128, 128] ./ 255;

%% ------- plot ------------ %%
arr= ones(length(timeNINO2), 1); arr2=ones(length(timeNINA2),1);
arr(arr==1)=1000; arr2(arr2==1)=1000;
arr3(arr==1000)=-1000; arr4(arr2==1000)=-1000;

time = generate_monthly_time_vector(1990, 2010)';
trp = 0.3;

figure
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(2,1,1)
a=bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
b=bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
c=plot(time,MLD_ts,'Color',grey,'linewidth',2,'linestyle','-');
datetick('x'); ylim([0 40]);
title('Mixed Layer Depth');
ax = gca;
ax.FontSize = fsize;
grid on
ylabel('$m$','interpreter','latex');
legend([a,b,c],{'Nino','Nina','MLD'});

subplot(2,1,2)
bar(timeNINO2,arr3, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
bar(timeNINA2,arr4, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
a=bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
b=bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', trp,'BarWidth', 1.1);
hold on
plot(time,MLD_anom,'Color',grey,'linewidth',0.7,'linestyle','-');
hold on
c=plot(time,movmean(MLD_anom,13),'Color',blue_green,'linewidth',2,'linestyle','-');
datetick('x'); ylim([-15 15]);
title('Mixed Layer Depth Anomaly');
ax = gca;
ax.FontSize = fsize;
grid on
ylabel('$m$','interpreter','latex');
legend([a,b,c],{'Nino','Nina','MLD anom'});