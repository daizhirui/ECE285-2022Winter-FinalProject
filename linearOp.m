function output = linearOp(A, X)
%linearOp calculates the linear mapping from S^{nxn} to R^m
%Arguments:
%  A: cell array of m nxn symmetric matrices
%  X: nxn symmetric matrices
    
    m = size(A, 1);
    output = zeros(m, 1);
    for i = 1 : m
        output(i) = sum(A{i} .* X, 'all');
    end
    
end