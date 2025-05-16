
%% Flavor preference - WT mice
% Data
preference = [93.9, 83.9, 29.2, 46.0, 63.0, 38.0, 60.0, 28.6, 98.6, 72.0, ...
    91.2, 80.4, 61.0, 3.2, 79.4, 23.8, 65.2, 8.9, 93.8, 11.1, ...
    0.0472972972972973 * 100, 0.152 * 100, 0.194630872483221 * 100, 0.241071428571429 * 100, 0.0594594594594595 * 100, ...
    0.159574468085106 * 100, 0.21875 * 100, 0.225225225225225 * 100, 0.589473684210526 * 100, 0.606451612903226 * 100, ...
    0.709876543209877 * 100, 0.73469387755102 * 100, 0.25 * 100, 0.608433734939759 * 100, 0.611570247933884 * 100, ...
    0.766304347826087 * 100]; % yes I just pasted these in. Yes, this is hacky. So what
group = {'Backward', 'Backward', 'Forward', 'Forward', 'Control', 'Backward', 'Backward', 'Forward', 'Control', 'Control', ...
    'Backward', 'Backward', 'Forward', 'Forward', 'Control', 'Backward', 'Backward', 'Forward', 'Control', 'Control', ...
    'Forward-prev.', 'Forward-prev.', 'Forward-prev.', 'Forward-prev.', 'Forward-prev.', 'Forward-prev.', ...
    'Forward-prev.', 'Forward-prev.', 'Control-prev.', 'Control-prev.', ...
    'Control-prev.', 'Control-prev.', 'Control-prev.', 'Control-prev.', 'Control-prev.', 'Control-prev.'};
sex = {'M', 'M', 'M', 'M', 'M', 'F', 'F', 'F', 'F', 'F', 'F-JF', 'F-JF', 'F-JF', 'F-JF', 'F-JF', ...
    'M-JF', 'M-JF', 'M-JF', 'M-JF', 'M-JF', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U'};

% Get unique group names
uniqueGroups = {'Backward', 'Forward', 'Forward-prev.', 'Control', 'Control-prev.'};

% Create figure
figure;
hold on;

% Define x positions for the groups
xPositions = 1:length(uniqueGroups);

% Colors for the groups
groupColors = [0.9, 0.3, 0.3; ...
    0.2, 0.6, 0.8; 0.1, 0.5, 0.7; ...
    0.2, 0.6, 0.2; ...
    0.3, 0.7, 0.3];

% Define markers for sex - now M and M-JF use same marker, F and F-JF use same marker
maleMarker = 'o';
femaleMarker = 's';
unknownMarker = 'diamond';
markerSize = 60;

% Define color adjustment factor for JF mouseys - make them darker
colorAdjustFactor = 0.6; % Values less than 1 make colors darker

% Initialize
groupData = cell(1, length(uniqueGroups));

% Loop
for i = 1:length(uniqueGroups)
    % Find indices of mice in current group
    groupIndices = strcmp(group, uniqueGroups{i});

    % Get preference values for this group
    currGroupData = preference(groupIndices);
    currGroupSex = sex(groupIndices);

    % Store data for statistical analysis
    groupData{i} = currGroupData;

    % Plot individual data points with different markers based on sex
    for j = 1:length(currGroupData)
        % Set base color from group
        baseColor = groupColors(i, :);

        % Determine if this is a JF mouse and adjust color if needed
        if strcmp(currGroupSex{j}, 'M-JF')
            adjustedColor = baseColor * colorAdjustFactor; % darker shade for JF
            scatter(xPositions(i), currGroupData(j), markerSize, adjustedColor, maleMarker, 'filled');
        elseif strcmp(currGroupSex{j}, 'F-JF')
            adjustedColor = baseColor * colorAdjustFactor; % darker shade for JF
            scatter(xPositions(i), currGroupData(j), markerSize, adjustedColor, femaleMarker, 'filled');
        elseif strcmp(currGroupSex{j}, 'M')
            scatter(xPositions(i), currGroupData(j), markerSize, baseColor, maleMarker, 'filled');
        elseif strcmp(currGroupSex{j}, 'F')
            scatter(xPositions(i), currGroupData(j), markerSize, baseColor, femaleMarker, 'filled');
        else
            scatter(xPositions(i), currGroupData(j), markerSize, baseColor, unknownMarker, 'filled');
        end
    end

    % Calculate mean and standard error
    groupMean = mean(currGroupData);
    groupSE = std(currGroupData) / sqrt(length(currGroupData));

    % Plot mean and standard error
    errorbar(xPositions(i), groupMean, groupSE, 'k', 'LineWidth', 2, 'CapSize', 10);
end

% Create custom legend items for the different markers and colors
% JF colors (darker shade)
h1 = scatter(NaN, NaN, markerSize, 'k', maleMarker, 'filled');
h2 = scatter(NaN, NaN, markerSize, 'k', femaleMarker, 'filled');
% Regular colors
h3 = scatter(NaN, NaN, markerSize, [0.6, 0.6, 0.6], maleMarker, 'filled');
h4 = scatter(NaN, NaN, markerSize, [0.6, 0.6, 0.6], femaleMarker, 'filled');
h5 = scatter(NaN, NaN, markerSize, [0.6, 0.6, 0.6], unknownMarker, 'filled');

% Add the legend with the new items
legend([h1, h2, h3, h4, h5], {'Male-JF', 'Female-JF', 'Male', 'Female', 'Unknown'}, 'Location', 'northeast');

% Set axis properties
xlim([0.5, length(uniqueGroups) + 0.5]);
ylim([0, 120]);
xticks(xPositions);
xticklabels(uniqueGroups);
ylabel('Preference (%)');
title('Flavor Preference');


set(gca, 'FontSize', 12, 'LineWidth', 1.5, 'Box', 'on');
grid on;
hold off;
prettify_plot;