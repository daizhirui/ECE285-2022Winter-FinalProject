clc
clear
close all

[C, A, b] = sdplib('sdplib/hinf1.dat-s');
%% SDP Solution
tic;
n = size(C, 1);
m = size(A, 1);
X = sdpvar(n, n);

cost_sdp = trace(C' * X);
F = [X >= 0];
for i = 1:m
    F = [F, trace(A{i}' * X) == b(i)];
end

option = sdpsettings('solver', 'mosek', 'savesolveroutput', 1);
sol = optimize(F, cost_sdp, option);
t_SDP = toc
value(cost_sdp)

%% Cutting Plane
[opt, consumption, Cons] = socp_decomp(C, A, b, 1e-5, true, 100, [1, 5, 20, 100]);
plotFeasibleSet(A, b, Cons);
