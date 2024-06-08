% Open the input netcdf file
%[ncid, info] = netcdf.inq('croco_avg_Y2001M1.nc');
fn='croco_avg_Y2001M1.nc';
ncid = netcdf.open(fn, 'NC_NOWRITE');

% Get information about dimensions and variables
[dimname, dimlength] = netcdf.inqDim(ncid,0);
[varname,xtype,dimids,natts] = netcdf.inqVar(ncid,0);

% Find the desired variables (replace with your actual variable names)
zeta_varid = netcdf.inqVarID(ncid, 'zeta');
ubar_varid = netcdf.inqVarID(ncid, 'ubar');
vbar_varid = netcdf.inqVarID(ncid, 'vbar');
u_varid = netcdf.inqVarID(ncid, 'u');
v_varid = netcdf.inqVarID(ncid, 'v');
temp_varid = netcdf.inqVarID(ncid, 'temp');

% Get data for each variable
zeta = netcdf.getVar(ncid, zeta_varid);
ubar = netcdf.getVar(ncid, ubar_varid);
vbar = netcdf.getVar(ncid, vbar_varid);
u = netcdf.getVar(ncid, u_varid);
v = netcdf.getVar(ncid, v_varid);
temp = netcdf.getVar(ncid, temp_varid);

% Close the input netcdf file
netcdf.close(ncid);

% Calculate time average (modify based on your desired averaging)
zeta_avg = mean(zeta, 4); % Average over all time steps
ubar_avg = mean(ubar(1:end-1,:,:), 3); % Average over all but last timestep and vertical dimension
vbar_avg = mean(vbar(1:end-1,:,:), 3);
u_avg = mean(u, 4); % Average over all time steps
v_avg = mean(v, 4);
temp_avg = mean(temp, 4);

% Create a new netcdf file (adjust dimensions and names as needed)
ncid = netcdf.create('New_croco.nc', 'NC_CREATE');

% Define dimensions
xi_rho_dimid = netcdf.defDim(ncid, 'xi_rho', dimlength(1));
eta_rho_dimid = netcdf.defDim(ncid, 'eta_rho', dimlength(2));
s_rho_dimid = netcdf.defDim(ncid, 's_rho', size(u,3)); % Assuming same for other 3D variables
time_dimid = netcdf.defDim(ncid, 'time', 1);

% Define variables
zeta_varid = netcdf.defVar(ncid, 'zeta', 'single', [xi_rho_dimid eta_rho_dimid]);
ubar_varid = netcdf.defVar(ncid, 'ubar', 'single', [xi_rho_dimid eta_rho_dimid]);
vbar_varid = netcdf.defVar(ncid, 'vbar', 'single', [xi_rho_dimid eta_rho_dimid]);
u_varid = netcdf.defVar(ncid, 'u', 'single', [xi_rho_dimid eta_rho_dimid s_rho_dimid]);
v_varid = netcdf.defVar(ncid, 'v', 'single', [xi_rho_dimid eta_rho_dimid s_rho_dimid]);
temp_varid = netcdf.defVar(ncid, 'temp', 'single', [xi_rho_dimid eta_rho_dimid s_rho_dimid]);

% Copy attributes (optional)
% ... (similar to original code)

% Write averaged data to variables
netcdf.putVar(ncid, zeta_varid, zeta_avg);
netcdf.putVar(ncid, ubar_varid, ubar_avg);
netcdf.putVar(ncid, vbar_varid, vbar_avg);
netcdf.put
