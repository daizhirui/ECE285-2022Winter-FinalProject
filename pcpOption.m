function options = pcpOption(varargin)
% PCPOPTION Generate struct of polyhedral cutting plane algorithm
% parameters.

% default
options.s = 5; % number of new constraints added in each iteration
options.epsilon1 = 1e-6; % termination threshold of abs(LB-UB)
options.epsilon2 = 0.01; % termination threshold of abs(lam_min)
options.maxItr = 1000; % maximum number of iteration, -1 means endless
options.record = false; % save all the intermediate results to disk
options.logName = datestr(datetime('now'), 'mmm-dd-yyyy-hh-MM-SS');
options.logDir = fullfile([pwd, filesep, 'log', filesep, 'pcp']);
options.debug = 'off';

p = inputParser;
paramFields = {'s'; 'epsilon1'; 'epsilon2'; 'maxItr'; 'record'; 'logName'; ...
    'logDir'; 'debug'};
for i = 1 : size(paramFields)
    field = paramFields{i};
    addParameter(p, field, options.(field));
end

parse(p, varargin{:});
options = p.Results;

end