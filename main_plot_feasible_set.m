clc
clear
close all

% sdpname = 'maxG11.dat-s';
sdpname = 'mcp100.dat-s';
% sdpname = 'qap5.dat-s';

% fig1 = plotFeasibleSet(getDataDir('pcp', sdpname), 'pcp', ...
%     [900 400 300 200 100 50]); % maxG11
fig1 = plotFeasibleSet(getDataDir('pcp', sdpname), 'pcp', 169 : -40 : 2);
saveFigure(fig1, 'pcp', sdpname);

fig2 = plotFeasibleSet(getDataDir('pbs', sdpname), 'pbs', [16 4 3 2 1]);
saveFigure(fig2, 'pbs', sdpname);

fig3 = plotFeasibleSet(getDataDir('sbm', sdpname), 'sbm', 1 : 2 : 8);
saveFigure(fig3, 'sbm', sdpname);


function dataDir = getDataDir(algName, sdpName)
    dataDir = fullfile([pwd filesep 'log' filesep ...
        algName filesep sdpName]);
end

function saveFigure(fig, algName, sdpName)
    print(fig, fullfile([...
        pwd filesep 'images' filesep ...
        sprintf('%s-%s-feasible.eps', algName, sdpName)]), ...
        '-vector', '-depsc');
end