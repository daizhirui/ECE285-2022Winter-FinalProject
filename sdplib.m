function [C, A, b] = sdplib(filename)
%sdplib loads SDP problem data `C, A, b` from `filename`.
%the SDP problem is in the following format, NOT the SDPLIB format
%       min_X <C,X>
%  subject to <Ai,X>=bi  i = 1 ... m
%             X >= 0
%Return:
%  C: nxn sparse symmetric matrix
%  A: cell array of m nxn sparse symmetric matrices
%  b: nx1 right-hand-side equality constraint vector

fid = fopen(filename);
tline = fgetl(fid);

% skip comments
while ischar(tline)
    disp(tline);
    if tline(1) == '"' || tline(1) == '*'
        tline = fgetl(fid);
    else
        break;
    end
end

% read m, number of constraint matrices
m = textscan(tline, '%d %*[^\n]'); m = m{1};
tline = fgetl(fid);

% read nblocks, number of blocks in each matrix
nblocks = textscan(tline, '%d %*[^\n]'); nblocks = nblocks{1};
tline = fgetl(fid);

% read blockSize, each block is blockSize x blockSize
blockSize = textscan(tline, '%d', nblocks);
blockSize = abs(cell2mat(blockSize));
tline = fgetl(fid);

% read b
b = textscan(tline, '%f');
b = cell2mat(b);
tline = fgetl(fid);

% read matrix data, C = -F0, Ai = Fi
% each line is <matno> <blkno> <i> <j> <entry>
% matno: the index of the matrix
% blkno: the index of the block in the matrix
% i, j: the index in the block
% entry: the element value
% store the data as sparse matrix
matSize = sum(blockSize, 'all');
sparseIdxi = cell(m + 1, 1);
sparseIdxj = cell(m + 1, 1);
sparseVal = cell(m + 1, 1);
while ischar(tline)
    d = textscan(tline, '%d %d %d %d %f\n');
    matno = d{1}; blkno = d{2}; i = d{3}; j = d{4}; entry = d{5};
    
    matno = matno + 1;
    if nblocks > 1
        if blkno > 1
            base = sum(blockSize(1:blkno-1), 'all');
        else
            base = 0;
        end
        i = base + i;
        j = base + j;
    end

    if i ~= j
        sparseIdxi{matno} = [sparseIdxi{matno}; i];
        sparseIdxj{matno} = [sparseIdxj{matno}; j];
        sparseVal{matno} = [sparseVal{matno}; entry];
        sparseIdxi{matno} = [sparseIdxi{matno}; j];
        sparseIdxj{matno} = [sparseIdxj{matno}; i];
        sparseVal{matno} = [sparseVal{matno}; entry];
    else
        sparseIdxi{matno} = [sparseIdxi{matno}; i];
        sparseIdxj{matno} = [sparseIdxj{matno}; j];
        sparseVal{matno} = [sparseVal{matno}; entry]; 
    end

    tline = fgetl(fid);
end

C = sparse(sparseIdxi{1}, sparseIdxj{1}, -sparseVal{1}, matSize, matSize);
A = cell(m, 1);
for i = 1 : m
    A{i} = sparse(sparseIdxi{i+1}, sparseIdxj{i+1}, sparseVal{i+1}, ...
        matSize, matSize);
end

end