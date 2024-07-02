function V_component_CrossShore_CC(inpath, Filepattern)
%fechas a extraer
cd /Volumes/BM_2019_01/climate
%% Monthly average

[mask,LON,LAT,~]=lets_get_started_CC;
mask(mask==0)=NaN;
%cd /Volumes/BM_2022_x/Hindcast_1990_2010/means/MLD

cd(inpath)
dir1=dir(Filepattern);
disp(dir1)
%% loni
indxlon = find(LON(:,1)>= -85 & LON(:,1)<=-75);
loni = LON(indxlon,1);
%%

ij=0;
for ik=1:1:length(dir1)
        fn=dir1(ik).name;
        disp(fn)

        %fn='Mean_Y2008M5.nc';
        
        s_rho=ncread(fn,'s_rho');
        s_w=ncread(fn,'s_w');
        
        zz=get_depths(fn,fn,1,'rho'); %we get the depths using all the rho variables
        
        % 12 S 
        indxlat12 = find(LAT(1,:)>= -16 & LAT(1,:)<=-5);
        indxlon12 = find(LON(:,1)>= -85 & LON(:,1)<=-75);
        
        start_lon = min(indxlon12);
        count_lon = length(indxlon12);
        start_lat = min(indxlat12);
        count_lat = length(indxlat12);

        start_time = 1;  % Assuming we want to start from the first time step
        count_time = Inf;  % Use Inf to read all time steps
        
        v = ncread(fn, 'v', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time]);
        u = ncread(fn,'u', [start_lon, start_lat, 1, start_time], [count_lon, count_lat, Inf, count_time]);
        
        vv=permute(v,[3 2 1 4]);
        uu=permute(u,[3 2 1 4]);
        zz1 = zz(:,indxlat12,indxlon12);
        
        jj=0;
        for ii=0:-10:-500
            jj=jj+1;
            vnew1 = vinterp(vv,zz1,ii); 
            vnew1(vnew1==0)=NaN; %vnew1 = vnew1.*ind1;
            vnew(:,:,jj) = shift_coast_to_0km_ver2(vnew1);
            %unew(:,:,jj) = vinterp(uu,zz1,ii);

            disp(ii)
        end
         Vmean_1214(:,:,ik) = permute(mean(vnew,1,'omitnan'),[2 3 1]);
        
end

%% 
loncut = find(loni>= -80);
%V_NINO = mean(Vmean_1214(loncut,:,indxNINO2),3,'omitnan');
Mean_V = mean(Vmean_1214(loncut,:,:),3,'omitnan');

%%
flag = 1;
if flag ==1
    Zi=[0:-10:-500]';
    distance_km12 = calculate_longitudinal_distance(-12,5); %latitude, longitude
    disti12 = flip(linspace(0,distance_km12,size(Mean_V,1)));
    
    figure; hold on
    pcolor(disti12,Zi,Mean_V'*100); shading interp; cmocean('balance',18);
    caxis([-10 10]);
    [C h]=contour(disti12, Zi,Mean_V'.*100, [-50:10:0],'w--','linestyle','--','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:-10],'color',[.5 .5 .5],'fontsize',14);
    [C h]=contour(disti12, Zi, Mean_V', [0:10:50],'w-','linestyle','-','linewidth',2,'Color',[.5 .5 .5]);
    clabel(C,h,[-50:10:50],'color',[.5 .5 .5],'fontsize',14);
    set(gca, 'xdir', 'reverse');xlabel('Distance [km]');
    ylim([-300 0]);ylabel('Depth [m]')
    xlim([0 250])
    box on
    title('V 5S-16S');
    colorbar
    ax = gca;
    ax.FontSize = 20;
    ticks = -10:2:10;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    ylabel(c, 'cm/s'); % Add your desired label here

savefig('CSH_CC.fig');
end
save('CSH_CC_V.mat','Mean_V','disti12','Zi');
