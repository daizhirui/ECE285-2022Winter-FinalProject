function [opt, Y_t] = trail_eig(X)
    n = size(X, 1);
    % Can use power method instead
    [V, D] = eig(X);
    y_t = V(:, 1);

    Y_t = y_t * y_t';
    opt = -y_t' * X * y_t;
end