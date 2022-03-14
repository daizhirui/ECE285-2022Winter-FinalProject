function [Xsol, ysol, primalObj, dualObj] = calculatePrimalDual2( ...
    A, C, b, Xhatk, yhatk, ybar)
% CALCULATEPRIMALDUAL2 Calculate the solutions and objectives of the primal
% and dual problems respectively for polyhedral bundle scheme algorithm and
% spectral bundle scheme.

Xsol = []; primalObj = []; dualObj = [];

ysol = yhatk;
nn = 1;
Zsol = C - linearOpT(A, ysol);
while nn <= size(Zsol, 1)
    lam = eigs(Zsol, nn, 'smallestreal', 'FailureTreatment', 'drop');
    if size(lam, 1) >= 1
        break;
    else
        nn = 2 * nn;
    end
end
if size(lam, 1) >= 1
    ysol = ysol + lam(1) * ybar;
    dualObj = full(b' * ysol); 
else
    disp('Failed to calculate dual solution and dual objective.');
end

if size(Xhatk, 1) > 0
%     % A(Xsol) == b
%     % <Zsol, Xsol> == 0 --> Xsol * Zsol == zeros(n, n)
%     % A(Xhatk) = b + u(yhat - yhatk)
%     % Xsol = Xhatk + deltaX
%     % here, yhat is not provided.
%     n = size(Xhatk, 1);
%     deltaX = sdpvar(n, n, 'symmetric');
%     Xsol = Xhatk + deltaX;
%     cons = [linearOp(A, Xsol) == b, Xsol * Zsol == zeros(n, n)];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  ];
%     sol = optimize(cons);
%     if sol.problem ~= 0
%         disp('Failed to calculate the corrected primal solution for zero gap.');
%         
%     else
%         Xsol = value(Xsol);
%     end

%     [U, D] = eig(Xhatk);
%     x = sdpvar(size(U, 1), 1);
%     Xsol = U * diag(x) * U';
%     cost = sum(C .* Xsol, 'all');
%     cons = [linearOp(A, Xsol) == b, x >= 0];
%     sol = optimize(cons, cost);
% 
%     disp(value(cost));

    Xsol = Xhatk;
    primalObj = full(sum(C .* Xsol, 'all'));
else
    disp('Failed to calculate primal solution and primal objective.');
end

end