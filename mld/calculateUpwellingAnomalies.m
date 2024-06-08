function [Curl_ts,Curl_anom, lat_Curl,lat_Curl_anom] = calculateUpwellingAnomalies(LON, LAT, Curl, mask)
    
    time = generate_monthly_time_vector(1990, 2010)';

    % Load KML file
    arch_kml_zona1 = '/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
    R1 = kml2struct(arch_kml_zona1);
    lonb1 = R1.Lon;
    latb1 = R1.Lat;

    % Create indicator for upwelling region
    ind1 = double(inpolygon(LON, LAT, lonb1, latb1));
    ind1(ind1 == 0) = NaN;

    % Select latitude range for upwelling region
    lati = LAT(1,:);
    loni = LON(:,1);
    indxlat = find(lati >= -20 & lati <= -5);

    % Extract MLD data for upwelling region
    nCurl = Curl .* ind1 .* mask;
    cCurl = nCurl(:, indxlat, :);

    %% ------- Curl ------ % 
    % Calculate mean curl
    Mean_Curl = permute(mean(cCurl, 1, 'omitnan'), [2 3 1]);
    Curl_ts = mean(Mean_Curl, 1, 'omitnan')';
    lat_Curl = mean(Mean_Curl, 2, 'omitnan');

    %% --------- Climatology --------- %
    % Calculate climatology
    jj=0;
    [yr,mo]=datevec(time);

    for imo = 1:12
        indxclim = find(mo == imo);
        climCurl(imo,:) = mean(Curl_ts(indxclim,:), 1, 'omitnan');
        climMeanCurl(:,imo) = mean(Mean_Curl(:,indxclim), 2, 'omitnan');
    end

    %% ------ Anomalies ----- %% 
    jj = 0;
    for iy = yr(1):yr(end)
        for imo = mo(1):mo(end)
            jj = jj + 1;
            indxAnom = find(iy == yr & imo == mo);
            Curl_anom(jj,:) = Curl_ts(indxAnom) - climCurl(imo);
            CurlMean_anom(:,jj) = Mean_Curl(:,indxAnom) - climMeanCurl(:,imo);
        end
    end

    %% latitudinal anomaly
    lat_Curl_anom = mean(CurlMean_anom, 2, 'omitnan');
end
