%fechas a extraer
cd /Volumes/BM_2022_x/Hindcast_1990_2010/means

%% Monthly average

clear all; close all; clc;
addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout;
[mask,LON,LAT,path1]=lets_get_started;
mask(mask==0)=NaN;
%cd /Volumes/BM_2022_x/Hindcast_1990_2010/means/MLD

cd /Volumes/BM_2022_x/Hindcast_1990_2010/means
dir1=dir('Mean*.nc');
%% from 6 to 3 S
% dates_6_3 = ['2008M5', '2008M6', '2008M10', '2009M3', '2009M4', '2009M6', '2009M7', 
% '2009M8', '2009M9','2010M1','2010M2','2010M3','','','', ];
yrst=2008;
most=2;
yren=2010;
moen=12;
moen0=moen;
[Xv,Yv]=meshgrid(LON(:,1), LAT(1,1:end-1));
[Xu,Yu]=meshgrid(LON(1:end-1,1), LAT(1,:));


ij=0;
for iy=yrst:1:yren
    
    if iy>yrst
        most=1;
    end
    % if iy is equal to yren, then let most is moen0,
    if iy==yren
        moen=moen0;
        % otherwise 12
    else
        moen=12;
    end
    
    for imo=most:1:moen
        ij=ij+1;
        fn=sprintf('Mean_Y%dM%d.nc',iy,imo);
        disp(fn)

        %fn='Mean_Y2008M5.nc';
        
        s_rho=ncread(fn,'s_rho');
        s_w=ncread(fn,'s_w');
        
        zz=get_depths(fn,fn,1,'rho'); %we get the depths using all the rho variables
        
        v=ncread(fn,'v');
        u=ncread(fn,'u');
        
        for ik=1:1:size(v,3)
            V(:,:,ik) = interp2(Xv, Yv, v(:,:,ik)', LON', LAT', 'linear')';
            U(:,:,ik) = interp2(Xu, Yu, u(:,:,ik)', LON', LAT', 'linear')';

        end
        vv=permute(V,[3 2 1 4]);
        
        u=ncread(fn,'u');
        uu=permute(U,[3 2 1 4]);

        
      jj=0;
        for ii=0:-10:-500
            jj=jj+1;
            vnew(:,:,jj) = vinterp(vv,zz,ii);
            unew(:,:,jj) = vinterp(uu,zz,ii);

            disp(ii)
        end
        
        % 6 to 3 S
        indxlat = find(LAT(1,:)>= -6 & LAT(1,:)<=-3);
        indxlon = find(LON(:,1)>= -85.5 & LON(:,1)<=-80.5);
        
        % 12 S 
        indxlat12 = find(LAT(1,:)>= -12.5 & LAT(1,:)<=-11.5);
        indxlon12 = find(LON(:,1)>= -82 & LON(:,1)<=-77);
        
        Vmean_3_6(:,:,ij) = permute(mean(vnew(indxlat,indxlon,:),1,'omitnan'),[2 3 1]);
        Vmean_12(:,:,ij) = permute(mean(vnew(indxlat12,indxlon12,:),1,'omitnan'),[2 3 1]);
        
        Umean_3_6(:,:,ij) = permute(mean(unew(indxlat,indxlon,:),1,'omitnan'),[2 3 1]);
        Umean_12(:,:,ij) = permute(mean(unew(indxlat12,indxlon12,:),1,'omitnan'),[2 3 1]);
        
    end
end
%% plot V
distance_km = calculate_longitudinal_distance(-4.5,5); %latitude, longitude
distance_km12 = calculate_longitudinal_distance(-12,5); %latitude, longitude
%dist=flip(linspace(0,distance_km*-1,length(LON(:,1))));
Er=6371000; % earth radius

disti = flip(linspace(0,distance_km,size(Vmean36,1)));
disti12 = flip(linspace(0,distance_km,size(Vmean12,1)));

%% now we average
Zi=[0:-10:-500]';

Vmean36 = mean(Vmean_3_6,3,'omitnan');
Vmean12 = mean(Vmean_12,3,'omitnan');

Umean36 = mean(Umean_3_6,3,'omitnan');
Umean12 = mean(Umean_12,3,'omitnan');
%%  plot without the rotation first
cd /Users/dlizarbe/Documents/DANIEL/DanielLizarbe/IMARPE
Zi=[0:-10:-500]';

figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(1,2,2);hold on
contourf(disti12, Zi, Vmean12'.*100,[-50:1:50],'linestyle','none');
[C h]=contour(disti12, Zi, Vmean12'.*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti12, Zi, Vmean12', [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
set(gca, 'xdir', 'reverse'); xlabel('Distance [km]')
ylim([Zi(end) 0]); ylabel('Depth [m]')
xlim([0 250])
box on
title('CROCO Section 12S');
cmocean('balance',11)
colorbar
caxis([-10 10]);
ax = gca;
ax.FontSize = 20;
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
%title(datestr(time_vector(ifig)));

subplot(1,2,1);hold on
contourf(disti, Zi, Vmean36'.*100,[-50:1:50],'linestyle','none');
[C h]=contour(disti, Zi,Vmean36'.*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
[C h]=contour(disti, Zi, Vmean36', [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
set(gca, 'xdir', 'reverse');xlabel('Distance [km]')
ylim([Zi(end) 0]);ylabel('Depth [m]')
xlim([0 250])
box on
title('CROCO Section 3S-6S');
cmocean('balance',11)
caxis([-10 10]);
colorbar
ax = gca;
ax.FontSize = 20;
ticks = -10:2:10;
c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
%title(datestr(time_vector(ifig)));

%%
a = deg2rad(12);
b = deg2rad(-4.5);
%CM26_Valong12 = -cos(a)*u_12 + sin(a)*v_12;
% Ivy (alpha is now the deviation from north, instead of 90- that as done by Carolin (no difference just for clear notation))
% along current component (s. e.g. wikipedia or do it geometrically
% yourself
C_V12 = -sin(a).*Umean_12 + cos(a).*Vmean_12;

C_V36 = -sin(b).*Vmean_3_6 + cos(b).*Umean_3_6;

%corr(C_V36(:),Vmean36(:), 'rows','complete')

%% 
save('Valongshore_CROCO_correct.mat','disti','disti12','C_V12','C_V36','Vmean36',...
'Vmean12','Umean36','Umean12');
% [c,h]=contourf(disti,Z,C_V36'.*100,[-12:1:12],'linestyle','none');colorbar;
% cmocean('balance',21);
% caxis([-10 10]); %xlim([-85 -80]);
% set(gca, 'XDir','reverse'); xlim([0 250]);
% ticks = -10:2:10;
% c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
%% 
time_vector = generate_monthly_time_vector(2008, 2010);
time_vector = time_vector(2:end);
cd /Users/dlizarbe/Documents/DANIEL/DanielLizarbe/IMARPE

flag=1;
if flag==1
aviobj=QTWriter('V_alongshore_correct','FrameRate',2);
%aviobj.Quality=100;

figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

for ifig=1:1:35
    
    subplot(1,2,2);hold on
    contourf(disti12, Zi, C_V12(:,:,ifig)'.*100,[-50:1:50],'linestyle','none');
    [C h]=contour(disti12, Zi, C_V12(:,:,ifig)'.*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
    [C h]=contour(disti12, Zi, C_V12(:,:,ifig)', [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
    set(gca, 'xdir', 'reverse'); xlabel('Distance [km]')
    ylim([Zi(end) 0]); ylabel('Depth [m]')
    xlim([0 250])
    box on
    text(240,-20,'CROCO Section 12S','fontsize',16);
    cmocean('balance',11)
    colorbar
    caxis([-10 10]);
    ax = gca;
    ax.FontSize = 20;
    ticks = -10:2:10;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    title(datestr(time_vector(ifig)));
    
    subplot(1,2,1);hold on
    contourf(disti, Zi, C_V36(:,:,ifig)'.*100,[-50:1:50],'linestyle','none');
    [C h]=contour(disti, Zi, C_V36(:,:,ifig)'.*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
    [C h]=contour(disti, Zi, C_V36(:,:,ifig)', [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
    set(gca, 'xdir', 'reverse');xlabel('Distance [km]')
    ylim([Zi(end) 0]);ylabel('Depth [m]')
    xlim([0 250])
    box on
    text(240,-20,'CROCO Section 3S-6S','fontsize',16);
    cmocean('balance',11)
    caxis([-10 10]);
    colorbar
    ax = gca;
    ax.FontSize = 20;
    ticks = -10:2:10;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    title(datestr(time_vector(ifig)));

    pause(1)
    M1=getframe(gcf);
    writeMovie(aviobj,M1);

    clf
end
close(aviobj);
end
%% figure
LTM_CV12 = mean(C_V12,3,'omitnan');
LTM_CV36 = mean(C_V36,3,'omitnan');


figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

   subplot(1,2,2);hold on
    contourf(disti12, Zi, LTM_CV12'.*100,[-50:1:50],'linestyle','none');
    [C h]=contour(disti12, Zi, LTM_CV12'.*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
    [C h]=contour(disti12, Zi, LTM_CV12', [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
    set(gca, 'xdir', 'reverse'); xlabel('Distance [km]')
    ylim([Zi(end) 0]); ylabel('Depth [m]')
    xlim([0 250])
    box on
    title('CROCO Section 12S');
    cmocean('balance',11)
    colorbar
    caxis([-10 10]);
    ax = gca;
    ax.FontSize = 20;
    ticks = -10:2:10;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    %title(datestr(time_vector(ifig)));
    
    subplot(1,2,1);hold on
    contourf(disti, Zi, LTM_CV36'.*100,[-50:1:50],'linestyle','none');
    [C h]=contour(disti, Zi, LTM_CV36'.*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
    [C h]=contour(disti, Zi, LTM_CV36', [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
    set(gca, 'xdir', 'reverse');xlabel('Distance [km]')
    ylim([Zi(end) 0]);ylabel('Depth [m]')
    xlim([0 250])
    box on
   title('CROCO Section 3S-6S');
    cmocean('balance',11)
    caxis([-10 10]);
    colorbar
    ax = gca;
    ax.FontSize = 20;
    ticks = -10:2:10;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));

%% Load ADCP IMARPE
load('ADCP_Section_3S_6S.mat')
X = Dist(1:end-2);
Valong36 = Valongshore(1:end-2,6:end);

load('ADCP_Section_12S.mat')
Valong12 = Valongshore(1:end-2,6:end);

clear Dist Valongshore pathd
Z = Z(6:end);

%% average %disti12, Z
ZZ = 50:10:500; 
[Xu,Yu]=meshgrid(Z, X);
[Xv,Yv]=meshgrid(disti12(41:end), ZZ);

LTM_CV12 = mean(C_V12(42:end,6:end,:),3,'omitnan');
LTM_CV36 = mean(C_V36(42:end,6:end,:),3,'omitnan');


corr(Valong12(:),LTM_CV12(:), 'rows','complete')
corr(Valong36(:),LTM_CV36(:), 'rows','complete')

plot(Valong12(:),LTM_CV12(:),'.');
%% find the monthly clim
%% --- climatology ---- %% 

jj=0;
[yr,mo]=datevec(time_vector');

for imo=1:1:12
    
    indxclim=find(mo==imo);
    
    climV12(:,:,imo)=mean(C_V12(42:end,6:end,indxclim),3,'omitnan');
    climV36(:,:,imo)=mean(C_V36(42:end,6:end,indxclim),3,'omitnan');
    
end
%%
for kk =1:1:12
    aa=climV12(:,:,kk);
    bb = climV36(:,:,kk);
    
    [R12(kk),p12(kk)] = corr(Valong12(:),aa(:), 'rows','complete');
    [R36(kk),p36(kk)] = corr(Valong12(:),bb(:), 'rows','complete');
end
%% 
plot(R12,'linewidth',2); hold on; plot(R36,'linewidth',2);
xlabel('Months'); ylabel('Correlation [R]');
ax = gca; xlim([1 12]); title('ADCP vs Model');
ax.FontSize = 20; grid on; box on;
set(gca,'ytick',[-1:0.2:1],'yticklabel',[-1:0.2:1],'ylim',[-1 1]);
set(gca,'xtick',[1:1:12],'xticklabel',[1:1:12],'xlim',[1 12]);

legend('Latitudinal band 12S','Latitudinal band 3-6S');
