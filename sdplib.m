function [C, A, b] = sdplib(filename)
%sdplib loads SDP problem data `C, A, b` from `filename`.
%the SDP problem is in the following format, NOT the SDPLIB format
%       min_X <C,X>
%  subject to <Ai,X>=bi  i = 1 ... m

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

% read matrix data, C = -F0 = -F(1,:,:), Ai = Fi = F(i+1,:,:)
% each line is <matno> <blkno> <i> <j> <entry>
% matno: the index of the matrix
% blkno: the index of the block in the matrix
% i, j: the index in the block
% entry: the element value
matrixSize = sum(blockSize, 'all');
F = zeros(m + 1, matrixSize, matrixSize);
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

    F(matno, i, j) = entry;

    tline = fgetl(fid);
end

C = -squeeze(F(1, :, :));
A = F(2:end, :, :);

end