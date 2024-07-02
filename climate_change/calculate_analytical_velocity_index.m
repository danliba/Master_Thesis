function calculate_analytical_velocity_index(input_path)
    % Function to calculate and plot Analytical Vertical Velocity Index
    %
    % Example usage:
    %     calculate_analytical_velocity_index()

    % Clear all variables and close all figures
    %clear all; close all; clc;
    
    % Initialize and get data
    [mask, LON, LAT, ~, ~] = lets_get_started_CC;

    cd(input_path);

    % Load necessary data
    load(fullfile(input_path,'Wc_mean_wstrss.mat')); % Wc
    %load('Ekman_We_wind.mat'); % WSCD
    load(fullfile(input_path,'EKMAN_pump.mat'));
    
    Humboldt_ports;

    % Calculate Analytical Vertical Velocity Index
    W_analytical = LTM_ekpump + Wc_mean;
    W_a = WcMean + EK_pump;
    W_amean = nanmean(W_a, 3);

    % Plot results
    plot_analytical_velocity(LON, LAT, W_amean, mask);
    savefig('LTM_AnalyticalVel.fig');

    % Cut the area and mask
    arch_kml_zona1 = '/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
    R1 = kml2struct(arch_kml_zona1);
    lonb1 = R1.Lon; latb1 = R1.Lat;
    ind1 = double(inpolygon(LON, LAT, lonb1, latb1));
    ind1(ind1 == 0) = NaN;

    W_analytical = W_a .* ind1 .* mask;

    flag = 0;
    if flag == 1
        pcolor(W_analytical(:, :, 1)' .* 86400); shading flat;
        caxis([-2 2]); cmocean('balance');
    end

    % Calculate Monthly Analytical velocity
    [Monthly_wa, lati, time, Wa_ts] = calculate_monthly_velocity(W_analytical, LAT);

    if flag == 1
        plot_monthly_velocity(time, lati, Monthly_wa, Wa_ts);
    end

    % Calculate Climatology
    %climWa = calculate_climatology(Monthly_wa, time);

    % Plot Climatology
    plot_climatology(Monthly_wa, lati);
    savefig('Analytical_vel_clim.fig');
    % Save results
    save('W_analytical.mat', 'time', 'Wa_ts', 'Monthly_wa', 'lati');
end

function plot_analytical_velocity(LON, LAT, W_amean, mask)
    % Generate and plot Analytical Velocity
    [~, ylab] = generateYLabels(20, 5, 5);
    [~, xlab] = generateXLabels(90, 70, 5);

    figure;
    P = get(gcf, 'position');
    P(3) = P(3) * 1;
    P(4) = P(4) * 1;
    set(gcf, 'position', P);
    set(gcf, 'PaperPositionMode', 'auto');

    [c, h] = contourf(LON, LAT, W_amean .* mask .* 86400, [-10:0.1:10]); 
    axis([-90 -70 -20 -5]);
    caxis([-3 3]);
    cmocean('balance', 13);
    colorbar;
    title('LTM Analytical Velocity');
    set(h, 'LineColor', 'none');
    hold on;

    Humboldt_ports;

    for i = 1:5
        key = Puertos{i, 1}; % Get port name
        x = Puertos{i, 2}(2); % Get longitude
        y = Puertos{i, 2}(1); % Get latitude
        plot(x, y, 'ko--', 'markerfacecolor', 'm');
        text(x + 0.2, y, key, 'FontSize', 14); % Plot text
    end

    ax = gca;
    ax.FontSize = 20;
    ylabel('Latitude');
    xlabel('Longitude');
    ticks = -3:1:3;
    c = colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
    set(gca, 'ytick', [-20:5:-5], 'yticklabel', ylab, 'ylim', [-20 -5]);
    set(gca, 'xtick', [-90:5:-70], 'xticklabel', xlab, 'xlim', [-90 -70]);
end

function [Monthly_wa, lati, time, Wa_ts] = calculate_monthly_velocity(W_analytical, LAT)
    % Calculate Monthly Analytical velocity
    indxlat = find(LAT(1, :) <= -5 & LAT(1, :) >= -20)';
    lati = LAT(1, indxlat)';
    time = [1:1:12]';

    Monthly_wa = permute(mean(W_analytical(:, indxlat, :), 1, 'omitnan'), [2 3 1]);
    Wa_ts = mean(Monthly_wa, 1, 'omitnan')';
end

function plot_monthly_velocity(time, lati, Monthly_wa, Wa_ts)
    % Plot Monthly Analytical velocity
    subplot(2, 1, 1);
    pcolor(time, lati, Monthly_wa .* 86400);
    shading flat;
    title('Monthly Analytical velocity');
    colorbar;
    caxis([-4 4]);
    cmocean('balance', 17);

    subplot(2, 1, 2);
    plot(time, Wa_ts);
end

% function climWa = calculate_climatology(Monthly_wa, time)
%     % Calculate Climatology
%     jj = 0;
%     [yr, mo] = datevec(time);
%     for imo = 1:12
%         indxclim = find(mo == imo);
%         climWa(:, imo) = mean(Monthly_wa(:, indxclim), 2, 'omitnan');
%     end
% end

function plot_climatology(Monthly_wa, lati)
    % Plot Climatology
    timeclim = 1:12;
    [~, ylab] = generateYLabels(20, 5, 5);
    xlab = {'J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'};

    figure;
    P = get(gcf, 'position');
    P(3) = P(3) * 1;
    P(4) = P(4) * 1.2;
    set(gcf, 'position', P);
    set(gcf, 'PaperPositionMode', 'auto');

    [c, h] = contourf(timeclim, lati, Monthly_wa .* 86400, [-10:0.1:10]);
    colorbar;
    cmocean('balance', 17);
    clabel(c, h);
    set(h, 'LineColor', 'none');
    hold on;
    title('Analytical Velocity', 'fontsize', 22);
    ax = gca;
    ax.FontSize = 20;
    ylabel('Latitude');
    xlabel('Months');
    caxis([-4 4]);
    ticks = -4:1:4;
    c = colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = '$\mathrm{m \cdot d^{-1}}$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
    set(gca, 'ytick', [-20:5:-5], 'yticklabel', ylab, 'ylim', [-20 -5]);
    set(gca, 'xtick', [1:1:12], 'xticklabel', xlab, 'xlim', [1 12]);
end
