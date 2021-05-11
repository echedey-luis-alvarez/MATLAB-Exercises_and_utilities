% Autor: Echedey Luis Álvarez
% Fecha: 11/05/2021
% 
% Tests para: Fórmula del Trapecio Compuesta y Fórmula de Simpson Compuesta

% Clear workspace and screen, set up format configuration
clear, clc;
format long g;

% Runtime config variables
nodes = 1e4;
calculate_single_node_number = true;
  % True: calculates just with the given number of nodes (recommended)
  % False: calculates for nodes = 2:[1 or 2]:nodes (not recommended, uses up too much memory)
show_sols = false;
  % Lets you fprintflay all calculated aproximations (not recommended, used for debugging)

% Función a integrar
f = @(x) 1 ./ (1 + x .^ 2);
% Extremos integración
a = 3; b = 7;
% Cuyo valor exacto es F = arctan(x), la evaluamos entre 3 y 7
true_value = atan(b) - atan(a);
% Por tanto los métodos deben converger a true_value = 0.1798534997924783

% Runtime variable alocation
best_trapezium = 0;
best_simpson = 0;

if (~calculate_single_node_number)
  sols_trapezium = NaN(nodes-1, 2);
  sols_simpson = NaN(nodes/2-1, 2);
end

% Show config
fprintf("Calculating integral of:\n");
disp(f);
fprintf("Evaluated between %G and %G\n\n", a, b);

% Checks and user-proofing
if ( nodes < 2 )
  error("Nodes must be greater or equal than 3");
end

% Trapezium
fprintf("Trapezium: start of calculations");
if (calculate_single_node_number)
  x = linspace(a, b, nodes);
  y = f(x);

  best_trapezium = formula_trapezium_composite(x(2) - x(1), y);
  
else
  for i = 2:nodes
    
    x = linspace(a, b, i);
    y = f(x);

    valor = formula_trapezium_composite(x(2) - x(1), y);
    
    sols_trapezium(i-1, :) = [i, valor];
    
    if (show_sols)
      fprintf(sols_trapezium);
    end

  end % !for
  best_trapezium = sols_trapezium(end);
end % !if
fprintf("Trapezium with %G nodes: %G\n", nodes, best_trapezium);
fprintf("Trapezium: end of calculations");

% Simpson
fprintf("Simpson: start of calculations");
if (calculate_single_node_number)
  nodes_simpson = nodes - mod(nodes, 2);
  if (mod(nodes, 2) ~= 0)
    fprintf("Warning: not using a multiple-of-2 number of nodes, now using %G nodes to execute Simpson properly", nodes_simpson );
  end
  
  x = linspace(a, b, nodes_simpson);
  y = f(x);

  best_simpson = formula_simpson_composite(x(2) - x(1), y);

else
  for i = 2:nodes/2
    
    x = linspace(a, b, i*2);
    y = f(x);

    valor = formula_simpson_composite(x(2) - x(1), y);
    
    sols_simpson(i-1, :) = [i*2, valor];
    
    if (show_sols)
      fprintf(sols_simpson);
    end

  end % !for
  best_simpson = sols_simpson(end);
end % !if
fprintf("Simpson with %G nodes: %G\n", nodes_simpson, best_simpson);
fprintf("Simpson: end of calculations");


% Show errors
fprintf("\nErrors:\n");
fprintf("Err(Trapezium) = %G [%G nodes]\n", true_value - best_trapezium, nodes);
fprintf("Err(Simpson) = %G [%G nodes]\n", true_value - best_simpson, nodes_simpson);

% Errors (with 1E+04 nodes):
% Err(Trapezium) = -7.25529E-10
% Err(Simpson) = 8.00155E-06

% Errors (with 1E+05 nodes):
% Err(Trapezium) = -6.56952E-12
% Err(Simpson) = 8.00016E-07

% Errors (with 1E+07 nodes):
% Err(Trapezium) = -9.06071E-11
% Err(Simpson) = 7.90936E-09

% Hay veces en las que la vida te sorprende;
% pero que la fórmula del trapecio funcione mejor que la de Simpson es otra cosa
