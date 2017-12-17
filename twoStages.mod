#Reverse Logistic

set I; #Plants
set J; #Distribution Centers
set K; #Customers

###########################################

param ai{i in I}; #capacity of plants I
param bj{j in J}; #capacity of distribution center J
param dk{k in K}; #demand of customer K

param tij{i in I, j in J}; #unit cost of transportation from plant i to distribution center j
param cjk{j in J, k in K}; #unit cost of transportation from distribution J to customer K
param gj{j in J}; #Fixed cost of operatin distribution center J

param W; #an upper limit on total number of DC that can be opened


###########################################

var xij{i in I, j in J}; #Amount of shipment from plant i to distribution centre j.
var yjk{j in J, k in K}; #Amount of shipment from distribution centre j to customer k.
var zj{j in J}; #Binary 1 if DC j is opened. Other case 0.

###########################################
###########################################

minimize Z: sum{i in I, j in J}tij[i,j]*xij[i,j] + sum{j in J, k in K}cjk[j,k]*yjk[j,k] + sum{j in J}gj[j]*zj[j];


s.t. R1{i in I}: sum{j in J}xij[i,j] <= ai[i];

s.t. R2{j in J}: sum{k in K}yjk[j,k] <= bj[j]*zj[j];

s.t. R3: sum{j in J}zj[j] <= W;

s.t. R5{k in K}: sum{j in J}yjk[j,k] >= dk[k];

s.t. R6{j in J}: sum{i in I}xij[i,j] = sum{k in K}yjk[j,k];

solve;

###########################################
###########################################

for {j in J}
{
  printf "DC used: %3s %5s", j, zj[j];
}

###########################################
###########################################

data;

set I:= 'I_1', 'I_2';
set J:= 'J_1', 'J_2', 'J_3';
set K:= 'K_1', 'K_2';


param: ai := #capacity of plants I
      'I_1' 1000
      'I_2' 2000;

param: bj := #capacity of distribution center J
      'J_1'   500
      'J_2'   500
      'J_3'   500;

param: dk := #demand of customer K
      'K_1' 500
      'K_2' 500;

param tij : 'J_1'  'J_2'  'J_3' := #unit cost of transportation from plant i to distribution center j
      'I_1'  500    500    500
      'I_2'  500    500    500;

param cjk : 'K_1'  'K_2' := #unit cost of transportation from distribution J to customer K
      'J_1' 500     500
      'J_2' 500     500
      'J_3' 500     500;

param: gj := #Fixed cost of operatin distribution center J
      'J_1' 500
      'J_2' 500
      'J_3' 500;

param W:= 3; #an upper limit on total number of DC that can be opened


###########################################
###########################################

end;
