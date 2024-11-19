clear all 
close all
n_samples = 19;

path2loadRand = fullfile('..','..','..','PCA_data','Randomization',['PCA_' num2str(n_samples) '_samples_Rand_18-Nov-2024.mat']);
path2loadHom = fullfile('..','..','..','PCA_data','Homogeneous_size',['PCA_' num2str(n_samples) '_samples_Hom_18-Nov-2024.mat']);
load(path2loadRand)
load(path2loadHom)


Days =[60,100,120];
% %filter the top 3 more important feature for the separation
% featuresSelected_hom=cellfun(@(x) x(1:3),featuresSelected_hom,'UniformOutput',false);
for nDays=1:length(Days)

    % Sample data
    dist1 = BestPCA_value_rand(nDays,:); % Distribution 1
    dist2 = BestPCA_value_hom(nDays,:) + 1; % Distribution 2 (shifted)
    
    % Define bin edges
    binEdges = 0:0.2:10; 
    
    % Create histograms
    h = figure;
    hold on;
    h1 = histogram(dist1, binEdges, 'Normalization', 'probability', 'FaceColor', [0, 0.447, 0.741], 'EdgeColor', 'none', 'FaceAlpha', 0.7); % Blue
    h2 = histogram(dist2, binEdges, 'Normalization', 'probability', 'FaceColor', [0.85, 0.325, 0.098], 'EdgeColor', 'none', 'FaceAlpha', 0.7); % Orange
    
    % Add labels and legend
    xlabel('PCA descriptor');
    ylabel('Probability');
    xticks([0:10])
    
    legend({'Shuffle class', 'Correct class'}, 'Location', 'best');
    title([num2str(Days(nDays)) ' days - PCA descriptor distribution - ' num2str(n_samples) ' samples']);
    set(gca, 'FontSize', 12); % Improve font size for publication
    box on; grid on;
    

    outputFile=fullfile('..','..','..','PCA_data','Homogeneous_size',[num2str(n_samples) ' samples'],  ['PCA_distribution_' num2str(n_samples) '_samples_' num2str(Days(nDays)) 'days']);
    print(outputFile, '-dpng', '-r300'); % Save as PNG with 300 DPI resolution
    savefig(h,[outputFile '.fig'])
    pause(10)

    
    % Sample data
    features = [featuresSelected_hom{nDays,:}]; % feature list
    [uniqueFeatures, ~, idx] = unique(features); % Get unique features
    freq = accumarray(idx, 1); % Count frequency
    
    % Sort by frequency
    [freqSorted, sortIdx] = sort(freq, 'descend');
    featuresSorted = uniqueFeatures(sortIdx);
    
    % Highlight top 7
    highlightIdx = 1:7;
    
    % Plot top 20 features
    h = figure;
    bar(1:40, freqSorted(1:40), 'FaceColor', [0.7, 0.7, 0.7]); % Base color (gray)
    hold on;
    bar(highlightIdx, freqSorted(highlightIdx), 'FaceColor', [0, 0.447, 0.741], 'FaceAlpha', 0.7) % Highlight top 7 (blue)
    
    % Annotate every bar
    for i = 1:40
        text(i, freqSorted(i) + max(freqSorted) * 0.02, ...
             num2str(featuresSorted(i)), ...
             'HorizontalAlignment', 'center', ...
             'VerticalAlignment', 'bottom', ...
             'FontSize', 8, ...
             'Color', 'k');
    end
    
    % Adjust Y-axis limit
    ylim([0, max(freqSorted) * 1.2]);
    
    % Add labels and legend
    xlabel('Features');
    xticks([])
    title([num2str(Days(nDays)) ' days - Feature selection frequency - ' num2str(n_samples) ' samples']);
    set(gca, 'FontSize', 12); % Improve font size for publication
    xlim([0, 41]); % Set x-axis limit
    legend({'Other Features', 'Top 7 Features'}, 'Location', 'northeast');
    box on; grid on;

  
    outputFile=fullfile('..','..','..','PCA_data','Homogeneous_size',[num2str(n_samples) ' samples'],  ['top3_featuresSelection_distribution_' num2str(n_samples) '_samples_' num2str(Days(nDays)) 'days']);
    print(outputFile, '-dpng', '-r300'); % Save as PNG with 300 DPI resolution
    savefig(h,[outputFile '.fig'])

end

close all