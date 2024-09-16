function figsupp_sim


fname = fullfile('sum', sprintf('%s.mat', 'sim_power_analysis'));
f = load(fname);
T = f.T;
model_space = f.model_space;

KK = model_space;

NN = table2array(T(:,1));
for k=1:length(KK)
    col_idx(k) = find(model_space == KK(k));
    col_idx(k) = find(model_space == KK(k));
    
end
% labels = T.Properties.VariableNames(col_idx+1);
labels = cellstr(num2str(KK'));

powers = table2array(T(:, col_idx+1));

NN = NN(1:2:end);
powers = powers(1:2:end, :);

powers = round(powers*100)/100;


%--------------------------------------------------------------------------
close all;

x = NN;
y = powers;

xtick = x(1:4:end);


fs = 14;
fsy = 16;
col = [0    0.4470    0.7410; 0.8500    0.3250    0.0980];

fsiz = [0 0 .75 .6];
h = figure; set(gcf,'units','normalized'); set(gcf,'position',fsiz);

plot(x, y, '-o','linewidth', 2);
set(gca, 'ylim', [0.25 1], 'FontSize', fs, 'xtick', xtick, 'box', 'off');

hg = legend(labels, 'FontSize', fsy, 'Location','southeast',  'box', 'off', 'AutoUpdate', 'off');
title(hg, 'Model space size', 'FontWeight','normal');

ylabel('Power', 'fontsize', fsy);
xlabel('Sample size', 'fontsize', fsy);

xl = get(gca, 'xlim');

% hold on;
% plot(xl, .8*[1 1], 'linewidth', 2, 'Color', 'k');

set(gca, 'box', 'off', 'ygrid', 'on', 'ticklength', [0 0 ]);

end