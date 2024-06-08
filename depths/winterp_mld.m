function w_interp_mld = winterp_mld(w, z, mld_depths)
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
for lat_idx = 1:lat_size
    for lon_idx = 1:lon_size
        % Extract W velocity and depth profile at the current grid point
        w_profile = squeeze(w(:, lat_idx, lon_idx));
        z_profile = squeeze(z(:, lat_idx, lon_idx));

        % Find the nearest vertical level for each MLD depth
        [~, nearest_level] = min(abs(abs(z_profile) - mld_depths(lat_idx, lon_idx)));
        
        % Interpolate W velocity at the nearest level
        w_interp_mld(lat_idx, lon_idx) = w_profile(nearest_level);
    end
end
