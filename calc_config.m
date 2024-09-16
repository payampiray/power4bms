function config = calc_config(config)

if nargin<2, config = []; end
if isempty(config), config = struct('verbose',1); end

p = inputParser;
p.addParameter('verbose',1);
p.addParameter('base',1, @(arg)rem(arg, 1)==0 );
p.addParameter('prior',1, @(arg)rem(arg, 1)==0 );
p.addParameter('bf_min', 3, @(arg)rem(arg, 1)==0 );
p.addParameter('num_sim_min', 5e5);
p.addParameter('num_iterations', 10);
p.addParameter('tol', 0.005);

p.parse(config);
config    = p.Results;

end
