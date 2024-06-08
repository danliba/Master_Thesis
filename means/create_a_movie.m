%%------------- Make a Movie -------------%
%This function creates a movie of your main designed 3D variable
%Time should be the third dimension.

function []=create_a_movie(LON,LAT,variable3D,time,axis_range);

%aviobj=QTWriter('Hot-Blob','FrameRate',2);
%aviobj.Quality=100;

figure
P=get(gcf,'position');
P(3)=P(3)*1.5;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

for ii=1:1:length(time)
    
    pcolor(LON,LAT,variable3D); shading flat;
    axis(axis_range);
end
end
