cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices;
%% 

load('/Users/dlizarbe/Documents/DANIEL/depths/MLD_W_1990_2010.mat'); % CROCO
load('/Volumes/BM_2022_x/Hindcast_1990_2010/inout/Wc_mean.mat'); %Wc
%% 
arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

ind1=double(inpolygon(LON,LAT,lonb1,latb1));
ind1(ind1==0)=NaN;

lati=LAT(1,:); loni=LON(:,1);
indxlat=find(lati>=-20 & lati<=-5);

Wmld=permute(Wmld,[2 1 3]);
nWmld=Wmld.*ind1.*mask;
cWmld=nWmld(:,indxlat,:);
%% 
figure
[c,h]=contourf(loni,lati(indxlat),squeeze(cWmld(:,:,100)').*86400,[-3:0.2:3]);
shading flat; colorbar; 
cmocean('balance',13); set(h,'LineColor','none');
axis([-90 -70 -20 -5]);

title('Croco Index','fontsize',16); 
caxis([-1.6 1.6]);
%% 
Mean_Wmld=permute(mean(cWmld,1,'omitnan'),[2 3 1]);

time2=linspace(1990,2010,size(Wmld,3))';
%pcolor(time2,Mean_Bakun); shading flat;
latBakun=lati(indxlat);
time=generate_monthly_time_vector(1990, 2010)';
%% 
figure
P=get(gcf,'position');
P(3)=P(3)*3;
P(4)=P(4)*1.2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(time,latBakun,Mean_Wmld.*86400,[-6:0.1:6]);colorbar; 
cmocean('balance',41); set(h,'LineColor','none'); clabel(c,h);
title('Monthly Croco W at ML 150km offshore','fontsize',16); 
ax = gca;
ax.FontSize = 16;
ylabel('Latitude'); xlabel('Time');
ax = gca;
caxis([-4 4]);
ticks = -4:0.5:4;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String='m/day';
c.Label.FontSize = 18;
datetick('x');
%% 

jj=0;
[yr,mo]=datevec(time);

for imo=1:1:12
    
    indxclim=find(mo==imo);
    
    climWMLD(:,imo)=mean(Mean_Wmld(:,indxclim),2,'omitnan');
    
end

%% 
timeclim=1:12;
grey = [0.5 0.5 0.5];

figure
P=get(gcf,'position');
P(3)=P(3)*1.5;
P(4)=P(4)*4;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,h]=contourf(timeclim,latBakun,climWMLD.*86400,[-10:0.1:10]); colorbar; 
cmocean('balance',41); set(h,'LineColor','none');
hold on
[c,h]=contour(timeclim,latBakun,climWMLD.*86400,[-10:0.5:10]); clabel(c,h);
set(h,'LineColor',grey);
title('Croco W at MLD Montlhy Climatology 150km offshore','fontsize',16); 
ax = gca;
ax.FontSize = 18;
ylabel('Latitude'); xlabel('Time');
ax = gca;
caxis([-2.5 2.5]);
ticks = -2.5:0.5:2.5;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
c.Label.String='m/day';
c.Label.FontSize = 20;
%datetick('x');


