function [TN_mld,TN_S]=get_nitrogen(fn)
    
%------ Surface Nitrogen -------
    start = [1, 1, 32, 1]; % Start at the first element for xi_rho, eta_rho, and time, and the 32nd element for s_rho
    count = [Inf, Inf, 1, Inf]; % Read all elements in xi_rho and eta_rho, 1 element in s_rho (the 32nd layer), and all elements in time
    NO3 = ncread(fn, 'NO3', start, count);
    NO2 = ncread(fn, 'NO2', start, count);
    NH4 = ncread(fn, 'NH4', start, count);

    TN_S = NO3 + NO2 + NH4;

%------ Nitrogen MLD ------------ %
  zr=get_depths(fn,fn,1,'rho'); %we get the depths using all the rho variables
    zw=get_depths(fn,fn,1,'w'); %we get the depths using all the wi variables
    
    mld = ncread(fn,'hbl');
    no3=ncread(fn,'NO3');
    no2=ncread(fn,'NO2');
    nh4=ncread(fn,'NH4');
    
    no33=permute(no3,[3 2 1 4]);
    no22=permute(no2,[3 2 1 4]);
    nh44=permute(nh4,[3 2 1 4]);
    
    no333 = winterp_mld(no33, zr,mld');
    no222 = winterp_mld(no22, zr,mld');
    nh444 = winterp_mld(nh44, zr,mld');
    
    TN_mld = no333' + no222' + nh444';

end