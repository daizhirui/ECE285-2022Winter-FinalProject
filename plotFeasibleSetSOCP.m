function fig = plotFeasibleSetSOCP(A, b, Ys)
    fig = figure('Position', [100 100 800 800]);
    hold on;
    grid on;
    box on;
    xlabel('$x_1$', 'Interpreter', 'latex');
    ylabel('$x_2$', 'Interpreter', 'latex');
    ax = gca;
    ax.FontSize = 20;

        m = 14;
        X = sdpvar(m, m);
        cons = [];
        cons2 = [X >= 0];
        for i = 1:m
            cons = [cons, X(i, i) >= 0];
            for j = i+1:m
                cons = [cons, norm([2 * X(i, j); X(i, i) - X(j, j)]) <= X(i, i) + X(j, j)];
            end
        end
        for i = 1:13
            cons = [cons, trace(A{i}' * X) == b(i)];
            cons2 = [cons2, trace(A{i}' * X) == b(i)];
        end

    
            
    pts = plot(cons, [X(1, 1), X(2, 2)], 4e3); pts = pts{1}';
    plotBoundary(pts, 1,...
                'FaceAlpha', 0.5, ...
                'LineWidth', 2, 'LineStyle', '-');

    for i = 1:4:37
        for j = 1:length(Ys{i})
            cons = [cons, trace(X' * (Ys{i}{j})) >= 0 ];
        end
        pts = plot(cons, [X(1, 1), X(2, 2)], 4e3); pts = pts{1}';

            plotBoundary(pts, 1, ...
                'FaceAlpha', 0.5, ...
                'LineWidth', 2, 'LineStyle', '-');

        colorbar;
    end
    
    pts = plot(cons2, [X(1, 1), X(2, 2)], 4e3); pts = pts{1}';
    plotBoundary(pts, 1, 'FaceColor','red',...
                'FaceAlpha', 0.5, ...
                'LineWidth', 2, 'LineStyle', '-');

end

function plotBoundary(pts, varargin)
    % plot the boundary
    K = convhull(pts, 'Simplify', true);
    size(pts(K, 1))
    size(pts(K, 2))
    patch(pts(K, 1), pts(K, 2), varargin{:});
end