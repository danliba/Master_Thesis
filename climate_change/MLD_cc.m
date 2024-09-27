%% MLD under sensitivity analysis 
cd /Volumes/BM_2019_01/climate
%paths 
p1 ='/Volumes/BM_2019_01/climate/ref';
p2 = '/Volumes/BM_2019_01/climate/T+';
p3 = '/Volumes/BM_2019_01/climate/wind-';
p4 = '/Volumes/BM_2019_01/climate/wind+';


ref=struct2array(load(fullfile(p1,'WMLD_MLD.mat'), 'MLD'));
Tplus=struct2array(load(fullfile(p2,'WMLD_MLD.mat'), 'MLD'));
Wminus=struct2array(load(fullfile(p3,'WMLD_MLD.mat'), 'MLD'));
Wplus=struct2array(load(fullfile(p4,'WMLD_MLD.mat'), 'MLD'));

load('MLD.mat');
load('NINO9798.mat');

[mask,LON,LAT,~]=lets_get_started_CC;
%% ----- transform Cross Shore
[ref1,~]=MLD_2_CrossShore(ref,1);
[Tplus1,~]=MLD_2_CrossShore(Tplus,1);
[Wminus1,~]=MLD_2_CrossShore(Wminus,1);
[Wplus1,~]=MLD_2_CrossShore(Wplus,1);
[~,MLD_N]=MLD_2_CrossShore(MLD,0);
%-------
indxlon = find(LON(:,1)>= -85 & LON(:,1)<=-75);
loni = LON(indxlon,1);
loncut = find(loni>= -80);
MLD_NINO9798 = mean(MLD_N(loncut,EN9798_index),2);

distance_km12 = calculate_longitudinal_distance(-12,5); %latitude, longitude
disti12 = flip(linspace(0,distance_km12,size(Wplus1,1)));

%% --- Plot 
matblue = [0, 0.4470, 0.7410];
matred = [0.8500, 0.3250, 0.0980];
matyellow = [0.9290 0.6940 0.1250];

figure;hold on; 
plot(disti12,-ref1,'linewidth',4,'Color','k'); 
plot(disti12,-Tplus1,'linewidth',3,'Color',matred); 
plot(disti12,-Wminus1,'linewidth',3,'Color',matyellow);
plot(disti12,-Wplus1,'linewidth',3,'Color',matblue);
%plot(disti12,-MLD_NINO9798,'linewidth',2,'Color','r','linestyle','--'); 

set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
xlim([0 200]); title('Mixed Layer Depth');
legend('ref','T+','W-','W+');
ax = gca;
ax.FontSize = 20;
box on;
grid on;
ylabel('Depth [m]')

%%
save('MLD_CC_SA.mat','disti12','ref1','Tplus1','Wminus1','Wplus1','MLD_NINO9798');

