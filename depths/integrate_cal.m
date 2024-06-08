function [VAR] = integrate_cal(var,zw,z,z01,z02)

%----------------------------calculate integrated diags------------------------------%
% [VAR] = integrate_cal(var,zw,z,z01,z02)
% var : CROCO variable at RHO-points (3D matrix)
% zw  : Depth of the W-points (3D matrix)
% zr  : Depth of the RHO-points (3D matrix)
% z01 : lower limit of integration (scalar)
% z02 : upper limit of integration (scalar)
%addpath /Users/txue/Documents/MATLAB/croco_tools-v1.0/Diagnostic_tools/Transport

for t=1:size(var,4)
    for k=1:size(var,3)
        for j=1:size(var,2)
            for i=1:size(var,1)
                vvar(k,j,i,t)=var(i,j,k,t);
            end
        end
    end
    [V,h0]=vintegr2(vvar(:,:,:,t),zw(:,:,:,t),z(:,:,:,t),z01,z02);
    VAR(:,:,t)=V';
    t
end
end
