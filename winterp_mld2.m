function w_interp_mld = winterp_mld2(w, z, mld_depths)
% This function interpolates the vertical velocity (W) at mixed layer depths (MLD).
% Inputs:
%   w: 3D matrix of vertical velocity (W) data (rho,lat,lon).
%   z: 3D matrix of depths (rho,lat,lon).
%   mld_depths: Array of mixed layer depths (MLD) (lat,lon).
% Output:
%   w_interp_mld: Interpolated vertical velocity (W) at MLD depths (lat,lon).

% Get the size of latitude and longitude grids
[~, lat_size, lon_size] = size(w);

% Preallocate output matrix
w_interp_mld = NaN(lat_size, lon_size);

% Iterate over each grid point
parfor lat_idx = 1:lat_size
    for lon_idx = 1:lon_size
        % Extract W velocity and depth profile at the current grid point
        w_profile = squeeze(w(:, lat_idx, lon_idx));
        z_profile = squeeze(z(:, lat_idx, lon_idx));
        mldi=mld_depths(lat_idx, lon_idx);
        
        % Find the nearest neighbor level for each MLD depth
        Idx = knnsearch( abs(z_profile),mldi);
        
        % Interpolate W velocity at the nearest level
        w_interp_mld(lat_idx, lon_idx) = w_profile(Idx);
    end
    disp(lat_idx)
end
