#########################
#                                                         #
#          Transshiping model                     #
#                                                         #
#########################
set P;                                   # Produce plants road-boats .
set W;                                   # Warehouse
set C;                                   # Custoners of road-boats.
set N:= P union W union C;               # Nodes

set A, within N cross N;                 # Network

param s{i in P};                         # Quantity raod-boats supply.
param d{j in C};                         # Quantity road-boats demand.
param c{(i,j) in A};                     # Cost of shipping of road-boats

var x{(i,j) in A} >= 0, integer;

minimize Z: sum{(i,j) in A} c[i,j]*x[i,j];

s.t. R1{i in P}: sum{j in C}x[i,j] <= s[i];

s.t. R2{k in W}: sum{i in P}x[i,k] - sum{j in C}x[k,j] = 0;

s.t. R3{j in C}: sum{i in P} x[i,j] >= d[j];


solve;
printf "Transport cost: %s\n", sum{(i,j) in A} c[i,j]*x[i,j];
printf "\n";
printf "Plants     Cities           Quantity \n";
for {i in P} {
   for {j in C} {
      printf " %3s %15s %15s\n",i,j, x[i,j];
   }
}


data;
set P:= 'LA' 'Detroit';             # Produce plants road-boats
set W:= 'Atlanta';                  # Warehouse
set C:= 'Houston' 'Tampa';          # Customers of road-boats

param s:=  'LA'       1100         #  Road-boats supply
           'Detroit'  2900;        # Road-boats  supply


param:         A:                    c     :=
       'LA'         'LA'          0
       'LA'	       'Detroit'     140
       'LA'	       'Atlanta'     100
	   'LA'	       'Houston'      90
       'LA'	       'Tampa'       225
       'Detroit'   'LA'          145
       'Detroit'   'Detroit'      0
       'Detroit'   'Atlanta'      111
       'Detroit'   'Houston'      110
       'Detroit'   'Tampa'        119
       'Atlanta'   'LA'           105
       'Atlanta'   'Detroit'      115
       'Atlanta'   'Atlanta'       0
       'Atlanta'   'Houston'      113
	   'Atlanta'   'Tampa'         78
       'Houston'   'LA'            89
       'Houston'   'Detroit'      109
       'Houston'    'Atlanta'     121
       'Houston'    'Houston'      0
       'Houston'    'Tampa'        10 #0  #.
	   'Tampa'      'LA'          210
	   'Tampa'      'Detroit'     117
	   'Tampa'      'Atlanta'      82
	   'Tampa'      'Houston'      0  #.
	   'Tampa'      'Tampa'        0;


param d:= 'Houston'  2400         # Receive road-boats
          'Tampa'    1500;        # Receive road-boats


end;
