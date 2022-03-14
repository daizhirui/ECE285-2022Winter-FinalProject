% MAIN_CHECK_ASSUMPTION3 Check how many feasible SDP problems in SDPLIB
% satisfy the assumption: "A(X)=b --> trace(X)=a".

clc
clear
close all

ins = sdplibList(fullfile([pwd filesep 'sdplib']));
insnames = fieldnames(ins);
cnt = 0;
for i = 1 : size(insnames, 1)
    sdp = ins.(insnames{i});
    [C, A, b] = sdplib(sdp.path);
    [tf, ~, ~] = checkAssumption3(A, b);
    if tf
        fprintf('%s pass\n', sdp.filename);
        cnt = cnt + 1;
    end
end

fprintf('%f%% pass\n', cnt / size(insnames, 1) * 100);
