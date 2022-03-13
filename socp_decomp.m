function [opt, consumption, Cons] = scop_decomp(C, A, b, epsilon, trail_ev, max_cuts, rem)
%scop_decomp implements socp decomposition method for solving the following SDP
%problem:
%       min_X <C,X>
%  subject to <Ai,X>=bi  i = 1 ... m
%             X >= 0
%according to "On Polyhedral and Second-Order Cone Decompositions of SDP" by
%Dimitris Bertsimas and Ryan Cory-Wright
%Arguments:
%  C: n x n symmetric matrix
%  A: m x n x n, linear operator consisting of m nxn symmetric matrices
%     trace(A(i, :, :).' * X) = b(i) is <Ai,X>=bi for i=1...m
%  b: right-hand-side vector of the equality constrraint
%  epsilon: termination criteria
%  trail_ev: using trail eigenvalue cuts or nuclear norm cuts
%  max_cuts: maximum cuts for algorithm iterations

%% initialization
n = size(C, 1);
m = size(A, 1);
t = 1;

X = sdpvar(n, n);

cost = trace(C' * X);
F = [];
% Equality Constraint
for i = 1:m
    F = [F, trace(A{i}' * X) == b(i)];
end
% SOCP Formulation
for i = 1:n
    F = [F, X(i, i) >= 0];
    for j = i+1:n
        F = [F, norm([2 * X(i, j); X(i, i) - X(j, j)]) <= X(i, i) + X(j, j)];
    end
end
%% Iterative Method
opt = [];
consumption = [];
fXY = 1;
tic;
Cons = {};
while fXY > epsilon & t <= max_cuts
    option = sdpsettings('solver', 'mosek', 'savesolveroutput', 1);
    sol = optimize(F, cost, option);

    X_t = value(X);
    if trail_ev
        [fXY, Y_t, Ys] = trail_eig(X_t);
        for j = 1:length(Ys)
            F = [F, -trace(X' * Ys{j}) <= 0];
        end
        Cons{t} = Ys;
        fXY
        value(cost)
    else
        [fXY, Y_t] = nu_norm_cut(X_t);
        F = [F, trace(X' * (Y_t - eye(n))) <= 0];
        Cons{t} = Y_t;
        fXY
        value(cost)
    end

    for r = rem
        if t == r
            opt = [opt, value(cost)];
            cur_t = toc;
            consumption = [consumption, cur_t];
        end
    end
    t = t + 1;
end
overall_t = toc;
opt = [opt, value(cost)];
consumption = [consumption, overall_t];

end

