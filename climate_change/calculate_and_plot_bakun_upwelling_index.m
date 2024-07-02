function calculate_and_plot_bakun_upwelling_index(in_path)
    % Function to calculate, plot, and save the Bakun Upwelling Index (BUI)
    %
    % Example usage:
    %     calculate_and_plot_bakun_upwelling_index()

    % Clear all variables and close all figures
    %clear all; close all; clc;
    
    % Add path for additional data
    addpath('/Users/dlizarbe/Documents/DANIEL/2001_2010');
    cd(in_path);
    
    % Initialize and get data
    [mask, LON, LAT, ~,~] = lets_get_started_CC;
    mask(mask == 0) = NaN;
    cd(in_path);

    % Load mean files
    %cd('/Volumes/BM_2022_x/Hindcast_1990_2010/means');
    hdir = dir('avg*.nc');
    
    % Create meshgrid
    [Xu, Yu] = meshgrid(LON(1:end-1,1), LAT(1,:));
    [Xv, Yv] = meshgrid(LON(:,1), LAT(1,1:end-1));

    % Constants
    g = 9.81;
    rho_seawater = 1025;
    theta = -112.2699; % change according to the upwelling lengthscale

    % Preallocate variables
    jj = 0;
    BUI = [];
    UE = [];
    time = [];

    % Distance to coast
    %x = dist2coast(LAT, LON);
    %[dx, dy] = gradient(x);
    %coastline_orientation_angle = atan2(dy, dx); % in radians

    % Loop through years and months
    for ii=1:1:length(hdir)
            jj = jj + 1;
            fn = hdir(ii).name;
            disp(fn)

            % Load wind stress data
            uwind = double(ncread(fn, 'sustr'));
            vwind = double(ncread(fn, 'svstr'));
            
            % Regrid wind stress data
            Taux = interp2(Xu, Yu, uwind', LON', LAT', 'linear')'; % m/s
            Tauy = interp2(Xv, Yv, vwind', LON', LAT', 'linear')'; % m/s

            % Load Coriolis parameter
            f = double(ncread(fn, 'f'));
            
            % Calculate Ekman transport
            Ue = (Tauy ./ (rho_seawater .* f));
            %Ve = -(Taux ./ (rho_seawater .* f));
            
            % Calculate Bakun Index
            BUI(:,:,jj) = Ue .* cosd(theta);    
            %time(jj) = datenum(iy, imo, 15);
            UE(:,:,jj) = Ue;
   
    end


    % Load saved Bakun Index data and additional data
    %load('BakunIndex_Final.mat');
    Humboldt_ports;

    % Calculate long-term mean Bakun Index
    LTM_BUI = mean(BUI, 3, 'omitnan');

    % Plotting
    [~, ylab] = generateYLabels(20, 5, 5);
    [~, xlab] = generateXLabels(90, 70, 5);

    figure;
    P = get(gcf, 'position');
    P(3) = P(3) * 1;
    P(4) = P(4) * 1;
    set(gcf, 'position', P);
    set(gcf, 'PaperPositionMode', 'auto');

    [c, h] = contourf(LON, LAT, LTM_BUI .* mask, [-10:0.1:10]);
    colorbar;
    cmocean('balance', 41);
    colorbar;
    title('Bakun Index');
    set(h, 'LineColor', 'none');
    hold on;

    for i = 1:5
        key = Puertos{i, 1}; % Get port name
        x = Puertos{i, 2}(2); % Get longitude
        y = Puertos{i, 2}(1); % Get latitude
        plot(x, y, 'ko--', 'markerfacecolor', 'm');
        text(x + 0.2, y, key, 'FontSize', 14); % Plot text
    end

    ax = gca;
    ax.FontSize = 20;
    caxis([-2 2]);
    ylabel('Latitude');
    xlabel('Longitude');
    ticks = -2:0.5:2;
    c = colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = 'm$^{2}$/s';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
    set(gca, 'ytick', [-20:5:-5], 'yticklabel', ylab, 'ylim', [-20 -5]);
    set(gca, 'xtick', [-90:5:-70], 'xticklabel', xlab, 'xlim', [-90 -70]);

    savefig('BUI_LTM.fig');

    % Load KML file and apply mask
    arch_kml_zona1 = '/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
    R1 = kml2struct(arch_kml_zona1);
    lonb1 = R1.Lon;
    latb1 = R1.Lat;

    ind1 = double(inpolygon(LON, LAT, lonb1, latb1));
    ind1(ind1 == 0) = NaN;

    lati = LAT(1,:);
    loni = LON(:,1);
    indxlat = find(lati >= -20 & lati <= -5);

    nBUI = BUI .* ind1 .* mask;
    cBUI = nBUI(:, indxlat, :);

    time = time';
    Mean_Bakun = permute(mean(cBUI, 1, 'omitnan'), [2 3 1]);

    time2 = [1:1:12]';
    latBakun = lati(indxlat);

    Bakun_ts = mean(Mean_Bakun, 1, 'omitnan');


    % Plot climatology
    timeclim = 1:12;
    [~, ylab] = generateYLabels(20, 5, 5);
    xlab = {'J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'};

    figure;
    P = get(gcf, 'position');
    P(3) = P(3) * 1;
    P(4) = P(4) * 1.2;
    set(gcf, 'position', P);
    set(gcf, 'PaperPositionMode', 'auto');

    [c, h] = contourf(timeclim, latBakun, Mean_Bakun, [-10:0.1:10]);
    shading flat;
    colorbar;
    cmocean('balance', 13);
    clabel(c, h);
    set(h, 'LineColor', 'none');
    title('Bakun Index', 'fontsize', 22);
    ax = gca;
    ax.FontSize = 20;
    ylabel('Latitude');
    xlabel('Months');
    caxis([-3 3]);
    ticks = -3:1:3;
    c = colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = 'm$^{2}$/s';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
    set(gca, 'ytick', [-20:5:-5], 'yticklabel', ylab, 'ylim', [-20 -5]);
    set(gca, 'xtick', [1:1:12], 'xticklabel', xlab, 'xlim', [1 12]);
    
    savefig('BUI_clim.fig');
    % Save final results
        % Save Bakun Index data
    %cd('/Volumes/BM_2022_x/Hindcast_1990_2010/Indices');
    %save('BakunIndex_Final.mat', 'LON', 'LAT', 'BUI', 'mask', 'time', 'UE');

    save('BUI.mat', 'BUI', 'Bakun_ts', 'Mean_Bakun', 'latBakun');
end

