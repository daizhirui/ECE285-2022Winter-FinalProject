function output = svec(A)

    n = size(A, 1);
    scale = tril(ones(n), -1) * sqrt(2) + eye(n);
    mask = tril(true(n));

    output = A(mask) .* scale(mask);

end