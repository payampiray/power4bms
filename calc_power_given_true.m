function [power] = calc_power_given_true(N, r1_win, bf_crit, c)

K = size(r1_win, 2);

% calculate power given the true population-level scenarios

N_vec = N;
power = nan(size(N_vec));
for i=1:length(N_vec)
    N = N_vec(i);

    % adjust N given bf_crit to make sure that some N's do not have unfair
    % advantage due to N being an integer
    adjusted_N = floor((N+K*c)/(bf_crit+1))*(bf_crit+1) - K*c;    
        
    % generate group samples (multinomial distribution)
    g = mnrnd(adjusted_N, r1_win);
    
    % posterior dirichlet
    m = g + c; 
    
    emp_bf = (m(:,1)./m(:,2:end));
    m1_win = sum(emp_bf>=bf_crit, 2)==(K-1);
    
    % True positive
    TP = sum(m1_win == 1);
    
    % False Negative
    FN = sum(m1_win == 0);
    
    power(i) = TP/(TP+FN);
end

end