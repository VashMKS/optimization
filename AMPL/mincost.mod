param n >= 0, integer;
param m >= 0, integer;
set NODES := 1..n;
set ARCS := 1..m;
param capacity{ARCS};
param cost{ARCS};
param dif{NODES};
param A{NODES,ARCS};
var x{i in ARCS} >= 0, <= capacity[i];

minimize total_cost:
sum{i in ARCS} cost[i]*x[i];

s.t. kethnode{k in NODES}:
sum{i in ARCS} x[i]*A[k, i] = dif[k];