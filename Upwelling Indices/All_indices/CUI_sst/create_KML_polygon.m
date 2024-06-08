function create_KML_polygon(X, LON, LAT, filename, coastline_length_km)
    % Apply mask to data
    range0 = [-90 -70 -33 10];
    loni = LON(:,1);
    lati = LAT(1,:);
    maskWc = double(range0(1) <= loni & loni <= range0(2) &...
                    range0(3) <= lati & lati <= range0(4));
    maskWc(maskWc == 0) = NaN;
    X_masked = X .* maskWc;

    % Extract coastline
    [lonk, latk] = Extract_CoastLine(X_masked, loni, lati, coastline_length_km);

    % Create KML file
    latitude = cat(2, latk, latk(1));
    longitude = cat(2, lonk, lonk(1) + 40);
    fid = fopen(filename, 'w');
    fprintf(fid, '<?xml version="1.0" encoding="UTF-8"?>\n');
    fprintf(fid, '<kml xmlns="http://www.opengis.net/kml/2.2">\n');
    fprintf(fid, '<Document>\n');
    fprintf(fid, '<name>Polygon Export</name>\n');

    % Write the polygon geometry to the KML file
    fprintf(fid, '<Placemark>\n');
    fprintf(fid, '<name>Polygon</name>\n');
    fprintf(fid, '<Polygon>\n');
    fprintf(fid, '<outerBoundaryIs>\n');
    fprintf(fid, '<LinearRing>\n');
    fprintf(fid, '<coordinates>\n');
    for i = 1:numel(longitude)
        fprintf(fid, '%f,%f,0\n', longitude(i), latitude(i));
    end
    fprintf(fid, '</coordinates>\n');
    fprintf(fid, '</LinearRing>\n');
    fprintf(fid, '</outerBoundaryIs>\n');
    fprintf(fid, '</Polygon>\n');
    fprintf(fid, '</Placemark>\n');

    % Close KML tags and file
    fprintf(fid, '</Document>\n');
    fprintf(fid, '</kml>\n');
    fclose(fid);

    % Display confirmation message
    disp(['KML file saved as: ' filename]);
end
