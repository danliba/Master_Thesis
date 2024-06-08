function [tau_x, tau_y] = calculate_wind_stress(u_wind, v_wind, rho_air,cd)
    % Constants
    Cd = cd; % Drag coefficient
    % rho_air = 1.2; % Air density (kg/m^3), if not provided as argument

    % Wind speed magnitude
    wind_speed = sqrt(u_wind.^2 + v_wind.^2);

    % Wind stress components
    tau_x = -Cd * rho_air * u_wind .* wind_speed;
    tau_y = -Cd * rho_air * v_wind .* wind_speed;
end