function [opt, Y_t] = nu_norm_cut(X)
    n = size(X, 1);
    [U, D, V] = svd(X);
    Y_t = U * V.';
    opt = trace(X.' * (Y_t - eye(n)));
end