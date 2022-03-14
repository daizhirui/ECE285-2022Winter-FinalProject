function y0 = initY(C, A, b)
%initY Calculate an initial point y0

m = size(A, 1);
y0 = sdpvar(m, 1);
Z = C - linearOpT(A, y0);
cost = b.' * y0;
cons = diag(Z) >= 0;
optimize(cons, -cost);
y0 = value(y0);

end