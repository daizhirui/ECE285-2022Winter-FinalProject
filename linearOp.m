function output = linearOp(A, X)
% LINEAROP calculates the linear mapping from S^{nxn} to R^m:
%   A(X) = [<A_1, X>; <A_2, X>; ...; <A_m, X>]
% Arguments:
%   A: cell array of m nxn symmetric matrices
%   X: nxn symmetric matrices
    output = linearOp2mat(A) * vec(X);
end