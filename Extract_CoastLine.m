
function [lonk, latk]=Extract_CoastLine(X, lon, lat,coast_dist)

c=contourc(lon,lat,X',[coast_dist coast_dist]);

%plot(cc(1,2:end),cc(2,2:end),'.');

[m,n]=size(c);
flag=1;
endnum=0;
numdatap=0;
while flag==1
    numdata=c(2,endnum+1);
    if numdata > numdatap;
        lonk=c(1, endnum+2: endnum+1+numdata);
        latk=c(2, endnum+2: endnum+1+numdata);
        numdatap=numdata;
    end
    endnum=endnum+1+numdata;
    if endnum+1>n
        flag=-1;
     end
end

end