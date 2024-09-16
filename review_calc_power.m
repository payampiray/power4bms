function review_calc_power()

fname = fullfile('sum', sprintf('%s.mat', mfilename));
f = load(fname); review = f.review;

required_power = .8;
if ~any(strcmp(review.Properties.VariableNames, 'required_sample_size'))
    N_opt = nan(length(review.power), 1);
    fname = 'temp.mat';
    for i= 1:length(N_opt)    
        if review.power(i) < required_power
            [N_opt(i)] = calc_sample_size(review.model_size(i), required_power);
        end
        fprintf('study %02d- model size: %02d, power: %0.3f, actual N: %03d, required: %03d\n', i, review.model_size(i), review.power(i), review.sample_size(i), N_opt(i))
        save(fname, 'N_opt');
    end
    review.required_sample_size = N_opt;
    save(fname, 'review');    
end


power = review.power;
[sort_power, idx_sort] = sort(power, 'descend');

fixed = strcmp(review.method, 'fixed');
sample_size = review.sample_size;
required_sample_size = review.required_sample_size;
x = [sample_size required_sample_size fixed];
x = x(idx_sort, :);
idx = sort_power< required_power;
x = x(idx,:);
pubnumber = find(idx);

labels = {'Actual', 'Required'};
%--------------------------------------------------------------------------
close all;

fs = 12;
fsy = 14;

fsiz = [0 0 .4 1];
figure; set(gcf,'units','normalized'); set(gcf,'position',fsiz);


h(1) = subplot(4, 1, 1);
% fsiz = [0 0 .40 .25];
% figure; set(gcf,'units','normalized'); set(gcf,'position',fsiz);
bar(sort_power);
set(gca, 'fontsize', fs);
% xlim(.5+[0 40]);
xlabel('Publication number', 'FontSize', fsy);
ylabel('Estimated power', 'FontSize', fsy);

xl = get(gca, 'xlim');

xtick = 3:3:54;

hold on;
plot(xl, required_power*[1 1], 'linewidth', 2);

set(gca, 'box', 'off', 'xtick', xtick);

%--------------------------------------------------------------------------
h(2) = subplot(4, 1, [2 3 4]);
barh(x(:, 1:2));
set(gca, 'fontsize', fs);
% ylim(.5+[0 40]);
ylabel('Publication number', 'FontSize', fsy);
xlabel('Sample size', 'FontSize', fsy);
set(gca, 'box', 'off');

legend(labels, 'location', 'southeast', 'fontsize', fs, 'box', 'off');

ticklength = get(gca,'ticklength');
ticklength(2) = 0;
set(gca,'Ytick', 1:size(x,1), 'TickLength', ticklength)
set(gca,'Yticklabel', pubnumber)
set(gca, 'TickLength', [0 ,0], 'xgrid', 'on')

abc= 'abc';
ys = [1.17 1.02];

for i= 1:length(h)
%     set(h((i)),'fontsize',fs,'fontname',fn);
    text(-.1, ys(i) ,abc(i),'fontsize',fsy,'Unit','normalized','fontname','Arial','fontweight','b','parent',h(i));
end
end