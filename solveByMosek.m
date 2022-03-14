function [Xsol, ysol, primalObj, dualObj] = solveByMosek(C, A, b, logName) 
% SOLVEBYMOSEK Solve the SDP problem with MOSEK solver.

logDir = fullfile([pwd filesep 'log' filesep 'mosek' filesep logName]);
if ~isfolder(logDir)
    mkdir(logDir);
end

diaryFile = fullfile([logDir filesep 'diary.txt']);
diary(diaryFile);

t0 = tic;
n = size(C, 1); % m = size(A, 1);
X = sdpvar(n, n, 'symmetric');
primal = sum(C .* X, 'all');
cons = [(b == linearOp(A, X)):'equality'; X >= 0]; %#ok<BDSCA> 
options = sdpsettings('verbose', 1, 'solver', 'mosek', ...
    'savesolveroutput', 1);
sol = optimize(cons, primal, options);
if sol.problem == 0
    Xsol = value(X);
    ysol = value(dual(cons('equality')));
    primalObj = full(sum(C .* Xsol, 'all'));
    dualObj = full(b' * ysol);
    time = toc(t0);
    fprintf('primal = %f\ndual = %f\ntime=%f\n', primalObj, dualObj, time);
else
    Xsol = []; ysol = []; primalObj = []; dualObj = [];
end
diary off;

dataFile = fullfile([logDir filesep 'data.mat']);
clear('X', 'primal', 'cons');
save(dataFile);

end