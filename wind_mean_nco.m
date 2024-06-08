clear all; close all; clc;
cd /Volumes/BM_2022_x/Hindcast_1990_2010/inout
%% 
yy=1990:2010; mo=1:12;

fid = fopen('average_CrocoWinds.sh','wt');

for iy=yy(1):1:yy(end)

    for imo=mo(1):1:mo(end)

    crocoin=sprintf('croco_blk_NCEP2_Y%dM%d.nc',iy,imo);
    crocout=sprintf('MeanWind_Y%dM%d.nc',iy,imo);

  
    nco_code=['ncra ', '-d bulk_time,0 ', crocoin,' ', crocout,';'];
    disp(nco_code)
    fprintf(fid,'%s\n',nco_code);
    end
end

fclose(fid);