bd = readtable('normalized_data.xlsx');
UI = table2array(cat(2,bd(:,3:6),bd(:,8)));

meanUI = mean(UI,2);

for ii=1:1:length(meanUI)
    stdUI(ii,:) = std(UI(ii,:));
end

%% 
time = generate_monthly_time_vector(1990, 2010)';

curve1 = meanUI + stdUI;
curve2 = meanUI - stdUI;
x2 = [time, fliplr(time)];
inBetween = [curve1, fliplr(curve2)];
fill(x2, inBetween, 'g');
%% 
options.handle = figure;
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');
options.color_area = [0.5, 0.5, 0.5];    % Light grey
options.color_line = [0.5, 0.5, 0.5];    % Dark grey
options.alpha = 0.3;
options.line_width = 1.5;
options.x_axis = time;
options.error = 'std';
plot_areaerrorbar(UI',options)

%%
%% ------------- Load ENSO by DANTE ----------------- %%
load('ENSO_DANTE_dates.mat');
timeNINO2(16)=[]; indxNINO2(16) = [];
fsize=20;
[~,ylab] = generateYLabels(20,4,2);

grey = [0.5 0.5 0.5];
brown = [165, 42, 42] ./ 255;
dark_green = [0, 100, 0] ./ 255;
blue_green = [0, 128, 128] ./ 255;

%options.handle = figure;
options.color_area = [0.5, 0.5, 0.5];    % Light grey
options.color_line = [0.5, 0.5, 0.5];    % Dark grey
options.alpha = 0.3;
options.line_width = 2;
options.x_axis = time;
options.error = 'std';

%% ------- plot ------------ %%
arr= ones(length(timeNINO2), 1); arr2=ones(length(timeNINA2),1);
arr(arr==1)=0.2; arr2(arr2==1)=0.2;
% xlab = {'1990','1992','1994','1996','1998','2000','2002','2004','2006','2008',...
%     '2010'}';

options.handle = figure;
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

a=bar(timeNINO2,arr, 'FaceColor', [0.8500, 0.3250, 0.0980], 'EdgeColor', 'none','FaceAlpha', 0.3);
hold on
b=bar(timeNINA2,arr2, 'FaceColor', [0.53, 0.81, 0.92], 'EdgeColor', 'none','FaceAlpha', 0.3);
hold on
plot_areaerrorbar(UI',options);
hold on
%c=plot([1:252],meanUI,'Color','k','linewidth',0.1);
datetick('x'); 
ylim([0 0.15]);
title('Mean Upwelling Indices');
grid on
ylabel('$Indices$','interpreter','latex');
%set(gca,'xtick',[1:2:252],'xticklabel',[1990:2:2010],'xlim',[1 252]);
ax = gca;
ax.FontSize = fsize;


%legend([a,b,c],{'Nino','Nina','Mean UI'});