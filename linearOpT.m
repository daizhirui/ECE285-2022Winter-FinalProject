function output = linearOpT(A, y)

    if size(A, 1) ~= size(y, 1)
        error('Dimensions of A and y are incompatible.');
    end

    output = A{1} * y(1);
    for i = 2 : size(A, 1)
        output = output + A{i} * y(i);
    end
end