# coffeesolve ☕📉

> **An over-engineered Mixed-Integer Linear Programming (MILP) approach to academic caffeine liquidation.**

### The Problem

As an Erasmus Mundus Master’s student, moving across universities and countries every few months comes with a very specific, recurring financial nuisance: **campus coffee machine apps**.

Every new campus insists on a proprietary vending ecosystem where you are forced to top up an arbitrary prepaid balance upfront. The catch? You have to drain that balance before relocating to your next mobility semester. If you don't plan your orders carefully, you inevitably end up with €0.30 or €0.40 stranded in a localized payment wallet—money you can neither retrieve nor spend, effectively donating your student savings to a vending machine vendor you will never see again.

Mental math is prone to errors, and leaving unspent credit behind feels like an engineering defeat.

### The Solution

Enter **`coffeesolve`**.

Instead of guessing your way through your final days of the semester, `coffeesolve` models your remaining balance as a constrained **Diophantine optimization problem** solved via MATLAB’s `intlinprog`. It dynamically takes your balance and campus offerings, computing the exact combination of beverages to consume so that:

1. **Target Liquidated:** Your account balance hits strictly **€0.00**.
2. **Preference Maximized:** You buy as much of your primary beverage of choice (e.g., standard espresso/cappuccino) as mathematically possible.
3. **Budget Exhausted:** Secondary items are ordered strictly in the exact integer quantities required to bridge the remaining fractional gap.

### Mathematical Model

Given an account balance $B$ (in cents), a choice of $n$ available items with prices $p \in \mathbb{Z}^n$ (in cents), and a selected favorite item index $k \in \{1, \dots, n\}$:

$$
\begin{aligned} 
\min_{x} \quad & -x_k \\ 
\text{s.t.} \quad & \sum_{i=1}^{n} p_i x_i = B \\ 
& x_i \ge 0, \quad x_i \in \mathbb{Z} \quad \forall i \in \{1, \dots, n\}
\end{aligned}
$$

### How to Use

1. Clone the repository and navigate into the folder:
   ```bash
   git clone https://github.com/your-username/coffeesolve.git
   cd coffeesolve
   ```

2. Run the script in MATLAB:
   ```matlab
   coffeesolve
   ```

3. Follow the interactive terminal prompts:
   * Enter your remaining account balance in EUR.
   * Enter the number of available products at your machine.
   * Provide the label and price for each item.
   * Pick which drink you actually want to drink the most of.

### Interactive Terminal Run Example

```text
==============================================
  coffeesolve: Academic Balance Liquidator    
==============================================

Enter your remaining account balance in EUR (e.g., 10.40): 10.00
How many products are available to choose from? 2

--- Enter Product Details ---
Product #1:
  Name: good coffee
  Price in EUR (e.g., 0.60): 0.60
Product #2:
  Name: bad coffee
  Price in EUR (e.g., 0.60): 0.50

Which product do you want to maximize?
  [1] good coffee (€0.60)
  [2] bad coffee (€0.50)
Select product index [1-2]: 1

==============================================
Optimal Liquidation Plan Found!
==============================================
  • good coffee          : 15 units  (€  9.00)
  • bad coffee           :  2 units  (€  1.00)
----------------------------------------------
Total Spent       : €10.00
Remaining Balance : €0.00
==============================================
```

### License

MIT. Free to use for every exchange student trying not to leave their deposit behind.