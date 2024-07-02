function [mld,w_interp_mld]=get_W(fn)

  zr=get_depths(fn,fn,1,'rho'); %we get the depths using all the rho variables
    zw=get_depths(fn,fn,1,'w'); %we get the depths using all the wi variables
    
    mld = ncread(fn,'hbl');
    w=ncread(fn,'w');
    ww=permute(w,[3 2 1 4]);
    %wnew= vinterp(ww(:,:,:,st),zr(:,:,:,jj),50);
    
    w_interp_mld = winterp_mld(ww, zr,mld');
end