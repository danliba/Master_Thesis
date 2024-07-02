function customColormap = customColormap(nColors)

% Define desired color values at specific points
colors = [ ...
    0.2 0.2 1;  % Light blue for negative values
    1 1 1;      % White around 0
    1 1 0.8;    % Yellow for low positive values
    1 0.8 0.4;  % Orange for mid-range positive values
    1 0 0;      % Red for high positive values
];

% Define values representing color transitions
values = linspace(-0.8, 1.6, size(colors, 1));

% Create empty colormap array
customColormap = zeros(nColors, 3);

% Define new values linearly spaced throughout the desired range
newValues = linspace(-0.8, 1.6, nColors);

% Use interp1 to interpolate color across specified values
for i = 1:3
    interpolatedValues = interp1(values, colors(:, i), newValues);
    % Ensure RGB values are within [0, 1] range
    customColormap(:, i) = max(0, min(1, interpolatedValues));
end

end
