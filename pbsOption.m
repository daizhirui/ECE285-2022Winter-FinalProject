function options = pbsOption(varargin)
% PBSOPTION Generate struct of polyhedral bundle scheme parameters.

% default
options.s = 25; % number of new constraints added in each iteration
options.u = 10; % init regularization weight
options.umin = 1e-5; % minimum u
options.umax = 1e10;  % maximum u
options.delta1 = 0.7; % factor to decrease u in serious step
options.delta2 = 1.5; % factor to increase u in null step
options.nu = 0.2; % improvement factor to judge serious/null step
options.epsilon1 = 1e-3; % termination threshold of relative dual gap
options.epsilon2 = 1e-5; % termination threshold of relative improvement
options.maxItr = 1000; % maximum number of iteration, -1 means endless
options.maxNull = 20; % maximum number of consecutive null steps
options.record = false; % save all the intermediate results to disk
options.logName = datestr(datetime('now'), 'mmm-dd-yyyy-hh-MM-SS');
options.logDir = fullfile([pwd, filesep, 'log', filesep, 'pbs']);
options.debug = 'off';

p = inputParser;
paramFields = {'s'; 'u'; 'umin'; 'umax'; 'delta1'; 'delta2'; 'nu'; ...
    'epsilon1'; 'epsilon2'; 'maxItr'; 'maxNull'; 'record'; 'logName'; ...
    'logDir'; 'debug'};
for i = 1 : size(paramFields)
    field = paramFields{i};
    addParameter(p, field, options.(field));
end

parse(p, varargin{:});
options = p.Results;

end