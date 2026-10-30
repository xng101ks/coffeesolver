% coffeesolve.m - Generalized Campus Coffee Balance Liquidation Solver
clear; clc;

fprintf('==============================================\n');
fprintf('  coffeesolve: Academic Balance Liquidator    \n');
fprintf('==============================================\n\n');

% 1. Get remaining balance from user
balance_eur = input('Enter your remaining account balance in EUR (e.g., 10.40): ');
balance_cents = round(balance_eur * 100);

% 2. Get number of available products
n = input('How many products are available to choose from? ');
while n < 1 || floor(n) ~= n
    fprintf('Please enter a valid positive integer.\n');
    n = input('How many products are available to choose from? ');
end

names = cell(n, 1);
prices_cents = zeros(n, 1);

% 3. Collect product details
fprintf('\n--- Enter Product Details ---\n');
for i = 1:n
    fprintf('Product #%d:\n', i);
    names{i} = strtrim(input('  Name: ', 's'));
    price_eur = input('  Price in EUR (e.g., 0.60): ');
    prices_cents(i) = round(price_eur * 100);
end

% 4. Select which product to prioritize/maximize
fprintf('\nWhich product do you want to maximize?\n');
for i = 1:n
    fprintf('  [%d] %s (€%.2f)\n', i, names{i}, prices_cents(i) / 100);
end
target_idx = input(sprintf('Select product index [1-%d]: ', n));
while target_idx < 1 || target_idx > n || floor(target_idx) ~= target_idx
    fprintf('Invalid selection.\n');
    target_idx = input(sprintf('Select product index [1-%d]: ', n));
end

% 5. Formulate MILP Problem
% Objective: Maximize x(target_idx)  <=>  Minimize -x(target_idx)
f = zeros(n, 1);
f(target_idx) = -1;

% All decision variables must be integers
intcon = 1:n;

% Equality constraint: sum(price_i * x_i) == balance_cents
Aeq = prices_cents';
beq = balance_cents;

% Lower bounds: cannot order negative coffees
lb = zeros(n, 1);

% Solver settings
options = optimoptions('intlinprog', 'Display', 'off');

% 6. Solve
[x, fval, exitflag, ~] = intlinprog(f, intcon, [], [], Aeq, beq, lb, [], options);

% 7. Output Results
fprintf('\n==============================================\n');
if exitflag > 0
    fprintf('Optimal Liquidation Plan Found!\n');
    fprintf('==============================================\n');
    total_spent = 0;
    
    for i = 1:n
        qty = round(x(i));
        cost = (qty * prices_cents(i)) / 100;
        total_spent = total_spent + cost;
        if qty > 0
            fprintf('  • %-20s : %2d units  (€%6.2f)\n', names{i}, qty, cost);
        end
    end
    
    fprintf('----------------------------------------------\n');
    fprintf('Total Spent       : €%.2f\n', total_spent);
    fprintf('Remaining Balance : €%.2f\n', (balance_cents - round(total_spent * 100)) / 100);
    fprintf('==============================================\n');
else
    fprintf('No exact combination can spend down to €0.00.\n');
    fprintf('Try checking if there is a 10c or 20c snack item available!\n');
    fprintf('==============================================\n');
end