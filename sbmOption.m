function options = sbmOption(varargin)
% SBMOPTION Generate struct of spectral bundle method parameters.

% default
options.R = 30; % bundle size
options.s = 25; % number of columns in the bundle to update each iteration
options.umin = 1e-5; % minimum u
options.umax = 1e10; % maximum u
options.delta1 = 0.7; % factor to decrease u in serious step
options.delta2 = 1.5; % factor to increase u in null step
options.nu = 0.4; % improvement factor to judge serious/null step
options.epsilon1 = 1e-3; % termination threshold of relative dual gap
options.epsilon2 = 1e-5; % termination threshold of relative improvement
options.maxItr = 1000; % maximum number of iteration, -1 means endless
options.maxNull = 20; % maximum number of concecutive null steps
options.record = false; % save all the intermediate results to disk
options.logName = datestr(datetime('now'), 'mmm-dd-yyyy-hh-MM-SS');
options.logDir = fullfile([pwd, filesep, 'log', filesep, 'sbm']);
options.debug = 'off';

p = inputParser;
paramFields = {'R'; 's'; 'umin'; 'umax'; 'delta1'; 'delta2'; 'nu'; ...
    'epsilon1'; 'epsilon2'; 'maxItr'; 'maxNull'; 'record'; 'logName'; ...
    'logDir'; 'debug'};
for i = 1 : size(paramFields)
    field = paramFields{i};
    addParameter(p, field, options.(field));
end

parse(p, varargin{:});
options = p.Results;

end