

n = 5;
A = rand(n,n);
A = (A+A')/2;
B = rand(n,n);
B = (B+B')/2;
%%
x = sdpvar(2, 1);
cons = [ eye(n) + x(1)*A+x(2)*B  >= 0];

pts = plot(cons, x, 4e3); pts = pts{1}';

plotBoundary(pts, 1, ...
    'FaceAlpha', 0.5, ...
    'LineWidth', 2, 'LineStyle', '-');
  
 %%
  
option = sdpsettings('solver','mosek','verbose',1,'savesolveroutput',1);
tstart = tic;
sol = optimize(cons,x(1)+x(2), option)
consump_time = toc(tstart);
ori_obj = trace(value(X)'*C)
value(x)

%%
V = zeros(n, n^2);
loc = nchoosek(1:n,2);
loc_n = size(loc, 1);
for i = 1:loc_n
  V(loc(i, 1), i) = 1;
  V(loc(i, 2), i) = 1;
end

for i = 1:loc_n
  V(loc(i, 1), i+loc_n) = 1;
  V(loc(i, 2), i+loc_n) = -1;
end

for i = 1:n
  V(i, i+2*loc_n) = 1;
end

U = eye(n);

fprintf("phase 2 \n")
alpha = sdpvar(n^2, 1);


for iter = 2 : 6
  X = eye(n) + x(1)*A+x(2)*B;
  
  rhs = zeros(n);
  Constraints = [alpha>=0];
  for i = 1:n^2
    prod = U'*V(:, i);
    rhs =rhs+ alpha(i)*(prod * prod');
  end
  Constraints = [Constraints, X - 0*eye(n) == rhs];

  Objective =-x(1)-x(2);

  option = sdpsettings('solver','mosek','verbose',0);
  
  sol = optimize(Constraints,Objective, option);
  xk = value(x);
  fprintf('iterations = %g, obj = %3e \n', iter, xk(1)+xk(2))

  
  Xk = eye(n) + xk(1)*A+xk(2)*B;
  %[U, D] = ldl(Xk);
  %U = U' ;
  U = chol(Xk);

  pts = plot(Constraints, x, 4e3); pts = pts{1}';

  plotBoundary(pts, iter, ...
      'FaceAlpha', 0.5, ...
      'LineWidth', 2, 'LineStyle', '-');
  colorbar;

end



%%
figure
x = sdpvar(2, 1);
cons = [ eye(n) + x(1)*A+x(2)*B >= 0];

pts = plot(cons, x, 4e3); pts = pts{1}';

plotBoundary(pts, 1, ...
    'FaceAlpha', 0.5, ...
    'LineWidth', 2, 'LineStyle', '-');

V = zeros(n, 2, n*(n-1)/2);
loc = nchoosek(1:n,2);
loc_n = size(loc, 1);
count = 1;
for i = 1:n-1
  for j = i+1:n
    V(i, 1, count) = 1;
    V(j, 2, count) = 1;
    count = count + 1;
  end
end

U = eye(n);

fprintf("phase 2 \n")
lambda = sdpvar(2,2,n*(n-1)/2);

for iter = 2 : 10
  X = eye(n) + x(1)*A+x(2)*B;
  
  rhs = zeros(n);
  Constraints = [];
  for i = 1: n*(n-1)/2
    prod = U'*V(:,:, i);
    rhs =rhs+ prod * lambda(:,:,i) * prod';
    Constraints = [Constraints lambda(:,:,i)>=0];
  end
  Constraints = [Constraints, X == rhs];
  
  Objective =-x(1)-x(2);

  option = sdpsettings('solver','mosek','verbose',0);
  
  sol = optimize(Constraints,Objective, option);
  xk = value(x);
  fprintf('iterations = %g, obj = %3e \n', iter, xk(1)+xk(2))

  Xk = eye(n) + xk(1)*A+xk(2)*B;

  U = chol(Xk);

  pts = plot(Constraints, x, 4e3); pts = pts{1}';

  plotBoundary(pts, iter, ...
      'FaceAlpha', 0.5, ...
      'LineWidth', 2, 'LineStyle', '-');
  colorbar;

end

function plotBoundary(pts, varargin)
    % plot the boundary
    K = convhull(pts, 'Simplify', true);
    patch(pts(K, 1), pts(K, 2), varargin{:});
end

