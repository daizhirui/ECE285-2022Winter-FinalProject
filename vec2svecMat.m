function Q = vec2svecMat(m)
% Q=vec2svecMat(m) generates a m(m+1)/2 x m^2 matrix that satisfies
% Q * vec(A) == svec(A) where A is an m x m matrix
% Q * Q.' == eye(m*(m+1)/2)

% Q = zeros((m+1)*m/2, m*m);
% Q(ij,kl) = 1, if i == j == k == l
%          = 1/sqrt(2), if i == k ~= j == l or i == l ~= j == k
%          = 0, otherwise

nz = m * m;
sparseIdxi = zeros(nz, 1);
sparseIdxj = zeros(nz, 1);
sparseVal = zeros(nz, 1);
cnt = 1;

rowIdx = 0;
for j = 1 : m
    for i = j : m  % ij
        rowIdx = rowIdx + 1;
        colIdx = 0;

        for k = 1 : m
            for l = 1 : m
                colIdx = colIdx + 1;

                if i == j && i == k && i == l
                    sparseIdxi(cnt) = rowIdx;
                    sparseIdxj(cnt) = colIdx;
                    sparseVal(cnt) = 1;
                    cnt = cnt + 1;
                    % Q(rowIdx, colIdx) = 1;
                elseif (i == k && j == l && k ~= j) || ...
                        (i == l && j == k && l ~= j)
                    sparseIdxi(cnt) = rowIdx;
                    sparseIdxj(cnt) = colIdx;
                    sparseVal(cnt) = 1 / sqrt(2);
                    cnt = cnt + 1;
                    % Q(rowIdx, colIdx) = 1 / sqrt(2);
                % else
                    % Q(rowIdx, colIdx) = 0;
                end % if
            end % for l
        end % for k
    end % for i
end % for j

Q = sparse(sparseIdxi, sparseIdxj, sparseVal);

end