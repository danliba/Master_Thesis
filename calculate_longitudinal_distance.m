function distance_km = calculate_longitudinal_distance(latitude,degrees_longitude)
    % Radius of the Earth in kilometers
    R = 6371; % Mean radius of the Earth in kilometers

    % Convert latitude from degrees to radians
    lat_rad = deg2rad(latitude);

    % Calculate the circumference of the Earth at the given latitude
    circumference = 2 * pi * R * cos(lat_rad);

    % Calculate the distance corresponding to 1 degree of longitude
    distance_per_degree = circumference / 360;

    % Calculate the distance corresponding to X degrees of longitude
    distance_km = degrees_longitude * distance_per_degree;
end
