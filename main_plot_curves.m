clc
clear
close all

sdpname = 'maxG11';
% sdpname = 'gpp500-1';

%% pcp
sdplibDir = fullfile([pwd filesep 'sdplib']);
sdpfieldname = replace(sdpname, '-', '_');
sdpfilename = sprintf('%s.dat-s', sdpname);
logDir = fullfile([pwd filesep 'log']);

pcpLogDir = fullfile([logDir filesep 'pcp']);
logDataFile = fullfile([pcpLogDir filesep sdpfilename filesep 'logData.mat']);
load(logDataFile, 'logData');
wsDataFile =  fullfile([pcpLogDir filesep sdpfilename filesep 'wsData.mat']);
load(wsDataFile, 'out');
primalObj = cell2mat(logData.primalObj);
itrs = 1 : size(primalObj, 2);
optimalVal = sdplibList(sdplibDir).(sdpfieldname).val;
fig = figure('Position', [100 100 800 800]);
plot(itrs, out.primalObj, ...
    [itrs(1), itrs(1, end-1)], [optimalVal, optimalVal], ...
    'LineWidth', 2);
title(sprintf('%s: %.1f min', sdpname, out.totalTime / 60));
grid on;
axis([0 itrs(1, end-1) optimalVal - 10 0]);
ax = gca;
ax.FontSize = 20;
legend('PCP', 'Optimal Value');
print(fig, fullfile([pwd filesep 'images' filesep ...
    sprintf('pcp-%s-curve.eps', sdpfilename)]), ...
    '-vector', '-depsc');

%% pbs
sdpfieldname = replace(sdpname, '-', '_');
sdpfilename = sprintf('%s.dat-s', sdpname);
logDir = fullfile([pwd filesep 'log']);

pcpLogDir = fullfile([logDir filesep 'pbs']);
logDataFile = fullfile([pcpLogDir filesep sdpfilename filesep 'logData.mat']);
load(logDataFile, 'time', 'logData');
primalObj = cell2mat(logData.primalObj);
itrs = 1 : size(primalObj, 2);
optimalVal = sdplibList(sdplibDir).(sdpfieldname).val;
fig = figure('Position', [100 100 800 800]);
plot(itrs, primalObj, ...
    [itrs(1), itrs(1, end-1)], [optimalVal, optimalVal], ...
    'LineWidth', 2);
title(sprintf('%s: %.1f min', sdpname, time / 60));
grid on;
axis([0 itrs(1, end-1) -670 -600]);
ax = gca;
ax.FontSize = 20;
legend('PBS', 'Optimal Value');
print(fig, fullfile([pwd filesep 'images' filesep ...
    sprintf('pbs-%s-curve.eps', sdpfilename)]), ...
    '-vector', '-depsc');

%% sbm
sdpfieldname = replace(sdpname, '-', '_');
sdpfilename = sprintf('%s.dat-s', sdpname);
logDir = fullfile([pwd filesep 'log']);

pcpLogDir = fullfile([logDir filesep 'sbm']);
logDataFile = fullfile([pcpLogDir filesep sdpfilename filesep 'logData.mat']);
load(logDataFile, 'time', 'logData');
primalObj = cell2mat(logData.primalObj);
itrs = 1 : size(primalObj, 2);
optimalVal = sdplibList(sdplibDir).(sdpfieldname).val;
fig = figure('Position', [100 100 800 800]);
plot(itrs, primalObj, ...
    [itrs(1), itrs(1, end-1)], [optimalVal, optimalVal], ...
    'LineWidth', 2);
title(sprintf('%s: %.1f min', sdpname, time / 60));
grid on;
axis([0 itrs(1, end-1) -670 -600]);
ax = gca;
ax.FontSize = 20;
legend('SBM', 'Optimal Value');
print(fig, fullfile([pwd filesep 'images' filesep ...
    sprintf('sbm-%s-curve.eps', sdpfilename)]), ...
    '-vector', '-depsc');
