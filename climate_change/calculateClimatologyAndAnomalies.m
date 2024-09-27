function [climWMLD, anomWMLD] = calculateClimatologyAndAnomalies(Wmld, time)
    % Generates the time vector for the given range
    %time = generate_monthly_time_vector(startYear, endYear)';

    % Initialize variables
    [yr, mo] = datevec(time);
    climWMLD = [];
    anomWMLD = [];
    %----------- 3D --------- %
    if length(size(Wmld))>2
        % Calculate climatology for each month
        for imo = 1:12
            disp(imo);
            indxclim = find(mo == imo);
            climWMLD(:,:,imo) = mean(Wmld(:,:,indxclim), 3, 'omitnan');
        end

        % Calculate anomalies
        jj = 0;
        for iy = yr(1):yr(end)
            for imo = 1:12
                indxAnom = find(yr == iy & mo == imo);
                if ~isempty(indxAnom)
                    disp(datestr(time(indxAnom)));
                    jj = jj + 1;
                    anomWMLD(:,:,jj) = Wmld(:,:,indxAnom) - climWMLD(:,:,imo);
                end
            end
        end
    end
    %---------- 2D ------------- %
    if length(size(Wmld))==2
        for imo = 1:12
            disp(imo);
            indxclim = find(mo == imo);
            climWMLD(:,imo) = mean(Wmld(:,indxclim), 2, 'omitnan');
        end

        % Calculate anomalies
        jj = 0;
        for iy = yr(1):yr(end)
            for imo = 1:12
                indxAnom = find(yr == iy & mo == imo);
                if ~isempty(indxAnom)
                    disp(datestr(time(indxAnom)));
                    jj = jj + 1;
                    anomWMLD(:,jj) = Wmld(:,indxAnom) - climWMLD(:,imo);
                end
            end
        end
    end
end