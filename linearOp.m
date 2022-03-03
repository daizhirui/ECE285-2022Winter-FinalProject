function output = linearOp(A, X)
%linearOp calculates the linear mapping from S^{nxn} to R^m
%Arguments:
%  A: cell array of m nxn symmetric matrices
%  X: nxn symmetric matrices
    
    output = linearOp2mat(A) * vec(X);
    
end