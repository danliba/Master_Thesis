clear all
close all
clc
yy=1991:2010; mo=1:12;

fid = fopen('average_Croco.sh','wt');

for iy=yy(1):1:yy(end)

    for imo=mo(1):1:mo(end)

    boyain=sprintf('croco_avg_Y%dM%d.nc',iy,imo);
    boyaout=sprintf('Mean_Y%dM%d.nc',iy,imo);

  
    nco_code=['ncra ', '-d time,0 ', boyain,' ', boyaout,';'];
    disp(nco_code)
    fprintf(fid,'%s\n',nco_code);
    end
end

fclose(fid);

%% run bash code
!chmod u+rwx Cutclimat_boya.sh
!./Cutclimat_boya.sh

%% Daniel Lizarbe Barreto
%Climatologia boyas version 1.0 
%30/jun/2020
