function win = ffx_equal()
N = 50;
K = 3;
T = 200;
p_min = 0;
p_max = 1;
n_outlier = 1;
p_outlier = .9;
num_sim = 10^5;
log_bf_crit = 3;
seed = 0;

% -------------------------------------------------------------------------

conditions = {'outlier', 'without'};
for cond = 1:2
    condition = conditions{cond};
    fname = fullfile('sum', sprintf('%s_%s_logBF%d.mat', mfilename, condition, log_bf_crit));
    clear_win = struct('fixed', [], 'random', []);
    if ~exist(fname, 'file')
        num_batch = 10;
        num_sim = num_sim/num_batch;
    %     clear_win_batch = nan(num_batch, K);
        rng(seed);
        for batch = 1:num_batch
            f = zeros(num_sim, K);
            r = zeros(N, num_sim, K);
            if strcmp(condition, 'without')
                r = zeros(N-n_outlier, num_sim, K);
            end
            for k=1:K            
                p = p_min + (p_max - p_min)*rand((N-n_outlier), T, num_sim);
                if k>1
                    po = p_min + (p_max - p_min)*rand(n_outlier,T,num_sim);
                else
                    po = p_outlier + (1-p_outlier)*rand(n_outlier,T, num_sim);
                end
                if strcmp(condition, 'outlier')
                    p = cat(1, p, po);
                elseif strcmp(condition, 'without')
                else
                    error('condition %s is not known', condition);
                end
    
                logp = squeeze(sum(log(p+eps), 2));
                f(:, k) = sum(logp, 1);
    
                logp = squeeze(sum(log(p+eps), 2));            
                
                r(:, :, k) = exp(logp);
            end
            f = f - max(f, [], 2);
    
            r = r./sum(r, 3);
            r = log(squeeze(sum(r, 1)));
    
            evidence = {f, r};
            methods = {'fixed', 'random'};
            for j = 1:2
                method = methods{j};            
                for k=1:K
                    kk = 1:K; kk(k) = [];
                    f_evidence = evidence{j}(:, k) - evidence{j}(:, kk);
                    f_evidence = min(f_evidence, [], 2);
                    clear_win_batch.(method)(batch, k) = mean(f_evidence > log_bf_crit);
                end
                
            end
        end
        clear_win.fixed = mean(clear_win_batch.fixed, 1);
        clear_win.random = mean(clear_win_batch.random, 1);
        
        config = table2struct(table(N, K, T, n_outlier, p_outlier, num_sim, log_bf_crit, seed));    
        save(fname, 'config', 'clear_win_batch', 'clear_win');    
    end
    
    f = load(fname);
    win.(condition) = f.clear_win;
end
    




end



