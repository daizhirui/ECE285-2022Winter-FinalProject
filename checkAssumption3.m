function [tf, a, ybar] = checkAssumption3(A, b)
% CHECKASSUMPTION3 Check if the assumption "A(X)=b --> trace(X)=a" holds.

m = size(A, 1); n = size(A{1}, 1);
ybar = sdpvar(m, 1);
a = b' * ybar;
options = sdpsettings('verbose', 0, 'solver', 'mosek');
sol = optimize(linearOpT(A, ybar) == eye(n), b' * ybar, options);

if sol.problem
    tf = false;
    a = []; ybar = [];
else
    tf = true;
    a = value(a);
    ybar = value(ybar);
end

end