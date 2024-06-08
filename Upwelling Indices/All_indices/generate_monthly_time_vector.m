%generate time vectors
function time_vector = generate_monthly_time_vector(start_year, end_year)
    % Define the start and end dates
    start_date = datetime(start_year, 1, 1);
    end_date = datetime(end_year, 12, 1);

    % Create the monthly time vector
    time_vector = datenum(start_date:calmonths(1):end_date);
end
