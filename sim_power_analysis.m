function sim_power_analysis

NN = 20:5:500;
model_space = 2:10;

clc;
fname = fullfile('sum', sprintf('%s.mat', mfilename));
if ~exist(fname, 'file')
    for k=1:length(model_space)
        K = model_space(k);   
        [power] = calc_power(NN, K);   
        powers(:, k) = power;
        labels{k} = sprintf('K%d', K);
    end

    T = array2table([NN' powers], 'VariableNames', ['sample size', labels]);
    save(fname, 'T', 'model_space');
end
f = load(fname);
T = f.T;
model_space = f.model_space;

KK = [4 6 8];

NN = table2array(T(:,1));
for k=1:length(KK)
    col_idx(k) = find(model_space == KK(k));
    col_idx(k) = find(model_space == KK(k));
    
end
% labels = T.Properties.VariableNames(col_idx+1);
labels = cellstr(num2str(KK'));

powers = table2array(T(:, col_idx+1));

idx = NN<=500;
powers = powers(idx, :);
NN = NN(idx);

powers = round(powers*1000)/1000;

NN = NN(1:6:end);
powers = powers(1:6:end, :);

%--------------------------------------------------------------------------
close all;

x = NN;
y = powers;


fs = 14;
fsy = 16;
col = [0    0.4470    0.7410; 0.8500    0.3250    0.0980];

fsiz = [0 0 .75 .5];
h = figure; set(gcf,'units','normalized'); set(gcf,'position',fsiz);

bar(x, y);
set(gca, 'ylim', [0 1], 'FontSize', fs, 'xtick', x);
% % plot(x, y, 'linewidth', 2);

hg = legend(labels, 'FontSize', fsy, 'Location','northwest', 'orientation', 'horizontal', 'box', 'off', 'AutoUpdate', 'off');
title(hg, 'Model space size', 'FontWeight','normal');

ylabel('Power', 'fontsize', fsy);
xlabel('Sample size', 'fontsize', fsy);

xl = get(gca, 'xlim');

% hold on;
% plot(xl, .8*[1 1], 'linewidth', 2, 'Color', 'k');

set(gca, 'box', 'off', 'ygrid', 'on', 'ticklength', [0 0 ]);

end