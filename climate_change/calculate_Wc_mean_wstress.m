%calculate Bordbar Analytical Velocity
%clear all; close all; clc;
function calculate_Wc_mean_wstress(input_dir, output_file)
    % Function to calculate Wc mean wind stress
    %
    % Args:
    %     input_dir (str): Directory containing NetCDF files
    %     output_file (str): Path to the output MAT file
    %
    % Example usage:
    %     calculate_Wc_mean_wstress('/path/to/input/files', 'Wc_mean_wstrss.mat')

    % Clear all variables and close all figures
    

    % Add necessary paths
    addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
    [mask,LON,LAT,~,~]=lets_get_started_CC;
    mask(mask == 0) = NaN;

    % Get list of NetCDF files in the directory
    cd(input_dir);
    hdir = dir('avg*.nc');
    [Xu, Yu] = meshgrid(LON(1:end-1, 1), LAT(1, :));
    [Xv, Yv] = meshgrid(LON(:, 1), LAT(1, 1:end-1));

    % Load necessary data
    %load('/Users/dlizarbe/Documents/DANIEL/2001_2010/Z_2002_2010.mat');
    g = 9.81;
    load('rossby_radious_INPAINT.mat');
    WcSum = 0;

    % Define years and months
     jj = 0;

    % Loop through each year and month
    for ii=1:1:length(hdir)
            fn = hdir(ii).name;
            disp(fn)

            % Read wind stress data
            uwind = double(ncread(fn, 'sustr'));
            vwind = double(ncread(fn, 'svstr'));

            % Regrid uwind
            Taux = interp2(Xu, Yu, uwind', LON', LAT', 'linear')';
            % Regrid vwind
            Tauy = interp2(Xv, Yv, vwind', LON', LAT', 'linear')';

            % Calculate Coriolis parameter
            f = coriolisf(LAT);

            % Calculate Ekman transport
            rho_seawater = 1025;
            Ue = Tauy ./ (rho_seawater .* f);
            Ve = -Taux ./ (rho_seawater .* f);

            % Calculate distance to coast
            x = dist2coast(LAT, LON);
            [dx, dy] = gradient(x);
            coastline_orientation_angle = atan2(dy, dx);
            ny = cos(coastline_orientation_angle);
            Ucross_shore = Ue .* ny;

            % Calculate Wc
            r1 = R2 .* 1000; % in meters
            e1 = 2.7182818284;
            x1 = x .* 1000; % in meters
            Wc = (2.07 * Ucross_shore ./ r1) .* (e1 .^ (-(2.3026 .* x1) ./ r1));

            % Accumulate results
            jj = jj + 1;
            WcSum = Wc + WcSum;
            WcMean(:, :, jj) = Wc;
    end

    % Calculate mean Wc
    Wc_mean = WcSum / length(hdir);

    % Save results
    save(output_file, 'LON', 'LAT', 'Wc_mean', 'x', 'mask', 'WcMean');
end

