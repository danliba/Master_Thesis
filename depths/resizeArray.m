function interpolatedArray = resizeArray(originalArray)
    % Create the original grid coordinates
    [X, Y] = meshgrid(1:size(originalArray, 2), 1:size(originalArray, 1));
    
    % Create the new grid coordinates with an extra row
    newX = linspace(1, size(originalArray, 1)+1, size(originalArray, 1)+1)';
    newY = linspace(1, size(originalArray, 2), size(originalArray, 2))';
    
    % Perform linear interpolation
    interpolatedArray = interp2(X, Y, originalArray, LON, LAT, 'linear');
end
