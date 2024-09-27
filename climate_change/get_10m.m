
function get_10m(inpath, pattern)
cd(inpath);

%% Monthly average
[mask,LON,LAT,~]=lets_get_started_CC;
mask(mask==0)=NaN;

cd(inpath)
dir1=dir(pattern);

indxlat = find(LAT(1,:)>= -16 & LAT(1,:)<=-5);
indxlon = find(LON(:,1)>= -85 & LON(:,1)<=-75);

lati=LAT(1,indxlat); loni = LON(indxlon,1);
[LONi,LATi]=meshgrid(loni,lati);


ij=0;
for ik=1:1:length(dir1)
    
    ij=ij+1;
    fn=dir1(ik).name;
    disp(fn)
    
    %----w50 and w30m----%
    w_10m=get_W_m(fn,-10);
    W10m(:,:,ij)=w_10m;
    
    %     w_10m=get_W_m(fn,-10);
    %     W10m(:,:,ij)=w_10m;
    %
end

%%
cd(inpath);
%save('W_diff_depth2','W20m','W10m');
save('W_diff_depth10','W10m');
end