#Reverse Logistic

set I; #return centers
set J; #disassembly centers
set K; #processing centers

set P; #products
set M; #parts



###########################################

param nj; #number of elementes in J
param nk; #number of elements in K

param aip{i in I, p in P}; #capacity of returning center i  for producto p
param bjm{j in J, m in M}; #capacity of disassembly center j for part m
param ukm{k in K, m in M}; #capacity of processing center k for part m

param ur; #capacity of recycling
param dm{m in M}; #Demand of part m in manufacturer F
param nm{m in M}; #number of part for the type m from disassembling one unit of product

param cijp{i in I, j in J, p in P}; #unit cost of shipping from returning center i to disassembly j for product p
param cikp{i in I, k in K, p in P}; #Unit cost of shipping from returning center i to processing center k for product p
param cjkm{j in J, k in K, m in M}; #Unit cost of shipping from disassembly center j to processing center k for part m

param cjRm{j in J, m in M}; #Unit cost of shipping from disassembly center j to recycling R for part m

param ckFm{k in K, m in M}; #Unit cost of shipping from processing center k to manufacturer F for part m
param ckRm{k in K, m in M}; #Unit cost of shipping from processing center k to recycling R for part m
param ckDm{k in K, m in M}; #Unit cost of shipping from processing center k to disposal D for part m

param cSFm{m in M}; #Unit cost of shipping from supplier S to manufacturer F for part m

param codjp{j in J, p in P}; #The fixed opening cost for disassembly center j for product p op
param copkm{k in K, m in M}; #The fixed opening cost for processing center k for part m

###########################################

var xijp{i in I, j in J, p in P} >= 0, integer; #Amount shipped from returning center i to disassembly center j for product p
var xikp{i in I, k in K, p in P} >= 0, integer; #Amount shipped from returning center i to processing center k for product p
var xjkm{j in J, k in K, m in M} >= 0, integer; #Amount shipped from disassembly center j to processing center k for part m

var xjDm{j in J, m in M} >= 0, integer; #Amount shipped from disassembly center j to disposal D for part m
var xjRm{j in J, m in M} >= 0, integer; #Amount shipped from disassembly center j to recycling R for part m

var xkFm{k in K, m in M} >= 0, integer; #Amount shipped from processing center k to manufacturer F for part m
var xkRm{k in K, m in M} >= 0, integer; #Amount shipped from processing center k to recycling R for part m
var xkDm{k in K, m in M} >= 0, integer; #Amount shipped from processing center k to disposal D for part m

var ySFm{m in M} >= 0, integer; #Amount shipped from supplier S to manufacturer F for part m

var zjp{j in J, p in P}, binary; #1 if disassembly center j is open; 0, otherwise.
var wkm{k in K, m in M}, binary; #1 if processing center k is open; 0, otherwise.


###########################################
###########################################

minimize Z: sum{j in J, p in P}codjp[j,p]*zjp[j,p] + sum{k in K, m in M}copkm[k,m]*wkm[k,m] +
            sum{i in I, j in J, p in P}cijp[i,j,p]*xijp[i,j,p] + sum{i in I, k in K, p in P}cikp[i,k,p]*xikp[i,k,p] +
            sum{j in J, k in K, m in M}cjkm[j,k,m]*xjkm[j,k,m] - sum{j in J, m in M}cjRm[j,m]*xjRm[j,m] + sum{k in K, m in M}ckFm[k,m]*xkFm[k,m] -
            sum{k in K, m in M}ckRm[k,m]*xkRm[k,m] + sum{k in K, m in M}ckDm[k,m]*xkDm[k,m] + sum{m in M}cSFm[m]*ySFm[m];



s.t. R1{i in I, p in P}: sum{j in J}xijp[i,j,p] + sum{k in K}xikp[i,k,p] <= aip[i,p];

s.t. R2{j in J, p in P, m in M}: sum {k in K}xjkm[j,k,m] + xjRm[j,m] <= bjm[j,m]*zjp[j,p];

s.t. R3{m in M}: sum{k in K}(xkFm[k,m] + xkRm[k,m] + xkDm[k,m]) <= sum{k in K}ukm[k,m]*wkm[k,m];

s.t. R4{p in P}: sum{j in J}zjp[j,p] <= nj;

s.t. R5{m in M}: sum{k in K}wkm[k,m] <= nk;

s.t. R6{m in M}: ySFm[m] + sum{k in K}xkFm[k,m] >= dm[m];

solve;

###########################################
###########################################


###########################################
###########################################

data;

set P:= 'P_1';
set M:= 'M_1', 'M_2', 'M_3';

set I:= 'I_1', 'I_2';
set J:= 'J_1', 'J_2', 'J_3';
set K:= 'K_1', 'K_2';


param nj:= 3; #number of elementes in J
param nk:= 2; #number of elements in K

param aip: 'P_1':= #capacity of returning center i  for producto p
      'I_1' 1000
      'I_2' 2000;

param bjm: 'M_1'  'M_2'  'M_3':= #capacity of disassembly center j for part m
    'J_1'   500    500    500
    'J_2'   500    500    500
    'J_3'   500    500    500;

param ukm: 'M_1'  'M_2'  'M_3':= #capacity of processing center k for part m
      'K_1' 500    500    500
      'K_2' 500    500    500;

param ur:= 10000; #capacity of recycling
param: dm := #Demand of part m in manufacturer F
'M_1' 500
'M_2' 500
'M_3' 500;
param: nm :=  #number of part for the type m from disassembling one unit of product
'M_1' 10
'M_2' 8
'M_3' 2;

param cijp :=  #unit cost of shipping from returning center i to disassembly j for product p
[*,*,'P_1']: 'J_1'  'J_2'  'J_3' :=
'I_1'        500    500    500
'I_2'        500    500    500;

param cikp := #Unit cost of shipping from returning center i to processing center k for product p
[*,*,'P_1']: 'K_1'  'K_2' :=
'I_1'        500    500
'I_2'        500    500;

param cjkm := #Unit cost of shipping from disassembly center j to processing center k for part m
[*,*,'M_1']: 'K_1'  'K_2' :=
'J_1'        500    500
'J_2'        500    500
'J_3'        500    500

[*,*,'M_2']: 'K_1'  'K_2' :=
'J_1'        500    500
'J_2'        500    500
'J_3'        500    500

[*,*,'M_3']: 'K_1'  'K_2' :=
'J_1'        500    500
'J_2'        500    500
'J_3'        500    500;

param cjRm : 'M_1'  'M_2'  'M_3' := #Unit cost of shipping from disassembly center j to recycling R for part m
        'J_1' 10    10      10
        'J_2' 10    10      10
        'J_3' 10    10      10;

param ckFm : 'M_1'  'M_2'  'M_3' :=  #Unit cost of shipping from processing center k to manufacturer F for part m
        'K_1' 10    10     10
        'K_2' 10    10     10;


param ckRm : 'M_1'  'M_2'  'M_3' := #Unit cost of shipping from processing center k to recycling R for part m
        'K_1' 10    10     10
        'K_2' 10    10     10;

param ckDm : 'M_1'  'M_2'  'M_3' := #Unit cost of shipping from processing center k to disposal D for part m
        'K_1' 10    10     10
        'K_2' 10    10     10;

param cSFm := #Unit cost of shipping from supplier S to manufacturer F for part m
        'M_1' 10
        'M_2' 10
        'M_3' 10;

param codjp: 'P_1' := #The fixed opening cost for disassembly center j for product p op
    'J_1'     500
    'J_2'     500
    'J_3'     500;

param copkm: 'M_1'  'M_2'  'M_3' := #The fixed opening cost for processing center k for part m
    'K_1'     500   500    500
    'K_2'     500   500    500;

###########################################
###########################################

end;
