function [power] = calc_power(N, K, config)

if nargin<3
    config = [];
end
config = calc_config(config);

bf_crit = config.bf_min;
num_sim_min = config.num_sim_min;
base = config.base;
c = config.prior;
max_iter = config.num_iterations;

% -------------------------------------------------------------------------
% generate true population-level scenarios
[r1_win] = calc_generate_true(K, bf_crit, num_sim_min, base, max_iter);

% -------------------------------------------------------------------------
% calculate power given the true population-level scenarios
[power] = calc_power_given_true(N, r1_win, bf_crit, c);

end
