function [ylab, ylab2] = generateXLabels(max_lat, min_lat, step)
    % Initialize the cell array for y-labels
    numlabels = length(max_lat:-step:min_lat) + 1;
    ylab = cell(numlabels, 1);

    % Generate the latitude values from 20S to 5S
    for i = max_lat:-step:min_lat
        if i == min_lat
            ylab{max_lat + 1 - i} = [num2str(i) '°W'];
        else
            ylab{max_lat + 1 - i} = [num2str(i) '°W'];
        end
    end

    % Remove empty cells from ylab
    ylab2 = removeEmptyCells(ylab);
end

function nonEmptyCells = removeEmptyCells(cellArray)
    % Initialize a logical array to store the indices of non-empty cells
    nonEmptyIndices = ~cellfun(@isempty, cellArray);

    % Filter the cell array to keep only non-empty cells
    nonEmptyCells = cellArray(nonEmptyIndices);
end
