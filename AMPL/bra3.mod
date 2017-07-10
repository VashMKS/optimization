param n;
param a;
param b;
set N = 0..n;
var x {i in N} >= 10^(-12);
var y {i in N} >= 10^(-12);

# Funció objectiu
minimize integral:
	sum {k in 1..n} sqrt(((x[k]-x[k-1])^2 + (y[k]-y[k-1])^2)/y[k-1]);

# Restriccions
subject to
	start_x: x[0] = 10^-12;
subject to
	start_y: y[0] = 10^-12;
subject to
	end_x: x[n] = a;
subject to
	end_y: y[n] = b;
subject to
	space_x{i in 1..n}: x[i] >= x[i-1] + 1/(10*n);
subject to
	space_y{i in 1..n}: y[i] >= y[i-1] + 1/(10*n);