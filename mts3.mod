
#MULTICOMODITY

set K;  #Commoditys

set O; #Origins
set D; #Destinations
set T; #Transshipment

set N:= O union D  union T; #Nodes
set A, within N cross N; #Arcs of Network

###########################################

set Ak, within A cross K; #Arcs of Network per commodity

###########################################

param oik{i in O, k in K}; #Supply per commodity
param dik{i in D, k in K}; #Demand per commodity

param ug{(i,j) in A}; #capacity per arc
param uk{(i,j) in A, k in K}; #capacity per arc (per commodity)

param c{(i,j) in A, k in K}; #cost per commodity (per arc)

###########################################

var x{(i,j) in A, k in K} >= 0, integer;

###########################################
###########################################

minimize Z: sum{(i,j) in A, k in K} c[i,j,k]*x[i,j,k];

s.t. R1{k in K, i in O}: sum{j in N}x[i,j,k] - sum{j in N}x[j,i,k] = oik[i,k];

s.t. R2{k in K, i in D}: sum{j in N}x[i,j,k] - sum{j in N}x[j,i,k] = -1*dik[i,k];

s.t. R3{k in K, i in T}: sum{j in N}x[i,j,k] - sum{j in N}x[j,i,k] = 0;

s.t. R4{(i,j) in A, k in K}: x[i,j,k] <= uk[i,j,k];

s.t. R5{(i,j) in A}: sum{k in K}x[i,j,k] <= ug[i,j];

s.t. R6{(i,j) in A, k in K}: x[i,j,k] >= 0;

solve;

###########################################
###########################################

for {k in K}{
  printf "Transport cost: %s\n", sum{(i,j) in A} c[i,j,k]*x[i,j,k];
  printf "\n";
  printf "Origins     Destinies           Quantity \n";
  for {i in N} {
     for {j in N} {
        printf " %3s %15s %15s\n",i,j, x[i,j,k];
     }
  }
  
}

###########################################
###########################################

data;

set K:= 'K_1', 'K_2';

set O:= 'O_1', 'O_2';
set D:= 'D_1', 'D_2', 'D_3';
set T:= 'T_1';
set A:= 
  ('O_1', 'O_1'),
  ('O_2', 'O_1'),
  ('T_1', 'O_1'),
  ('D_1', 'O_1'),
  ('D_2', 'O_1'),
  ('D_3', 'O_1'),
  ('O_1', 'O_2'),
  ('O_2', 'O_2'),
  ('T_1', 'O_2'),
  ('D_1', 'O_2'),
  ('D_2', 'O_2'),
  ('D_3', 'O_2'),
  ('O_1', 'T_1'),
  ('O_2', 'T_1'),
  ('T_1', 'T_1'),
  ('D_1', 'T_1'),
  ('D_2', 'T_1'),
  ('D_3', 'T_1'),
  ('O_1', 'D_1'),
  ('O_2', 'D_1'),
  ('T_1', 'D_1'),
  ('D_1', 'D_1'),
  ('D_2', 'D_1'),
  ('D_3', 'D_1'),
  ('O_1', 'D_2'),
  ('O_2', 'D_2'),
  ('T_1', 'D_2'),
  ('D_1', 'D_2'),
  ('D_2', 'D_2'),
  ('D_3', 'D_2'),
  ('O_1', 'D_3'),
  ('O_2', 'D_3'),
  ('T_1', 'D_3'),
  ('D_1', 'D_3'),
  ('D_2', 'D_3'),
  ('D_3', 'D_3');

param oik:  'K_1' 'K_2' :=
      'O_1'   10000    10000
      'O_2'   10000    10000;

param dik:  'K_1' 'K_2' :=
      'D_1'   500    500
      'D_2'   500    500
      'D_3'   500    500;

param ug :=
[*,*]: 'O_1' 'O_2' 'T_1' 'D_1' 'D_2' 'D_3' :=
'O_1'   0     0     1000   1000   1000   1000
'O_2'   0     0     1000   1000   1000   1000
'T_1'   1000   1000   0     1000   1000   1000
'D_1'   1000   1000   1000   0     0     0
'D_2'   1000   1000   1000   0     0     0
'D_3'   1000   1000   1000   0     0     0;

param uk :=
[*,*, K_1] : 'O_1'  'O_2' 'T_1' 'D_1' 'D_2' 'D_3' := 

    'O_1'     0     0     500    500    500    500
    'O_2'     0     0     500   500   500   500
    'T_1'     500   500   0     500    500    500
    'D_1'     500    500    500    0     0     0
    'D_2'     500   500   500   0     0     0
    'D_3'     500    500    500    0     0     0

[*,*, K_2] : 'O_1'  'O_2' 'T_1' 'D_1' 'D_2' 'D_3' := 

    'O_1'     0     0     500    500    500    500
    'O_2'     0     0     500   500   500   500
    'T_1'     500   500   0     500    500    500
    'D_1'     500    500    500    0     0     0
    'D_2'     500   500   500   0     0     0
    'D_3'     500    500    500    0     0     0;


param c :=
[*,*, K_1] : 'O_1'  'O_2' 'T_1' 'D_1' 'D_2' 'D_3' := 

    'O_1'    1   1  1    1    1    1   
    'O_2'    1   1  1    1    1    1   
    'T_1'    1     1    1  1    1    1   
    'D_1'    1     1    1    1  1  1    
    'D_2'    1     1    1    1  1  1   
    'D_3'    1     1    1    1  1  1    

[*,*, K_2] : 'O_1'  'O_2'   'T_1' 'D_1' 'D_2' 'D_3' := 

    'O_1'    1   1    1    1    1    1        
    'O_2'    1   1    1    1    1    1        
    'T_1'    1     1      1  1    1    1    
    'D_1'    1     1      1    1  1  1      
    'D_2'    1     1      1    1  1  1      
    'D_3'    1     1      1    1  1  1;

###########################################
###########################################

end;