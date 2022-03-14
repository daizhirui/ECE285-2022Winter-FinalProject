clc
clear
close all

names = {'maxG11'; 'gpp100'; 'thetaG11'; 'theta3'};
% name = 'arch0';
% name = 'control1';
% name = 'control8';
% name = 'equalG11';
% name = 'maxG11';
% name = 'maxG32';
% name = 'maxG55';
% name = 'maxG60';
% name = 'gpp500-1';
% name = 'gpp500-2';
% name = 'hinf1';
% name = 'hinf15';
name = 'mcp100';
% name = 'mcp124-1';
% name = 'mcp124-2';
% name = 'mcp124-3';
% name = 'mcp124-4;
% name = 'mcp250-1';
% name = 'mcp250-2';
% name = 'mcp500-1';
% name = 'mcp500-2';
% name = 'qap5';
% name = 'qap6';
% name = 'qap7';
% name = 'qap8';
% name = 'qap9';
% name = 'qap10';
% name = 'qpG11';
% name = 'qpG51';
% name = 'thetaG11';
% name = 'thetaG51';
% name = 'theta1';
% name = 'truss1';

ins = sdplibList(fullfile([pwd filesep 'sdplib']));
filename = sprintf('%s.dat-s', name);
[C, A, b] = sdplib(sprintf('sdplib/%s', filename));

sbmOptions.('maxG55') = sbmOption('R', 10, 's', 8, 'record', true, 'logName', 'maxG55.dat-s');
sbmOptions.('maxG60') = sbmOption('R', 10, 's', 8, 'record', true, 'logName', 'maxG60.dat-s');
sbmOptions.('qpG11') = sbmOption('R', 20, 's', 15, 'record', true, 'logName', 'qpG11.dat-s');
sbmOptions.('qpG51') = sbmOption('R', 20, 's', 15, 'record', true, 'logName', 'qpG51.dat-s');
sbmOptions.('thetaG11') = sbmOption('R', 20, 's', 15, 'record', true, 'logName', 'thetaG11.dat-s');
sbmOptions.('thetaG51') = sbmOption('R', 20, 's', 15, 'record', true, 'logName', 'thetaG51.dat-s');

out = struct;
rng(0); out.pcp = pcp(C, A, b, pcpOption('record', true, 'logName', filename));
rng(0); out.pbs = pbs(C, A, b, pbsOption('record', true, 'logName', filename));
if isfield(sbmOptions, name)
    rng(0); out.sbm = sbm(C, A, b, sbmOptions.(name));
else
    rng(0); out.sbm = sbm(C, A, b, sbmOption('record', true, 'logName', filename));
end
% solveByMosek(C, A, b, filename);

sdp = ins.(replace(name, '-', '_'));
fprintf('Error: %f%%\n', (out.pcp.dualObj - sdp.val) / abs(sdp.val) * 100);
fprintf('Error: %f%%\n', (out.pbs.dualObj - sdp.val) / abs(sdp.val) * 100);
fprintf('Error: %f%%\n', (out.sbm.dualObj - sdp.val) / abs(sdp.val) * 100);
