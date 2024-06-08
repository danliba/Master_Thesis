%create clim
function climato = calculate_climatology(variable, time)
    jj = 0;
    time = time';
    [~, mo] = datevec(time');

    climato = zeros(size(variable, 1), 12);

    for imo = 1:12
        indxclim = find(mo == imo);
        climato(:, imo) = mean(variable(:, indxclim), 2, 'omitnan');
    end
end
