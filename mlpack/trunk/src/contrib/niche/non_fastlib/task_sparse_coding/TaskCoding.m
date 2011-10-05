function [W, Z] = TaskCoding(X, Y, n_atoms, lambda_w, lambda_z, ...
			     W_initial, Z_initial, tol)
%function [W, Z] = TaskCoding(X, Y, n_atoms, lambda_w, lambda_z, ...
%			     W_initial, Z_initial, tol)
% X is tensor in R^{n_dims \times n_points \times n_tasks}
% Y is a matrix in R^{n_points \times n_tasks}
% n_atoms is the number of atoms in the dictionary of estimators
% lambda_w is the regularization term for the penalty on the SVM parameters
% lambda_z is the regularization term for l1-norm penalties on each Z_t
% tol is the tolerance within which the objective must have converged to stop the algorithm

[n_dims n_points n_tasks] = size(X);

if nargin < 6
  % a crude initialization of W
  W = normrnd(0, 1 , n_dims, n_atoms);
else
  fprintf('Using W_initial\n');
  W = W_initial;
end

if nargin == 7
  Z = Z_initial;
  fprintf('Running Pegasos\n');
  W = TaskCodingWStep(X, Y, Z, lambda_w);
  obj = TaskCodingObjective(X, Y, W, Z, lambda_w, lambda_z);
end

if nargin < 8
  tol = 1e-6;
end


last_obj = 1e99;
converged = false;
n_max_iterations = 50;
iteration_num = 0;
while ~converged && iteration_num < n_max_iterations
  iteration_num = iteration_num + 1;
  save LPSVM X Y W lambda_z;
  fprintf('Running LPSVM\n');
  Z = TaskCodingZStep(X, Y, W, lambda_z);
  obj = TaskCodingObjective(X, Y, W, Z, lambda_w, lambda_z);
  save Pegasos X Y Z lambda_w;
  fprintf('Running Pegasos\n');
  W = TaskCodingWStep(X, Y, Z, lambda_w);
  obj = TaskCodingObjective(X, Y, W, Z, lambda_w, lambda_z);
  
  %converged = (last_obj - obj) < tol;
  last_obj = obj;
end

% final coding step
Z = TaskCodingZStep(X, Y, W, lambda_z);