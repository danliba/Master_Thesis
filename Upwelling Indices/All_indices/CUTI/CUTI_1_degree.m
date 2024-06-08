%% SSH var
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/CUTI
clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,f,path1]=lets_get_started;
mask(mask==0)=NaN;
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/CUTI

flag==0;
%% load MLD, SSH 
load('MLD.mat');
load('SSH_croco.mat');
Humboldt_ports;

%% extract the latitudes from -21 to -4 
lati=LAT(1,:); %latCUTI=lati(indxlat);
indxlat=find(lati>=-21 & lati<=-4)';

target_latitudes=[-4:-1:-21]';

for ii=1:numel(target_latitudes)
    [~,b]=min(abs(lati-target_latitudes(ii)));
    indx0(ii,1)=b;
end

%% 

indxlat1=indx0(1:end-1); %-33 to 9.9 
indxlat2=indx0(2:end);%;-32 to 10 

lati1=lati(indxlat1); lati2=lati(indxlat2);
%indxlat=find(lati>=-21 & lati<=-4);

%flip SSH in the 2nd dimension
% figure; pcolor(LON,LAT,SSH(:,:,1).*mask); shading flat;
% SSHflip=flip(SSH,2);
% pcolor(LON,LAT,SSHflip(:,:,1)); shading flat;
% 

[~,IA1,~] = intersect(lati,lati1);
[~,IA2,~] = intersect(lati,lati2);

SSH = SSH .*mask;
SSHA=SSH(:,IA1,:);
SSHB=SSH(:,IA2,:);

SSH2=abs(SSHA-SSHB);%meters

%%
% Calculate the distance between the latitudes
distance_between_latitudes = abs(lati2 - lati1) .* 111.1949; %km

distance_Array=repmat(distance_between_latitudes'*1000,1,size(SSH2,1))';%meters

latiCUTI=flip(repmat(lati1',1,size(SSH2,1)))';%flip -21 to -4
loni = LON(:,1); 

[latis2,lonis2]=meshgrid(lati1,loni);
latis2=flip(latis2,2);
g=9.81;

mld = MLD(:,IA1,:); %

ugeo=(g.*SSH2)./(f(:,IA1).* distance_Array);
Ugeo= ugeo.* mld;
%% 
LTM_UGEO = mean(Ugeo,3,'omitnan');

[Xu,Yu]=meshgrid(LON(:,1), latiCUTI(1,:));

LTM_UGEO2 = interp2(Xu,Yu,LTM_UGEO', LON', LAT', 'linear')'; %

cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/CUTI/CUTI_1degree
%save('UGEO_1_degree.mat','LON','LAT','LTM_UGEO2','Ugeo','latiCUTI');

%% NOW CUTI 
%load('UGEO_1_degree.mat');
UEK=table2array(struct2table(load('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BakunIndex_Final.mat','UE')));

[Xu,Yu]=meshgrid(LON(:,1), latiCUTI(1,:));

for ii=1:1:size(SSH,3)
    UGEO(:,:,ii) = interp2(Xu,Yu,Ugeo(:,:,ii)', LON', LAT', 'linear')'; %
    disp(ii)
end
%% CUTI
UEK_1_deg = UEK(:,IA1,:);
CUTI_1_DEG = UEK_1_deg + Ugeo ;
CUTI = UEK + UGEO ;
%CUTI = UEK.*sign(LAT) + UGEO.*sign(LAT) ;
LTM_CUTI = mean(CUTI,3,'omitnan');
LTM_CUTI_1_deg = mean(CUTI_1_DEG,3,'omitnan');
LTM_UE = mean(UEK,3,'omitnan');
%% let's cut
arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

ind1=double(inpolygon(lonis2,latis2,lonb1,latb1));
ind1(ind1==0)=NaN;

latis=latis2(1,:); lonis=lonis2(:,1);
%indxlat=find(latis>=-20 & latis<=-5);

nCUTI=CUTI_1_DEG.*ind1;

% figure
% pcolor(lonis2,latis2,nCUTI(:,:,1)); shading flat;
% hold on
% plot(lonb1,latb1)
%cCUTI=nCUTI(:,indxlat,:);
%% 
if flag==1
figure
pcolor(lonis2,latis2,squeeze(nCUTI(:,:,1)));shading flat; colorbar; 
cmocean('balance',11); 
axis([-84 -70 -20 -5]);

title('CUTI Index','fontsize',16); 
caxis([-5 5]);
hold on
plot(lonb1,latb1,'k','linewidth',4);
end
%% 
time=time';
Mean_CUTI=permute(mean(nCUTI,1,'omitnan'),[2 3 1]);

time2=linspace(1990,2010.99,length(time))';
%%
latiCUTI = latis2(1,:); 

if flag==1;
figure
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(time2,latiCUTI,Mean_CUTI,[-30:0.1:30]);colorbar; 
cmocean('balance',21); set(h,'LineColor','none'); clabel(c,h);
title('Monthly CUTI Index 150km offshore','fontsize',22); 
ax = gca;
ax.FontSize = 18;
ylabel('Latitude'); xlabel('Time');
ax = gca;
ax.FontSize = 18; 
caxis([-10 10]);
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String='m^{2}/s';
c.Label.FontSize = 20;
end
%% 
jj=0;
[yr,mo]=datevec(time');

for imo=1:1:12
    
    indxclim=find(mo==imo);
    
    climCUTI(:,imo)=mean(Mean_CUTI(:,indxclim),2,'omitnan');
    
end
%% 
timeclim=1:12;
grey = [0.5 0.5 0.5];

if flag==1
figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*3;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(timeclim,latiCUTI,climCUTI,[-20:0.1:20]);shading flat; colorbar; 
cmocean('balance',41); clabel(c,h);set(h,'LineColor','none'); 
hold on
[c,h]=contour(timeclim,latiCUTI,climCUTI,[-5:1:5],'Color',grey);
clabel(c,h);
title('CUTI Index Climatology 150km offshore','fontsize',22); 
ax = gca;
ax.FontSize = 20;
ylabel('Latitude'); xlabel('Months');
caxis([-10 10]);
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String='m^{2}/s';
c.Label.FontSize = 18;
end
%%
CUTI_latitudinal_LR = mean(climCUTI, 2,'omitnan');
%% plot
if flag==1;
plot(CUTI_latitudinal_LR.*-1,latiCUTI,'mo-','markerfacecolor','m');
ylabel('Latitude','fontsize',14); xlabel('Transport m^{2}s^{-1}','fontsize',14);
ax = gca;
ax.FontSize = 20; grid minor; title('LTM CUTI');end;
%% SAVE

save('CUTI_1D','time2','latiCUTI','Mean_CUTI','CUTI_latitudinal_LR','IA1','CUTI_1_DEG');