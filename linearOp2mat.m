function Abar = linearOp2mat(A)
% LINEAROP2MAT converts linear operator A={A1,A2,...,Am} to a 2D matrix as
% [vec(A1)';vec(A2)';...;vec(Am)'], which is a m x n^2 matrix.
    Abar = linearOpT2mat(A)';
end