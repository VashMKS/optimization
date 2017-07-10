param n;
param a;
param b;
set N = 0..n;
# Discretització
param x {i in N} := a*(i/n);
# param x {i in N} := a*(i/n)^2;
# param x {i in N} := a*(i/n)^4;
var y {i in N} >= 10^(-12);

# Funció objectiu
minimize time:
	sum {k in 1..n} sqrt(((x[k]-x[k-1])^2 + (y[k]-y[k-1])^2)/y[k-1]);
	
# Restriccions
subject to
	start: y[0] = 10^-12;
subject to
	end: y[n] = b;

