function [r1_win] = calc_generate_true(K, bf_crit, num_sim_min, c, max_iter)

num_sim = 2*num_sim_min;

% generate true population-level scenarios
L = 0;
r1_win = [];
num_iter = 0;
while (L<num_sim_min)&&(num_iter < max_iter)
    alf = ones(1,K)*c;
    r = rand_dirichlet(num_sim, alf);
    tru_bf = (r(:,1)./r(:,2:end));
    r1_win_iter = sum(tru_bf>bf_crit, 2)==(K-1);
    r1_win_iter = r(r1_win_iter, :);
    r1_win = cat(1, r1_win, r1_win_iter);

    L = length(r1_win);
    num_iter = num_iter+1;
end

end

function r = rand_dirichlet(num_sim, alf)
K = length(alf);

% Dirichlet distribution
r = nan(num_sim, K);
for k=1:K
    r(:, k) = gamrnd(alf(:, k),1,num_sim,1);
end

sr = sum(r,2);
for k = 1:K
    r(:,k) = r(:,k)./sr;
end

end