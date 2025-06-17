%% Flavor preference - WT mice - Side-by-side CTA and Habituation Analysis (3 Groups)
% Data
preference_1 = [93.9, 83.9, 29.2, 46.0, 63.0, 38.0, 60.0, 28.6, 98.6, 72.0, ...
    91.2, 80.4, 61.0, 3.2, 79.4, 23.8, 65.2, 8.9, 93.8, 11.1, ...
    0.0472972972972973 * 100, 0.152 * 100, 0.194630872483221 * 100,...
    0.241071428571429 * 100, 0.0594594594594595 * 100, ...
    0.159574468085106 * 100, 0.21875 * 100, 0.225225225225225 * 100,...
    0.589473684210526 * 100, 0.606451612903226 * 100, ...
    0.709876543209877 * 100, 0.73469387755102 * 100, 0.25 * 100,...
    0.608433734939759 * 100, 0.611570247933884 * 100, ...
    0.766304347826087 * 100];

preference_2 = [96.9, 97.2, 17.5, 92.1, 35.3, 75.9, 88.7, 73.7, NaN, 91.2,...
    94.5, 98.0, 82.1, 95.5, 93.0, 56.8, 95.7, 34.6, 56.3, 100.0];

preference_3 = [87.0,64.6,3.0,1.4,3.8,5.6,NaN,34.4,NaN,63.5,84.6,100.0,NaN,95.7,62.8,62.4,3.3,87.0,5.0,6.4];

group = {'Backward', 'Backward', 'Forward', 'Forward', 'Control',...
    'Backward', 'Backward', 'Forward', 'Control', 'Control', ...
    'Backward', 'Backward', 'Forward', 'Forward', 'Control', ...
    'Backward', 'Backward', 'Forward', 'Control', 'Control', ...
    'Forward-prev.', 'Forward-prev.', 'Forward-prev.', 'Forward-prev.',...
    'Forward-prev.', 'Forward-prev.', 'Forward-prev.', 'Forward-prev.',...
    'Control-prev.', 'Control-prev.', 'Control-prev.', 'Control-prev.',...
    'Control-prev.', 'Control-prev.', 'Control-prev.', 'Control-prev.'};

group_2 = {'Habituation', 'Habituation', 'Habituation', 'Habituation', 'Habituation',...
    'Habituation', 'Habituation', 'Habituation', 'Control', 'Habituation', ...
    'Habituation', 'Habituation', 'Habituation', 'Habituation', 'Habituation', ...
    'Habituation', 'Habituation', 'Habituation', 'Habituation', 'Habituation'};

group_3 = {'Forward', 'Forward',  'Control', 'Backward', 'Control',...
    'Forward', 'Forward', 'Backward', 'Control','Control', ...
    'Forward', 'Forward',  'Backward', 'Backward', 'Control', ...
    'Forward', 'Control', 'Backward', 'Control', 'Control'};

sex = {'M', 'M', 'M', 'M', 'M', 'F', 'F', 'F', 'F', 'F', ...
    'F-JF', 'F-JF', 'F-JF', 'F-JF', 'F-JF', 'M-JF', 'M-JF', 'M-JF', 'M-JF', 'M-JF',...
    'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U'};

% Create side-by-side plot
figure('Position', [100, 100, 1600, 600]);
hold on;

% Define CTA groups that have corresponding habituation data (first 20 mice)
ctaGroups = {'Backward', 'Forward', 'Control'};
groupColors = [0.9, 0.3, 0.3; ...    % Backward - red
               0.2, 0.6, 0.2; ...    % Forward - green  
               0.2, 0.6, 0.8];       % Control - blue

% Define x-positions: CTA test, Habituation test, Third test for each group
% Group 1: Backward (x=1) -> Hab (x=2.5) -> Third (x=4)
% Group 2: Forward (x=6) -> Hab (x=7.5) -> Third (x=9)  
% Group 3: Control (x=11) -> Hab (x=12.5) -> Third (x=14)
ctaPositions = [1, 6, 11];
habPositions = [2.5, 7.5, 12.5];
thirdPositions = [4, 9, 14];

% Also include the "prev" groups in their original positions
prevGroups = {'Forward-prev.', 'Control-prev.'};
prevColors = [0.3, 0.7, 0.3; ...     % Forward-prev - lighter green
              0.1, 0.5, 0.7];        % Control-prev - darker blue
prevPositions = [16, 18];

% Define markers for sex
maleMarker = 'o';
femaleMarker = 's';
unknownMarker = 'diamond';
markerSize = 60;
colorAdjustFactor = 0.6;

% Plot CTA results for main groups (Backward, Forward, Control)
for groupIdx = 1:length(ctaGroups)
    currentGroup = ctaGroups{groupIdx};
    
    % Find all mice in this CTA group
    ctaIndices = strcmp(group, currentGroup);
    ctaData = preference_1(ctaIndices);
    ctaSex = sex(ctaIndices);
    
    % Plot CTA results
    for i = 1:length(ctaData)
        baseColor = groupColors(groupIdx, :);
        
        if strcmp(ctaSex{i}, 'M-JF')
            adjustedColor = baseColor * colorAdjustFactor;
            markerType = maleMarker;
        elseif strcmp(ctaSex{i}, 'F-JF')
            adjustedColor = baseColor * colorAdjustFactor;
            markerType = femaleMarker;
        elseif strcmp(ctaSex{i}, 'M')
            adjustedColor = baseColor;
            markerType = maleMarker;
        elseif strcmp(ctaSex{i}, 'F')
            adjustedColor = baseColor;
            markerType = femaleMarker;
        else
            adjustedColor = baseColor;
            markerType = unknownMarker;
        end
        
        scatter(ctaPositions(groupIdx), ctaData(i), markerSize, adjustedColor, markerType, 'filled');
    end
    
    % Plot CTA mean and SE
    ctaMean = mean(ctaData);
    ctaSE = std(ctaData) / sqrt(length(ctaData));
    errorbar(ctaPositions(groupIdx), ctaMean, ctaSE, 'k', 'LineWidth', 3, 'CapSize', 12);
    scatter(ctaPositions(groupIdx), ctaMean, 120, 'k', 'o', 'filled', 'LineWidth', 2);
    
    % Now plot habituation results for mice from this CTA group
    habData = [];
    habSex = {};
    mouseIndices = [];
    
    % Find mice from this CTA group that have habituation data (first 20 mice)
    for i = 1:20
        if strcmp(group{i}, currentGroup) && ~isnan(preference_2(i))
            habData(end+1) = preference_2(i);
            habSex{end+1} = sex{i};
            mouseIndices(end+1) = i;
        end
    end
    
    % Plot habituation results in grey
    for i = 1:length(habData)
        % Use grey colors for habituation
        if strcmp(habSex{i}, 'M-JF')
            adjustedColor = [0.3, 0.3, 0.3]; % Dark grey for JF
            markerType = maleMarker;
        elseif strcmp(habSex{i}, 'F-JF')
            adjustedColor = [0.3, 0.3, 0.3]; % Dark grey for JF
            markerType = femaleMarker;
        elseif strcmp(habSex{i}, 'M')
            adjustedColor = [0.6, 0.6, 0.6]; % Light grey for regular
            markerType = maleMarker;
        elseif strcmp(habSex{i}, 'F')
            adjustedColor = [0.6, 0.6, 0.6]; % Light grey for regular
            markerType = femaleMarker;
        else
            adjustedColor = [0.6, 0.6, 0.6]; % Light grey for unknown
            markerType = unknownMarker;
        end
        
        scatter(habPositions(groupIdx), habData(i), markerSize, adjustedColor, markerType, 'filled');
        
        % Draw connecting line from CTA to habituation for this mouse
        mouseIdx = mouseIndices(i);
        % Use the original CTA group color for the connecting line
        baseColor = groupColors(groupIdx, :);
        if strcmp(habSex{i}, 'M-JF') || strcmp(habSex{i}, 'F-JF')
            lineColor = baseColor * colorAdjustFactor;
        else
            lineColor = baseColor;
        end
        plot([ctaPositions(groupIdx), habPositions(groupIdx)], ...
             [preference_1(mouseIdx), preference_2(mouseIdx)], '-', ...
             'Color', lineColor, 'LineWidth', 2);
    end
    
    % Plot habituation mean and SE
    if ~isempty(habData)
        habMean = mean(habData);
        habSE = std(habData) / sqrt(length(habData));
        errorbar(habPositions(groupIdx), habMean, habSE, 'k', 'LineWidth', 3, 'CapSize', 12);
        scatter(habPositions(groupIdx), habMean, 120, 'k', 'o', 'filled', 'LineWidth', 2);
    end
    
    % Now plot third experiment results for mice from this CTA group
    thirdData = [];
    thirdSex = {};
    thirdMouseIndices = [];
    
    % Find mice from this CTA group that have third experiment data (first 20 mice)
    % Note: we look for mice that were in this CTA group, regardless of their group_3 assignment
    for i = 1:20
        if strcmp(group{i}, currentGroup) && ~isnan(preference_3(i))
            thirdData(end+1) = preference_3(i);
            thirdSex{end+1} = sex{i};
            thirdMouseIndices(end+1) = i;
        end
    end
    
    % Plot third experiment results in purple/magenta tones and connect to habituation
    for i = 1:length(thirdData)
        mouseIdx = thirdMouseIndices(i);
        
        % Use purple/magenta colors for third experiment
        if strcmp(thirdSex{i}, 'M-JF')
            adjustedColor = [0.5, 0.2, 0.5]; % Dark purple for JF
            markerType = maleMarker;
            lineColor = [0.5, 0.2, 0.5];
        elseif strcmp(thirdSex{i}, 'F-JF')
            adjustedColor = [0.5, 0.2, 0.5]; % Dark purple for JF
            markerType = femaleMarker;
            lineColor = [0.5, 0.2, 0.5];
        elseif strcmp(thirdSex{i}, 'M')
            adjustedColor = [0.7, 0.4, 0.7]; % Light purple for regular
            markerType = maleMarker;
            lineColor = [0.7, 0.4, 0.7];
        elseif strcmp(thirdSex{i}, 'F')
            adjustedColor = [0.7, 0.4, 0.7]; % Light purple for regular
            markerType = femaleMarker;
            lineColor = [0.7, 0.4, 0.7];
        else
            adjustedColor = [0.7, 0.4, 0.7]; % Light purple for unknown
            markerType = unknownMarker;
            lineColor = [0.7, 0.4, 0.7];
        end
        
        scatter(thirdPositions(groupIdx), thirdData(i), markerSize, adjustedColor, markerType, 'filled');
        
        % Find if this mouse also has habituation data 
        % (check if this mouse index is in the habituation mouseIndices list)
        habIdx = find(mouseIndices == mouseIdx);
        if ~isempty(habIdx)
            % This mouse has both habituation and third experiment data
            % Connect the corresponding habituation point to this third experiment point
            habValue = habData(habIdx);
            plot([habPositions(groupIdx), thirdPositions(groupIdx)], ...
                 [habValue, thirdData(i)], '-', ...
                 'Color', lineColor, 'LineWidth', 2);
        end
    end
    
    % Plot third experiment mean and SE
    if ~isempty(thirdData)
        thirdMean = mean(thirdData);
        thirdSE = std(thirdData) / sqrt(length(thirdData));
        errorbar(thirdPositions(groupIdx), thirdMean, thirdSE, 'k', 'LineWidth', 3, 'CapSize', 12);
        scatter(thirdPositions(groupIdx), thirdMean, 120, 'k', 'o', 'filled', 'LineWidth', 2);
    end
end

% Plot "prev" groups separately
for prevIdx = 1:length(prevGroups)
    currentGroup = prevGroups{prevIdx};
    
    % Find all mice in this group
    prevIndices = strcmp(group, currentGroup);
    prevData = preference_1(prevIndices);
    prevSex = sex(prevIndices);
    
    % Plot results
    for i = 1:length(prevData)
        baseColor = prevColors(prevIdx, :);
        
        if strcmp(prevSex{i}, 'U')
            markerType = unknownMarker;
        else
            markerType = maleMarker; % Default for prev groups
        end
        
        scatter(prevPositions(prevIdx), prevData(i), markerSize, baseColor, markerType, 'filled');
    end
    
    % Plot mean and SE
    prevMean = mean(prevData);
    prevSE = std(prevData) / sqrt(length(prevData));
    errorbar(prevPositions(prevIdx), prevMean, prevSE, 'k', 'LineWidth', 3, 'CapSize', 12);
    scatter(prevPositions(prevIdx), prevMean, 120, 'k', 'o', 'filled', 'LineWidth', 2);
end

% Customize plot
xlim([0, 19]);
ylim([0, 120]);

% Set custom x-tick labels
allPositions = [ctaPositions, habPositions, thirdPositions, prevPositions];
allLabels = {'Backward', 'Forward', 'Control', ...
             'Backward', 'Forward', 'Control', ...
             'Backward', 'Forward', 'Control', ...
             'Forward-prev', 'Control-prev'};
[allPositions_sorted, allPositionsIdx] = sort(allPositions);
xticks(allPositions_sorted);
xticklabels(allLabels(allPositionsIdx));
ylabel('Preference (%)');

% Add vertical separators between group triads
line([5, 5], [0, 120], 'Color', [0.8, 0.8, 0.8], 'LineStyle', '--', 'LineWidth', 1);
line([10, 10], [0, 120], 'Color', [0.8, 0.8, 0.8], 'LineStyle', '--', 'LineWidth', 1);
line([15, 15], [0, 120], 'Color', [0.8, 0.8, 0.8], 'LineStyle', '--', 'LineWidth', 1);

% Create legend
h1 = scatter(NaN, NaN, markerSize, 'k', maleMarker, 'filled');
h2 = scatter(NaN, NaN, markerSize, 'k', femaleMarker, 'filled');
h3 = scatter(NaN, NaN, markerSize, [0.6, 0.6, 0.6], maleMarker, 'filled');
h4 = scatter(NaN, NaN, markerSize, [0.6, 0.6, 0.6], femaleMarker, 'filled');
h5 = scatter(NaN, NaN, markerSize, [0.7, 0.4, 0.7], maleMarker, 'filled');
h6 = scatter(NaN, NaN, markerSize, [0.6, 0.6, 0.6], unknownMarker, 'filled');
h7 = plot(NaN, NaN, '-', 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2);
h8 = plot(NaN, NaN, '-', 'Color', [0.7, 0.4, 0.7], 'LineWidth', 2);

legend([h1, h2, h3, h4, h5, h6, h7, h8], {'Male-JF', 'Female-JF', 'Habituation', 'Habituation', 'Third Exp', 'Unknown', 'CTA→Hab', 'Hab→Third'}, ...
    'Location', 'northeast', 'FontSize', 9);

% Add group labels at the top
text(2.5, 115, 'Backward', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'Color', groupColors(1,:));
text(7.5, 115, 'Forward', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'Color', groupColors(2,:));
text(12.5, 115, 'Control', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'Color', groupColors(3,:));

% Add experiment type labels
text(2.5, 110, 'Backwd CTA → Hab → Frwd CTA', 'FontSize', 10, 'HorizontalAlignment', 'center', 'Color', [0.4, 0.4, 0.4]);
text(7.5, 110, 'Frwd CTA → Hab → Backwd CTA', 'FontSize', 10, 'HorizontalAlignment', 'center', 'Color', [0.4, 0.4, 0.4]);
text(12.5, 110, 'Control → Hab → Control', 'FontSize', 10, 'HorizontalAlignment', 'center', 'Color', [0.4, 0.4, 0.4]);

set(gca, 'FontSize', 11, 'LineWidth', 1.5, 'Box', 'on');
box off;
grid off;
hold off;
prettify_plot;