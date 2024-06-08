cd E:\Hindcast_1990_2010    

hdir=dir("*.ncra.tmp");

fid = fopen('average_2_croco.sh','wt');

for ii=1:1:length(hdir)
    croco_in=['croco_avg' hdir(ii).name(5:15)];
    croco_out=[hdir(ii).name(1:15)];

    nco_code=['ncra ', '-d time,0 ', croco_in,' ', croco_out,';'];
    disp(nco_code)
    fprintf(fid,'%s\n',nco_code);

end