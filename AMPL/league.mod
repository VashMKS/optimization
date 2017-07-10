param n >= 4, integer;
param s integer;
param r integer;

set TEAMS 	:= 1..n;
set NORTH   := 1..n/2;
set SOUTH   := n/2+1..n;
set ROUNDS  := 1..r*(n/2-1)+s*n/2;

var x {TEAMS,TEAMS,ROUNDS} binary;

#---------------------------------

maximize score: sum{(i,j,k) in {NORTH,NORTH,ROUNDS} : i<j} x[i,j,k]*2^(k-2) + sum{(i,j,k) in {SOUTH,SOUTH,ROUNDS} : i<j} x[i,j,k]*2^(k-2);

#---------------------------------

s.t. R_intra_south{(i,j) in {SOUTH,SOUTH} : i<>j}:
     sum{k in ROUNDS} x[i,j,k] = r;
     
s.t. R_intra_north{(i,j) in {NORTH,NORTH} : i<>j}:
     sum{k in ROUNDS} x[i,j,k] = r;

s.t. S_inter{(i,j) in {SOUTH,NORTH}}:
     sum{k in ROUNDS} x[i,j,k] = s;

s.t. No_repeat{(k,i) in {ROUNDS,TEAMS}}:
	 sum{j in TEAMS} x[i,j,k] = 1;
	 
s.t. Simetry{(i,j,k) in {TEAMS,TEAMS,ROUNDS} : i<j}:
     x[i,j,k] = x[j,i,k];