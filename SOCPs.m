[C, A, b] = sdplib('sdplib/hinf1.dat-s');
n = size(C, 1);
m = size(A, 1);

X = sdpvar(n, n,'symmetric');

Constraints = [X>=0];
for i =1:m
  Constraints = [Constraints, trace(X'*A{i}) == b(i)];
end

Objective = trace(X'*C);
option = sdpsettings('solver','mosek','verbose',1);
tstart = tic;
sol = optimize(Constraints,Objective, option)
consump_time = toc(tstart);
ori_obj = trace(value(X)'*C)
  
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
lambda = sdpvar(2,2,n*(n-1)/2);
X = sdpvar(n, n);
gamma = sdpvar(1,1);

objs_SOCP = [];

for iter = 1 : 50

  rhs = zeros(n);
  Constraints = [];
  for i = 1: n*(n-1)/2
    prod = U'*V(:,:, i);
    rhs =rhs+ prod * lambda(:,:,i) * prod';
    Constraints = [Constraints lambda(:,:,i)>=0];
  end
  Constraints = [Constraints, X + gamma*eye(n) == rhs];
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
  tstart = tic;
  sol = optimize(Constraints,Objective, option);
  consump_time = toc(tstart);
  fprintf('iterations = %g, gamma = %3e \n', iter, value(gamma))
  Xk = value(X);
  if value(gamma) <= 0
    break
  end
  objs_SOCP = [objs_SOCP,  trace(Xk'*C)];
  [U, D] = ldl(Xk+value(gamma)*eye(n));
  U = sqrt(abs(D))*U' ;
  %U = chol(Xk+value(gamma)*eye(n));
  assign(X,Xk);
  assign(gamma, value(gamma))
  assign(lambda, value(lambda))
end

[U, D] = eig(Xk);
U = sqrt(abs(D))*U' ;
fprintf("phase 2")

assign(X,Xk);
for iter = 1 : 35

  rhs = zeros(n);
  Constraints = [];
  for i = 1: n*(n-1)/2
    prod = U'*V(:,:, i);
    rhs =rhs+ prod * lambda(:,:,i) * prod';
    Constraints = [Constraints lambda(:,:,i)>=0];
  end
  Constraints = [Constraints, X == rhs];

  for i =1:m
    Constraints = [Constraints, trace(X'*A{i}) == b(i)];
  end
  Objective = trace(X'*C);

  option = sdpsettings('solver','mosek','verbose',0);
  tstart = tic;
  sol = optimize(Constraints,Objective, option);
  consump_time = toc(tstart);
  
  fprintf('iterations = %g, obj = %3e \n', iter, trace(value(X)'*C))
  objs_SOCP = [objs_SOCP,  trace(Xk'*C)];
  if length(objs_SOCP) >= 35
    break
  end
  %if norm(value(X) - Xk)/norm(Xk) <= 1e-3
    %break
  %end
  Xk = value(X);
  [U, D] = eig(Xk);
  U = sqrt(abs(D))*U' ;
  %U = chol(Xk);
  assign(X,Xk);
  assign(lambda, value(lambda))
end
