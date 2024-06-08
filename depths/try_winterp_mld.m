[~, lat_size, lon_size] = size(ww);

mld_depths=mld';
mld_depths(mld_depths<0)=NaN;
% Preallocate output matrix
w_interp_mld = NaN(lat_size, lon_size);

% Iterate over each grid point
for lat_idx = 1:lat_size
    for lon_idx = 1:lon_size
        % Extract W velocity and depth profile at the current grid point
        w_profile = squeeze(ww(:, lat_idx, lon_idx));
        z_profile = squeeze(z(:, lat_idx, lon_idx));
        
        % Find the nearest vertical level for each MLD depth
        [value, nearest_level] = min(abs(z_profile + mld_depths(lat_idx, lon_idx)));
        
        
        % Interpolate W velocity at the nearest level
        w_interp_mld(lat_idx, lon_idx) = w_profile(nearest_level);
    end
end

%% 
figure
parfor lat_idx = 1:lat_size
    for lon_idx = 1:lon_size
        w_profile = squeeze(ww(:, lat_idx, lon_idx));
        z_profile = squeeze(z(:, lat_idx, lon_idx));
        mld2=mld_depths(lat_idx, lon_idx);

%         subplot(1,3,1)
%         plot(w_profile,z_profile); title('W');
%         ylim([-100 0])
% 
%         subplot(1,3,2)
%         plot(z_profile); title('Z');
%         hold on
%         ylim([-100 0])
% 
%         subplot(1,3,3)
%         plot(mld2,'*','MarkerSize',12); 
%         pause(1)
%         clf
%         
        Idx = knnsearch( abs(z_profile),mld2);
        w_interp_mld(lat_idx, lon_idx) = w_profile(Idx);
    end
    disp(lat_idx)
end
