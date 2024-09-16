function [N_opt] = calc_sample_size(K, power_min, config)

if nargin<2
    power_min = .8;
end
if nargin<3
    config = [];
end
config = calc_config(config);

bf_crit = config.bf_min;
num_sim_min = config.num_sim_min;
c_base = config.base;
c = config.prior;
max_iter = config.num_iterations;
tol = config.tol;
% -------------------------------------------------------------------------

minmin_N = ceil(bf_crit*K);
min_N = minmin_N;
max_N = inf;

[r1_win] = calc_generate_true(K, bf_crit, num_sim_min, c_base, max_iter);

N_opt = nan;
l = 1;
step_level = 128;
while l<max_iter
    [powers, sizes] = calc_power4series(r1_win, power_min, min_N, max_N, step_level, bf_crit, c);    
    N_opt = sizes(end);
    if abs(powers(end) - power_min)<tol || (N_opt == minmin_N)
        break;
    end
    min_N = sizes(end-1);
    max_N = sizes(end);
    step_level = step_level/2;
    l = l+1;
end

if N_opt == minmin_N
    return;
end

if isnan(N_opt)
    [~, i] = min(abs(powers - power_min));
    N_opt = sizes(i);
end

min_N = N_opt - 7;
max_N = N_opt + 3;
step_level = 1;
[powers, sizes] = calc_power4series(r1_win, power_min, min_N, max_N, step_level, bf_crit, c);    

N_opt = sizes(end);
power_N_opt = powers(end); %#ok<NASGU> 
end

function [powers, sample_sizes] = calc_power4series(r1_win, power_min, N_min, N_max, step_level, bf_crit, c)
N = N_min;
power = 0;
powers = [];
sample_sizes = [];
while power<power_min && N<=N_max    
    power = calc_power_given_true(N, r1_win, bf_crit, c);
    powers = cat(2, powers, power);
    sample_sizes = cat(2, sample_sizes, N);
    N = N + step_level;
end

end
