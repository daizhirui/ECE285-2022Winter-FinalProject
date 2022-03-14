clc
clear
close all

ins = sdplibList(fullfile([pwd filesep 'sdplib']));
insnames = fieldnames(ins);
record = true;
logfile = fullfile([pwd filesep 'log' filesep 'sbm' filesep 'bench.txt']);

sbmOptions = struct;
sbmOptions.('maxG55') = sbmOption('R', 10, 's', 8, 'record', true, 'logName', 'maxG55.dat-s');
sbmOptions.('maxG60') = sbmOption('R', 10, 's', 8, 'record', true, 'logName', 'maxG60.dat-s');
sbmOptions.('qpG11') = sbmOption('R', 20, 's', 15, 'record', true, 'logName', 'qpG11.dat-s');
sbmOptions.('qpG51') = sbmOption('R', 20, 's', 15, 'record', true, 'logName', 'qpG51.dat-s');
sbmOptions.('thetaG11') = sbmOption('R', 20, 's', 15, 'record', true, 'logName', 'thetaG11.dat-s');
sbmOptions.('thetaG51') = sbmOption('R', 20, 's', 15, 'record', true, 'logName', 'thetaG51.dat-s');

for i = 1 : size(insnames, 1)
    sdp = ins.(insnames{i});

    fprintf("======================\n");
    fprintf("%s\n", sdp.filename);
    fprintf("======================\n");

    if ~sdp.assumption3
        continue;
    end

    if isfield(sbmOptions, insnames{i})
        option = sbmOptions.(insnames{i});
    else
        option = sbmOption('record', true, 'logName', sdp.filename);
    end
    dataFile = fullfile([option.logDir filesep sdp.filename filesep ...
        'wsData.mat']);
    if isfile(dataFile)
        clear('out');
        load(dataFile, 'out');
    else
        [C, A, b] = sdplib(sdp.path);
        rng(0);
        out = sbm(C, A, b, option);
    end

    % only copy needed fields
    sdp.out = struct;
    sdp.out.problem = out.problem;
    sdp.out.info = out.info;
    sdp.out.totalTime = out.totalTime;
    sdp.out.primalObj = out.primalObj;
    sdp.out.dualObj = out.dualObj;
    sdp.out.dualGap = out.dualGap;
    sdp.primalAcc = (out.primalObj - sdp.val) / sdp.val;
    sdp.dualAcc = (out.dualObj - sdp.val) / sdp.val;
    ins.(insnames{i}) = sdp;
end

if record
    diary off
    if isfile(logfile)
        delete(logfile)
    end
    diary(logfile);
end

for i = 1 : size(insnames, 1)
    sdp = ins.(insnames{i});

    if ~sdp.assumption3
        continue;
    end

    if sdp.out.problem ~= 0 && sdp.out.totalTime < 0
        if isa(sdp.out.info, 'MException')
            sdp.out.info = sdp.out.info.message;
        end
        fprintf('%s\t%s\n', sdp.filename, sdp.out.info);
        continue;
    end

    time = sdp.out.totalTime;
    hour = floor(time / 3600);
    min = floor((time - hour * 3600) / 60);
    sec = round(time - 3600 * hour - 60 * min);
    fprintf('%s\t%s\t%02d:%02d:%02d\t%.6e(%f%%)\t%.6e(%f%%)\t%.6e(%f%%)\n', ...
        sdp.filename, sdp.out.info, hour, min, sec, ...
        sdp.out.primalObj, sdp.primalAcc * 100, ...
        sdp.out.dualObj, sdp.dualAcc * 100, ...
        sdp.out.dualGap, sdp.out.dualGap / sdp.out.dualObj * 100);
    % fprintf('%s & %s & %02d:%02d:%02d & %.3e(%f\\%%) & %.3e(%f\\%%)\\\\ \\hline\n', ...
    %     sdp.filename, sdp.out.info, hour, min, sec, ...
    %     sdp.out.dualObj, sdp.dualAcc * 100, ...
    %     sdp.out.dualGap, sdp.out.dualGap / sdp.out.dualObj * 100);
end

diary off;
