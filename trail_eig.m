function [opt, Y_t, Ys] = trail_eig(X)
    n = size(X, 1);
    Ys = {};
    % Can use power method instead
    [V, D] = eig(X);
    y_t = V(:, 1);
    y_t = y_t / norm(y_t);

    Y_t = y_t * y_t';
    Ys{1} = Y_t;
    opt = -y_t' * X * y_t;
    for i = 2:n
        y_t = V(:, i);
        y_t = y_t / norm(y_t);
        if D(i, i) < 0
            Ys{i} = y_t * y_t';
        else
            break;
        end
    end
end