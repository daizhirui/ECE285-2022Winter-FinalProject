function [V, S] = safeSmallestEigs(Z, s)
% SAFESMALLESTEIGS Calculate the s smallest eigenvalues of Z safely to
% guarantee that eigs calculates the expected number of eigenvalues.
% Argument:
%   Z: nxn symmetric matrix
%   s: number of smallest eigenvalues to calculate
% Note:
% Occasionally, eigs returns two different smallest eigenvalues in two
% trials with the same input Z but different s due to the smallest
% eigenvalue has multiplicity greater than 1. Pay attention!

n = size(Z, 1);
nn = min([s, n]);
while nn <= size(Z, 1)
    [V, S] = eigs(Z, nn, 'smallestreal', 'FailureTreatment', 'drop');
    if size(S, 1) >= s
        break;
    else
        nn = 2 * nn;
    end
end

end