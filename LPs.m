[C, A, b] = sdplib('sdplib/control1.dat-s');
n = size(C, 1);
m = size(A, 1);

X = sdpvar(n, n, 'symmetric');

Constraints = [X>=0];
for i =1:m
  Constraints = [Constraints, trace(X'*A{i}) == b(i)];
end

Objective = trace(X'*C);
option = sdpsettings('solver','mosek','verbose',1,'savesolveroutput',1);
tstart = tic;
sol = optimize(Constraints,Objective, option)
consump_time = toc(tstart);
ori_obj = trace(value(X)'*C)
X_11 = value(X(1,1))
X_12 = value(X(1,2))


pts = plot(Constraints, [X(1,1),X(1,2)], 4e3); pts = pts{1}';

plotBoundary(pts, 1, ...
    'FaceAlpha', 0.5, ...
    'LineWidth', 2, 'LineStyle', '-');
  
objs_LP = [];

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
alpha = sdpvar(n^2, 1);
X = sdpvar(n, n);
gamma = sdpvar(1,1);
tstart = tic;
for iter = 1 : 3

  rhs = zeros(n);
  Constraints = [alpha>=0];
  for i = 1:n^2
    prod = U'*V(:, i);
    rhs =rhs+ alpha(i)*(prod * prod');
  end
  Constraints = [Constraints, X + (gamma-0)*eye(n) == rhs];
  %Constraints = [Constraints, X == rhs];

  for i =1:m
    Constraints = [Constraints, trace(X'*A{i}) == b(i)];
  end
  if true %iter == 1 || value(gamma) > 0
    Objective = gamma;
  else
    Objective = trace(X'*C);
  end
  option = sdpsettings('solver','mosek','verbose',0,'savesolveroutput',1);
  sol = optimize(Constraints,Objective, option);
  
  fprintf('iterations = %g, gamma = %3e \n', iter, value(gamma))
  %Xk = value(rhs) - value(gamma)*eye(n) + 1e-3*eye(n);
  Xk = value(X);
  
  if value(gamma) <= 0
    break
  end
  objs_LP = [objs_LP trace(value(Xk)'*C)];
  if length(objs_LP) >= 35
    break
  end
  [U, D] = eig(Xk+value(gamma)*eye(n));
  U = sqrt(abs(D))*U' ;
  %U = chol(Xk+value(gamma)*eye(n));
  assign(X,Xk);
  assign(gamma, value(gamma))
  assign(alpha, value(alpha))
end

[U, D] = eig(Xk);
U = sqrt(abs(D))*U' ;
fprintf("phase 2 \n")
alpha = sdpvar(n^2, 1);
X = sdpvar(n, n);
assign(X,Xk);
for iter = 1 : 100

  rhs = zeros(n);
  Constraints = [alpha>=0];
  for i = 1:n^2
    prod = U'*V(:, i);
    rhs =rhs+ alpha(i)*(prod * prod');
  end
  Constraints = [Constraints, X - 0*eye(n) == rhs];

  for i =1:m
    Constraints = [Constraints, trace(X'*A{i}) == b(i)];
  end
  Objective = trace(X'*C);

  option = sdpsettings('solver','mosek','verbose',0);
  
  sol = optimize(Constraints,Objective, option);
  
  fprintf('iterations = %g, obj = %3e \n', iter, trace(value(X)'*C))
  objs_LP = [objs_LP trace(value(X)'*C)];
  if length(objs_LP) >= 35
    break
  end
  %if norm(value(X) - Xk)/norm(Xk) <= 1e-3
    %break
  %end
  %Xk = value(rhs)+ 1e-3*eye(n);
  Xk = value(X);
  [U, D] = eig(Xk);
  U = sqrt(abs(D))*U' ;
  %U = chol(Xk);
  assign(X,Xk);
  assign(alpha, value(alpha))
end
consump_time = toc(tstart);

function plotBoundary(pts, varargin)
    % plot the boundary
    K = convhull(pts, 'Simplify', true);
    patch(pts(K, 1), pts(K, 2), varargin{:});
end