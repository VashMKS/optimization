param n;
param a;
param b;
set N = 0..n;
# Discretització
param y {i in N} := b*(i/n);
# param y {i in N} := b*(i/n)^2;
# param y {i in N} := b*(i/n)^4;
var x {i in N} >= 10^(-12);

# Funció objectiu
minimize time:
	sum {k in 1..n} sqrt(((x[k]-x[k-1])^2 + (y[k]-y[k-1])^2)/y[k]);

# Restriccions
subject to
	start: x[0] = 10^(-12);
subject to
	end: x[n] = a;
