% Objective: minimize f' * x where x = [x_A; x_B]
% Maximize x_B  <=>  Minimize 0*x_A - 1*x_B
f = [0; -1];

% Integer constraints: both variables must be integers
intcon = [1, 2];

% Equality constraint: 50*x_A + 60*x_B = 1000
Aeq = [50, 60];
beq = 1000;

% Lower bounds (cannot buy negative quantities)
lb = [0; 0];

% Solve using intlinprog
options = optimoptions('intlinprog', 'Display', 'off');
[x, fval, exitflag, output] = intlinprog(f, intcon, [], [], Aeq, beq, lb, [], options);

if exitflag > 0
    fprintf('Optimal Solution Found:\n');
    fprintf('Product A: %d units (Cost: €%.2f)\n', round(x(1)), round(x(1)) * 0.50);
    fprintf('Product B: %d units (Cost: €%.2f)\n', round(x(2)), round(x(2)) * 0.60);
    fprintf('Total spent: €%.2f\n', round(x(1)) * 0.50 + round(x(2)) * 0.60);
else
    fprintf('No feasible integer solution found.\n');
end