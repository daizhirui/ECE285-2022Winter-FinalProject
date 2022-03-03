function sbm(C, A, b, epsilon, mL, u, R)
%sbm implements spectral bundle method for solving the following SDP
%problem:
%       min_X <C,X>
%  subject to <Ai,X>=bi  i = 1 ... m
%             X >= 0
%according to "A Spectral Bundle Method for Semidefinite Programming" by
%C.Helmberg and F.Rendl
%Arguments:
%  C: n x n symmetric matrix
%  A: m x n x n, linear operator consisting of m nxn symmetric matrices
%     trace(A(i, :, :).' * X) = b(i) is <Ai,X>=bi for i=1...m
%  b: right-hand-side vector of the equality constrraint
%  epsilon: termination criteria
%  mL: an improvment parameter, 0 < mL < 0.5
%  u: the parameter to adjust searching region in each iteration, the
%     larger u is, the smaller the region will be
%  R: upper bound of the number of columns in the bundle matrix P

%% initialization
n = size(C, 1);
m = size(A, 1);
k = 0;
y = rand(m, 1);
x = y;
[v0, lambda0] = eigs(C - linearOpT(A, x), 1, 'largestreal');
P = v0;
Wbar = v0 * v0.';

% find ybar such that linearOpT(A, ybar) = I
% nz = nnz(A{1});
% for i = 2 : m
%     nz = nz + nnz(A{i});
% end
% Abar = spalloc(n * n, m, nz);
% for i = 1 : m
%     Abar(:, i) = vec(A{i}); %#ok<SPRIX> 
% end
ybar = linearOpT2mat(A) \ vec(eye(m));
a = ybar.' * b;

%% direction finding
r = size(P, 2);
V = sdpvar(r, r);
alpha = sdpvar(1, 1);
W = alpha * Wbar + P * V * P.';
d = b - a * linearOp(A, W);
cost = a * sum((C - linearOpT(A, y)) .* W, 'all') + b.' * y + d.' * d / u / 2;
cons = [alpha >= 0, V >= 0, alpha + trace(V) == 1];
optimize(cons, cost);

end

