function calculate_cuti_index(in_path,fname)
    % Calculate CUTI Index and save the results

    %% Initial Setup
    %clear all; close all; clc;
    addpath('/Users/dlizarbe/Documents/DANIEL/2001_2010');
    cd(in_path);
    
    % Load initial data
    [mask, LON, LAT, ~, ~] = lets_get_started_CC();
    mask(mask == 0) = NaN;
    cd(in_path);
    fn = fname;
    f = ncread(fn,'f');
    %% Load required data
    load(fullfile(in_path,'WMLD_MLD.mat'), 'MLD');
    load(fullfile(in_path,'SST_SSH.mat'), 'SSH');
    %---Load UEKman
    load(fullfile(in_path,'EKMAN_pump.mat'), 'UEK');    
    Humboldt_ports;
    
    %% Latitude calculations
    lati = LAT(1, :)';
    loni = LON(:, 1);
    lati1 = lati(1:end-1); 
    lati2 = lati(2:end);

    [~, IA1, ~] = intersect(lati, lati1);
    [~, IA2, ~] = intersect(lati, lati2);
    
    SSHA = SSH(:, IA1, :);
    SSHB = SSH(:, IA2, :);
    
    SSH2 = abs(SSHA - SSHB); % in meters
    
    %% Distance calculations
    R = 6371; % Earth radius in km
    distance_per_degree = (2 * pi * R) / 360;
    distance_between_latitudes = abs(lati2 - lati1) * distance_per_degree * 1000; % in meters
    distance_Array = repmat(distance_between_latitudes, 1, size(SSH2, 1))';
    latiCUTI = repmat(lati1, 1, size(SSH2, 1))';
    
    %% Mean SSH gradient calculation
    LTM_SSHgrad = mean(SSH2, 3, 'omitnan');
    
    %% Geostrophic velocity calculation
    g = 9.81;
    mld = MLD(:, IA1, :); % mixed layer depth
    ugeo = (g .* SSH2) ./ (f(:, IA1) .* distance_Array);
    Ugeo = ugeo .* mld;
    
    %% Interpolate geostrophic velocity
    LTM_UGEO = mean(Ugeo, 3, 'omitnan');
    [Xu, Yu] = meshgrid(LON(:, 1), latiCUTI(1, :));
    LTM_UGEO2 = interp2(Xu, Yu, LTM_UGEO', LON', LAT', 'linear')';
    
    %% Interpolate UGEO for each time step
    for ii = 1:size(SSH, 3)
        UGEO(:, :, ii) = interp2(Xu, Yu, ugeo(:, :, ii)', LON', LAT', 'linear')';
        disp(ii);
    end
    
    %% Calculate CUTI
    CUTI = UEK + UGEO;
    LTM_CUTI = mean(CUTI, 3, 'omitnan');
    LTM_UE = mean(UEK, 3, 'omitnan');
    
    %% Plot CUTI
    ylab={'20S','15S','10S','5S'};
    [~,xlab] = generateXLabels(90,70,5);
    
    %xlab={'J','F','M','A','M','J','J','A','S','O','N','D'};
    
    figure
    [c,h]=contourf(LON,LAT,LTM_CUTI*-1.*mask,[-100:1:100]);shading flat;
    axis([-90 -70 -20 -5]); cmocean('balance',21);
    colorbar;
    title('CUTI'); set(h,'LineColor','none');
    
    hold on
    for i = 1:length(Puertos)
        key = Puertos{i,1}; % Get port name
        x = Puertos{i,2}(2); % Get longitude
        y = Puertos{i,2}(1); % Get latitude
        plot(x,y,'ko--','markerfacecolor','m');
        text(x+0.2, y, key, 'FontSize', 14); % Plot text
    end
    
    ax = gca;
    ax.FontSize = 20;
    ylabel('Latitude'); xlabel('Longitude');
    ticks = -10:2:10;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = '$ m^{2} \cdot s^{-1}$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
    set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
    set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);
    caxis([-10 10]);
    savefig('LTM_CUTI.fig');
    close
    %% Mask and cut the area of interest
    arch_kml_zona1 = '/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
    R1 = kml2struct(arch_kml_zona1);
    lonb1 = R1.Lon; 
    latb1 = R1.Lat;
    
    ind1 = double(inpolygon(LON, LAT, lonb1, latb1));
    ind1(ind1 == 0) = NaN;
    
    lati = LAT(1, :); 
    loni = LON(:, 1);
    indxlat = find(lati >= -20 & lati <= -5);
    
    nCUTI = CUTI .* ind1 .* mask;
    cCUTI = nCUTI(:, indxlat, :);
    
    %% Calculate mean CUTI
    time = [1:12]';
    Mean_CUTI = permute(mean(cCUTI, 1, 'omitnan'), [2 3 1]);
    %time2 = linspace(1990, 2010.99, length(time))';
    latCUTI = lati(indxlat);
    
    
    %% Plot climatology if flag is set
    grey = [0.5 0.5 0.5];
    xlab={'J','F','M','A','M','J','J','A','S','O','N','D'};
    timeclim = 1:12;
    
    figure;
    
    [c, h] = contourf(timeclim, latCUTI, Mean_CUTI*-1, [-20:0.1:20]);
    shading flat;
    colorbar;
    cmocean('balance', 21);
    clabel(c, h);
    set(h, 'LineColor', 'none');
    hold on;
     title('CUTI Climatology', 'fontsize', 22);
    ax = gca;
    ax.FontSize = 20;
    ylabel('Latitude');
    xlabel('Months');
    caxis([-10 10]);
    ticks = -10:2:10;
    c = colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = 'm^{2}/s';
    c.Label.FontSize = 20;
    set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
    set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
    savefig('climato_CUTI.fig');
    close

    %% Calculate latitudinal CUTI
    CUTI_latitudinal = mean(Mean_CUTI*-1, 2, 'omitnan'); 
    %% Save results
    
    save('CUTI', 'time', 'latCUTI', 'Mean_CUTI', 'CUTI_latitudinal', 'CUTI');
end
