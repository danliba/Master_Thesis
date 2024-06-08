cd /Volumes/BM_2022_x/Hindcast_1990_2010/means/
yr=1990:2010;
mo=1:12;

jj=0;
for iy=yr(1):1:yr(end)
    
    for imo=mo(1):1:mo(end)
        
        fn=sprintf('/Volumes/BM_2022_x/Hindcast_1990_2010/means/Mean_Y%dM%d.nc',iy,imo);
        %fn2=;
        disp(fn)
        jj=jj+1;
        %uwspeed=;
        %vwspeed=;
       SST=double(ncread(fn,'temp'));
       SSTi(:,:,jj) = SST(:,:,end);
       
       %savename = sprintf('SST_Y%dM%d.mat',iy,imo);
       %save(savename,'SSTi');

    end
end
%% save
cd /Volumes/BM_2022_x/Hindcast_1990_2010/Indices/SST
save('SST.mat','SSTi');