function process_BEUTI_indices(in_path)
    %% ------ BEUTI ----- %% 
    addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
    cd(in_path);
    [mask,LON,LAT,~,~]=lets_get_started_CC;
    mask(mask==0)=NaN;
    %%
    cd(in_path);
    load(fullfile(in_path,'CUTI.mat'), 'CUTI');
    Total_N = struct2array(load(fullfile(in_path,'Nitrogen.mat'),'TN_MLD'));
    %% Let's find BEUTI 
    %Total_N = permute(Total_N,[2,1,3]);

    BEUTI = Total_N .* CUTI ;
    LTM_BEUTI = mean(BEUTI,3,'omitnan');
    %LTM_CUTI = mean(CUTI,3,'omitnan');
    Humboldt_ports;
    %% Plot BEUTI 
    [~,ylab] = generateYLabels(20,5,5);
    [~,xlab] = generateXLabels(90,70,5);

    figure 
    [c,h]=contourf(LON,LAT,LTM_BEUTI*-1.*mask,[-100:1:100]);shading flat;
    axis([-90 -70 -20 -5]); cmocean('balance',21); 
    colorbar; %borders('countries','facecolor','white');
    title('BEUTI'); set(h,'LineColor','none');

    hold on
    for i = 1:5
        key = Puertos{i,1}; % Get port name
        x = Puertos{i,2}(2); % Get longitude
        y = Puertos{i,2}(1); % Get latitude
        plot(x,y,'ko--','markerfacecolor','m');
        text(x+0.2, y, key, 'FontSize', 14); % Plot text
    end

    ax = gca;
    ax.FontSize = 20;
    ylabel('Latitude'); xlabel('Longitude');
    ticks = -100:20:100;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = '$mmol \cdot m^{-1} \cdot s^{-1}$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
    set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
    set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);
    caxis([-100 100]); 

    savefig('BEUTI_LTM.fig'); close;
    %% cut
    arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
    R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

    ind1=double(inpolygon(LON,LAT,lonb1,latb1));
    ind1(ind1==0)=NaN;

    lati=LAT(1,:); loni=LON(:,1);
    indxlat=find(lati>=-20 & lati<=-5);

    nBEUTI=BEUTI.*ind1.*mask;
    cBEUTI=nBEUTI(:,indxlat,:);
    %% 
    % if flag==1
    % figure
    % [c,h]=contourf(loni,lati(indxlat),squeeze(cBEUTI(:,:,10)'),[-100:1:100]);shading flat; colorbar; 
    % cmocean('balance',13); set(h,'LineColor','none');
    % axis([-90 -70 -20 -5]);
    % 
    % title('BEUTI Index','fontsize',16); 
    % caxis([-100 100]);
    % end
    %%
    time = [1:12]';
    Mean_BEUTI=permute(mean(cBEUTI,1,'omitnan'),[2 3 1]);

    %time2=linspace(1990,2010.99,length(time))';
    %pcolor(time2,Mean_Bakun); shading flat;
    latCUTI=lati(indxlat);
    %% 

    [~,ylab] = generateYLabels(20,5,5);
    %% Climatology

    timeclim=1:12;
    ylab={'20S','15S','10S','5S'};
    xlab={'J','F','M','A','M','J','J','A','S','O','N','D'};


    figure
    [c,h]=contourf(timeclim,latCUTI,Mean_BEUTI*-1,[-500:1:500]);shading flat; colorbar; 
    cmocean('balance',21); clabel(c,h);set(h,'LineColor','none'); 
    hold on
    % [c,h]=contour(timeclim,latCUTI,climBEUTI,[-100:20:100],'Color',grey);
    % clabel(c,h);
    title('BEUTI Climatology','fontsize',22); 
    ax = gca;
    ax.FontSize = 20;
    ylabel('Latitude'); xlabel('Months');
    caxis([-100 100]);
    ticks = -100:20:100;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = '$mmol \cdot m^{-1} \cdot s^{-1}$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
    set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
    set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);

    savefig('BEUTI_clim.fig');
    close 

    %% 
    BEUTI_latitudinal = mean(Mean_BEUTI, 2,'omitnan')*-1;

    %% SAVE

    save('BEUTI','time','latCUTI','Mean_BEUTI','BEUTI_latitudinal','BEUTI');
