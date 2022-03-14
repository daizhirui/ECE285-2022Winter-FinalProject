clc
clear
close all

warning off;

sdpins = sdplibList(fullfile([pwd filesep 'sdplib']));
sdpnames = {'mcp100'; 'mcp124_2'; 'mcp250_1'; 'mcp500_1'};
algnames = {'mosek'; 'pcp'; 'pbs'; 'sbm'};

for j = 1 : size(algnames, 1)
    algname = algnames{j};
    fprintf('%s\t', algname);
    for i = 1 : size(sdpnames, 1)
        sdpname = sdpnames{i};
        datafile = fullfile([pwd filesep 'log' filesep algname filesep...
            sdpins.(sdpname).filename filesep 'data.mat']);
        load(datafile, 'time', 'dualObj');
        optimalVal = sdpins.(sdpname).val;
        acc = -(dualObj - optimalVal) / optimalVal * 100;
        if time > 300
            fprintf('%f/%f(%f min)\t', dualObj, acc, time / 60);
        else
            fprintf('%f/%f(%f sec)\t', dualObj, acc, time);
        end
    end
    fprintf('\n');
end

warning on;