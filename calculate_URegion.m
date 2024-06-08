% This function calculates the upwelling region of 150km offshore and
% makes, cuts the rest and gives back the region inside

function [nWMLD,lati,cWMLD] = calculate_URegion(WMLD, LON, LAT, mask)
    % Read polygon coordinates from KML file
    arch_kml_zona='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';

    R1 = kml2struct(arch_kml_zona);
    lonb1 = R1.Lon;
    latb1 = R1.Lat;

    % Create indicator matrix based on polygon
    ind1 = double(inpolygon(LON, LAT, lonb1, latb1));
    ind1(ind1 == 0) = NaN;

    % Apply mask and polygon indicator to WMLD
    cWMLD = WMLD .* ind1 .* mask;

    % Find latitude indices between -5 and -20 degrees
    indxlat = find(LAT(1, :) <= -5 & LAT(1, :) >= -20)';
    lati = LAT(1, indxlat)';

    % Calculate mean nWMLD
    nWMLD = permute(mean(cWMLD(:, indxlat, :), 1, 'omitnan'), [2 3 1]);
end
