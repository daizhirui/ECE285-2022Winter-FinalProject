function [fig, feasible] = plotFeasibleSet(dataDir, algName, itrs)
% PLOTFEASIBLESET Plot the feasible set at different iteration.
% Argument:
%   dataDir: folder of algorithm output
%   algName: algorithm name, 'pcp', 'pbs' or 'sbm'
%   itrs: array of iteration indices

dataFile = fullfile([dataDir filesep 'data.mat']);
feasibleFile = fullfile([dataDir filesep 'feasible.mat']);

fig = figure('Position', [100 100 1000 1000]);
hold on;
grid on;
box on;
xlabel('$x_1$', 'Interpreter', 'latex');
ylabel('$x_2$', 'Interpreter', 'latex');
ax = gca;
ax.FontSize = 20;
lineWidth = 2;
faceAlpha = 1.0;

if isfile(feasibleFile)
    load(feasibleFile, 'feasible');
    fields = cell(1, size(feasible.itrs, 2) + 1);
    if strcmp(algName, 'pcp') || strcmp(algName, 'pbs')
        plotBoundary(feasible.ori, inf, ...
            'FaceAlpha', faceAlpha, ...
            'LineWidth', lineWidth, 'LineStyle', '-');
        fields{1} = 'SDP';
        j = 1;
    else
        j = 0;
    end

    for i = 1 : size(feasible.itrs, 2)
        k = feasible.itrs(i);
        field = sprintf('k%d', k);
        plotBoundary(feasible.(field), k, ...
            'FaceAlpha', faceAlpha, ...
            'LineWidth', lineWidth, 'LineStyle', '-');
        fields{i+j} = field;
    end

    if strcmp(algName, 'pbs') || strcmp(algName, 'sbm')
        plotBoundary(feasible.ori, inf, ...
            'FaceAlpha', faceAlpha, ...
            'LineWidth', lineWidth, 'LineStyle', '-');
        fields{end} = 'SDP';
    end
    legend(fields);
   
    return;
end

if strcmp(algName, 'pcp')
    load(dataFile, 'A', 'b', 'D', 'logData');
    DSize = logData.DSize;
    if ~exist('itrs', 'var')
        itrs = size(DSize, 2) : -1 : 1;
    end
    i1 = 1; j1 = 2; i2 = i1; j2 = j1 + 1;

    n = size(A{1}, 1);

    % original feasible set
    feasible.ori = plotOriginalBoundary(A, b, i1, j1, i2, j2);
    feasible.itrs = [];

    for k = itrs
        m = DSize{k}(2);
        DD = D(:, 1 : m);

        X = sdpvar(n, n, 'symmetric');
        xx = sdpvar(m, 1);
        cons = [X == DD * diag(xx) * DD', linearOp(A, X) == b, xx >= 0];

        fprintf('k = %d ...', k);
        pts = plot(cons, [X(i1, j1), X(i2, j2)], 4e3); pts = pts{1}';
        if size(pts, 1) == 0
            fprintf('empty, skip\n'); continue;
        end

        try
            plotBoundary(pts, k, ...
                'FaceAlpha', faceAlpha, ...
                'LineWidth', lineWidth, 'LineStyle', '-');
            field = sprintf('k%d', k);
            feasible.(field) = pts;
            feasible.itrs = [feasible.itrs, k];
            fprintf('done\n');
        catch
            fprintf('plotErr, skip\n'); continue;
        end
    end
    
    save(feasibleFile, "feasible");

elseif strcmp(algName, 'pbs')
    load(dataFile, 'A', 'a', 'b', 'D', 'logData');
    DSize = logData.DSize;
    if ~exist('itrs', 'var')
        itrs = size(DSize, 2) : -1 : 1;
    end
    i1 = 1; j1 = 2; i2 = i1; j2 = j1 + 1;

    n = size(A{1}, 1);

    % original feasible set
    feasible.itrs = [];

    for k = itrs
        m = DSize{k}(2);
        DD = D(:, 1 : m);

        X = sdpvar(n, n, 'symmetric');
        xx = sdpvar(m, 1);
        cons = [X == DD * diag(xx) * DD', xx >= 0, sum(xx) == a];

        fprintf('k = %d ...', k);
        pts = plot(cons, [X(i1, j1), X(i2, j2)], 4e3); pts = pts{1}';
        if size(pts, 1) == 0
            fprintf('empty, skip\n'); continue;
        end

        try
            plotBoundary(pts, k, ...
                'FaceAlpha', faceAlpha, ...
                'LineWidth', lineWidth, 'LineStyle', '-');
            field = sprintf('k%d', k);
            feasible.(field) = pts;
            feasible.itrs = [feasible.itrs, k];
            fprintf('done\n');
        catch
            fprintf('plotErr, skip\n'); continue;
        end
    end
    
    feasible.ori = plotOriginalBoundary(A, b, i1, j1, i2, j2);
    save(feasibleFile, "feasible");

elseif strcmp(algName, 'sbm')
    load(dataFile, 'A', 'a', 'b', 'logData');
    if ~exist('itrs', 'var')
        itrs = size(logData.Pk, 2) : -1 : 1;
    end
    i1 = 1; j1 = 2; i2 = i1; j2 = j1 + 1;

    n = size(A{1}, 1);
    feasible.itrs = [];

    for k = itrs
        Pk = logData.Pk{k};
        R = size(Pk, 2);
        Wbark = logData.Wbark{k};
        aa = sdpvar(1, 1);
        V = sdpvar(R, R, 'symmetric');
        X = sdpvar(n, n, 'symmetric');
        cons = [X == aa * Wbark + Pk * V * Pk', aa + trace(V) == a, ...
            aa >= 0, V >= 0];

        fprintf('k = %d ...', k);
        pts = plot(cons, [X(i1, j1), X(i2, j2)], 4e3); pts = pts{1}';
        if size(pts, 1) == 0
            fprintf('empty, skip\n'); continue;
        end

        try
            plotBoundary(pts, k, ...
                'FaceAlpha', faceAlpha, ...
                'LineWidth', lineWidth, 'LineStyle', '-');
            field = sprintf('k%d', k);
            feasible.(field) = pts;
            feasible.itrs = [feasible.itrs, k];
            fprintf('done\n');
        catch
            fprintf('plotErr, skip\n'); continue;
        end
    end
    
    % original feasible set
    feasible.ori = plotOriginalBoundary(A, b, i1, j1, i2, j2);
    save(feasibleFile, "feasible");

else
    fprintf('Unknown algorithm: %s\n', algName);
end

end

function pts = plotOriginalBoundary(A, b, i1, j1, i2, j2)
    n = size(A{1}, 1);
    X = sdpvar(n, n, 'symmetric');
    cons = [linearOp(A, X) == b, X >= 0];
    pts = plot(cons, [X(i1, j1), X(i2, j2)], 4e3); pts = pts{1}';
    plotBoundary(pts, 1, ...
                'FaceAlpha', faceAlpha, ...
                'LineWidth', lineWidth, 'LineStyle', '-');
end

function plotBoundary(pts, varargin)
    % plot the boundary
    K = convhull(pts, 'Simplify', true);
    patch(pts(K, 1), pts(K, 2), varargin{:});
    colorbar;
end