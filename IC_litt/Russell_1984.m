% MATLAB script to visualize plasma histamine levels during test trials

% Data from the study - ordered as specified (Baseline, CS-, First CS+, Second CS+)
conditions = {'Baseline', 'CS-', 'First CS+', 'Second CS+'};
means = [18.3, 49, 147.5, 54.2];
sems = [4.9, 7.7, 28.7, 17.0];

% Create figure
figure('Position', [100, 100, 800, 600]);

% Create bar plot with custom colors
colors = [0.7 0.7 0.7; ... % Grey for Baseline
          0.0 0.7 0.0; ... % Green for CS-
          1.0 0.5 0.0; ... % Orange for First CS+
          1.0 0.7 0.0];    % Orange for Second CS+
b = bar(1:length(means), means);

% Apply colors to each bar
for i = 1:length(means)
    b.FaceColor = 'flat';
    b.CData(i,:) = colors(i,:);
end

% Hold on to add error bars
hold on;

% Add error bars
errorbar(1:length(means), means, sems, 'k', 'LineStyle', 'none', 'LineWidth', 1.5);

% Customize the plot
set(gca, 'XTick', 1:length(conditions), 'XTickLabel', conditions, 'FontSize', 12);
ylabel('Plasma Histamine (ng/ml)', 'FontSize', 14);
title('Plasma Histamine Levels During Test Trials', 'FontSize', 16);
ylim([0, max(means + sems*1.5)]); % Add some space above highest bar

% Add significance markers
% CS- vs First CS+ (positions 2 and 3)
line([2 3], [200 200], 'Color', 'k', 'LineWidth', 1.5);
text(2.5, 210, '***', 'FontSize', 14, 'HorizontalAlignment', 'center');

% CS- vs Second CS+ (positions 2 and 4)
line([2 4], [190 190], 'Color', 'k', 'LineWidth', 1.5);
text(3, 195, '*', 'FontSize', 14, 'HorizontalAlignment', 'center');

% Add legend for significance
%text(1, max(means + sems*1.5)*1.1, '* p < 0.055', 'FontSize', 10);
%text(1, max(means + sems*1.5)*1.2, '*** p < 0.001', 'FontSize', 10);

% Add note about sample size
text(1, max(means + sems*1.5)*0.75, 'n = 8 animals per condition', 'FontSize', 10);

% % Add color legend
% colorLegend = {'Baseline (Grey)', 'CS+ (Orange)', 'CS- (Green)'};
% legendPatches = [patch('FaceColor', [0.7 0.7 0.7]), patch('FaceColor', [1.0 0.5 0.0]), patch('FaceColor', [0.0 0.7 0.0])];
% set(legendPatches, 'EdgeColor', 'none');
% legend(legendPatches, colorLegend, 'Location', 'NorthWest', 'FontSize', 10);

% Add grid for better readability
grid on;
box on;

% Adjust the appearance
set(gcf, 'Color', 'white');
set(gca, 'FontName', 'Arial');

hold off;

% Save the figure if needed
% saveas(gcf, 'plasma_histamine_levels.png');
% saveas(gcf, 'plasma_histamine_levels.fig');

ylim([0 230])
grid off;
box off;
prettify_plot;


%%
% MATLAB script to recreate the TNF-α serum concentrations plot with correct groups and colors

% Define conditions and x-axis positions
conditions = {'Baseline', 'Tolerance', 'Post Tolerance', 'Post Re-exposition'};
x = 1:4;

% Data for each group across conditions
COND = [3300, 50, 1650, 400];  % Average of COND1 and COND2
SHAM = [3300, 50, 1900, 2000]; % Control group (green)
LPS = [3300, 50, 1900, 100];  % Positive control (red)

% Error bars (standard deviations)
COND_err = [500, 20, 250, 300]; % Combined error for COND1/COND2
SHAM_err = [400, 20, 200, 250];
LPS_err = [400, 20, 200, 250];

% Create figure
figure('Position', [100, 100, 800, 600]);

% Plot each group with different markers and colors
hold on;
p1 = plot(x, COND, '-o', 'Color', [1.0 0.5 0.0], 'LineWidth', 2, 'MarkerFaceColor', [1.0 0.5 0.0], 'MarkerSize', 8); % Orange for COND
p2 = plot(x, SHAM, '-s', 'Color', [0.0 0.7 0.0], 'LineWidth', 2, 'MarkerFaceColor', [0.0 0.7 0.0], 'MarkerSize', 8); % Green for SHAM
p3 = plot(x, LPS, '-^', 'Color', [0.8 0.0 0.0], 'LineWidth', 2, 'MarkerFaceColor', [0.8 0.0 0.0], 'MarkerSize', 8);  % Red for LPS

% Add error bars
errorbar(x, COND, COND_err, 'Color', [1.0 0.5 0.0], 'LineStyle', 'none', 'CapSize', 10);
errorbar(x, SHAM, SHAM_err, 'Color', [0.0 0.7 0.0], 'LineStyle', 'none', 'CapSize', 10);
errorbar(x, LPS, LPS_err, 'Color', [0.8 0.0 0.0], 'LineStyle', 'none', 'CapSize', 10);

% Customize the plot
set(gca, 'XTick', x);
set(gca, 'XTickLabel', conditions);
xlabel('Condition', 'FontSize', 12);
ylabel('Serum TNF-\alpha (ng/ml)', 'FontSize', 12);
title('TNF-\alpha Serum Concentrations', 'FontSize', 14);

% Adjust the x-axis labels to have line breaks for better readability
set(gca, 'XTickLabel', {'Baseline', 'Tolerance', 'Post-Tolerance', 'Post Re-nexposition'});

% Set y-axis limits
ylim([0 5000]);
yticks(0:1000:5000);

% Add legend with correct group labels
legend([p1, p2, p3], {'COND (Conditioned)', 'SHAM (Control)', 'LPS (Positive Control)'}, 'Location', 'northeast', 'Box', 'off', 'FontSize', 10);

% Add statistical significance markers
% Baseline vs Tolerance
%line([1 2], [4500 4500], 'Color', 'k', 'LineWidth', 1);
%text(1.5, 4600, '***', 'FontSize', 12, 'HorizontalAlignment', 'center');

% Tolerance vs Post Tolerance
%line([2 3], [4200 4200], 'Color', 'k', 'LineWidth', 1);
%text(2.5, 4300, '***', 'FontSize', 12, 'HorizontalAlignment', 'center');

% COND vs SHAM/LPS at Post Re-exposition
line([4 4], [400 2000], 'Color', 'k', 'LineWidth', 1);
text(4.1, 1200, '***', 'FontSize', 12, 'HorizontalAlignment', 'center');

% Add caption text at the bottom
% Adjust appearance
grid off;
box on;
set(gcf, 'Color', 'white');
set(gca, 'FontName', 'Arial');

hold off;
grid off;
box off;
prettify_plot;
% Optional: save the figure
% saveas(gcf, 'TNF_alpha_serum_concentrations.png');
% saveas(gcf, 'TNF_alpha_serum_concentrations.fig');