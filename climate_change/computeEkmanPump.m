function computeEkmanPump(dataPath, outputFileName)
    % Initialize and set paths
    %clear all; close all; clc;
    addpath /Users/dlizarbe/Documents/DANIEL/2001_2010
    cd(dataPath);
    [mask,LON,LAT,~,~]=lets_get_started_CC;
    mask(mask == 0) = NaN;

    % Change directory to means
    cd(fullfile(dataPath));
    %hdir = dir('croco_avg_Y*.nc.1');
    hdir = dir('avg_Y*.nc');
    
    [Xu, Yu] = meshgrid(LON(1:end-1, 1), LAT(1, :));
    [Xv, Yv] = meshgrid(LON(:, 1), LAT(1, 1:end-1));
    g = 9.81;
    [dx, dy] = cdtdim(LAT, LON);
    rho_seawater = 1025;
    jj = 0;

    % Loop through years and months
for ii=1:1:length(hdir)
    fn=hdir(ii).name;
    disp(fn)
            jj = jj + 1;
    
            % Read wind stress data
            uwind = double(ncread(fn, 'sustr'));
            vwind = double(ncread(fn, 'svstr'));

            % Regrid wind stress
            Taux = interp2(Xu, Yu, uwind', LON', LAT', 'linear')' .* mask; % m/s
            Tauy = interp2(Xv, Yv, vwind', LON', LAT', 'linear')' .* mask; % m/s

            % Read Coriolis parameter
            f = double(ncread(fn, 'f'));

            % Compute Ekman transport
            Ue = (Tauy ./ (rho_seawater .* f));
            Ve = -(Taux ./ (rho_seawater .* f));

            % Compute divergence and curl of wind stress
            for k = 1:size(Tauy, 3)
                [~, dUdy] = gradient(Tauy(:, :, k) ./ dy);
                [dVdx, ~] = gradient(Taux(:, :, k) ./ dx);
                Cz(:, :, k) = dVdx - dUdy;
            end

            D = dUdy + dVdx;
            C = cdtcurl(LAT, LON, Taux, Tauy) .* mask;
            D = D .* sign(LAT);

            % Store results
            Curl(:, :, jj) = C;
            Divergence(:, :, jj) = D;
            Crosshore_wind(:, :, jj) = Taux;
            VTauy(:, :, jj) = Tauy;
            EK_pump(:, :, jj) = C ./ (rho_seawater .* f);
            UEK(:, :, jj) = Ue;
            VEK(:, :, jj) = Ve;
end
    % Compute long-term mean Ekman pump
    LTM_ekpump = mean(EK_pump, 3, 'omitnan');

    % Save results
    save(outputFileName, 'EK_pump', 'UEK', 'VEK', 'LTM_ekpump', 'Curl', 'Crosshore_wind', 'Divergence', 'VTauy');
end
