function [sst,ssh]=get_SST_SSH(fn)
    
    start = [1, 1, 32, 1]; % Start at the first element for xi_rho, eta_rho, and time, and the 32nd element for s_rho
    count = [Inf, Inf, 1, Inf]; % Read all elements in xi_rho and eta_rho, 1 element in s_rho (the 32nd layer), and all elements in time
    sst = ncread(fn, 'temp', start, count);
    ssh = ncread(fn,'zeta');

end