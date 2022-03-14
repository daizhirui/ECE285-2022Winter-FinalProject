function Abar = linearOpT2mat(A)
% LINEAROPT2MAT Convert linear operator A={A1,A2,...,Am} to a 2D matrix as
% [vec(A1), vec(A2), ... vec(Am)], which is a n^2 x m matrix.

    m = size(A, 1);
    n = size(A{1}, 1);
    nz = nnz(A{1});
    for i = 2 : m
        nz = nz + nnz(A{i});
    end
    Abar = spalloc(n * n, m, nz);
    for i = 1 : m
        Abar(:, i) = vec(A{i});  %#ok<SPRIX>
    end

end