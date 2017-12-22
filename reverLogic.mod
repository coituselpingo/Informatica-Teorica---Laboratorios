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


param sLm{m in M}; #Limite de oferta por suplidor


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
            sum{j in J, k in K, m in M}cjkm[j,k,m]*xjkm[j,k,m] - sum{j in J, m in M}cjRm[j,m]*xjRm[j,m] +
						sum{k in K, m in M}ckFm[k,m]*xkFm[k,m] - sum{k in K, m in M}ckRm[k,m]*xkRm[k,m] +
						sum{k in K, m in M}ckDm[k,m]*xkDm[k,m] + sum{m in M}cSFm[m]*ySFm[m];



s.t. R1{i in I, p in P}: sum{j in J}xijp[i,j,p] + sum{k in K}xikp[i,k,p] <= aip[i,p];

s.t. R2{j in J, p in P, m in M}: (sum{k in K}xjkm[j,k,m]) + xjRm[j,m] <= bjm[j,m]*zjp[j,p];

s.t. R3{m in M, k in K}: xkFm[k,m] + xkRm[k,m] + xkDm[k,m] <= ukm[k,m]*wkm[k,m];

s.t. R4{p in P}: sum{j in J}zjp[j,p] <= nj;

s.t. R5{m in M}: sum{k in K}wkm[k,m] <= nk;

s.t. R6{m in M}: ySFm[m] + sum{k in K}xkFm[k,m] >= dm[m];


s.t. R7{m in M}: ySFm[m] <= sLm[m];


solve;

###########################################

printf "\n\n\n";

printf "\nCantidad Enviada a (Centr. de Desamblaje/Centr. de Procesamiento)\n";

for{i in I}
{
	printf "\nCentro de Recogida\t %s", i;
	for{p in P}
	{
		printf "\n\tProducto\t %s", p;
		for {j in J}
		{
			printf "\n\t\tCentr. de Desamblaje %s \t Cantidad %s \t Costo Unidad %s", j, xijp[i,j,p], cijp[i,j,p];
			printf "\n\t\t\t Costo Total %s", xijp[i,j,p]*cijp[i,j,p];
			printf "\n\t\t\t-*-*-\n";
		}

		printf "\n\t\t#*#*#\n";
		for {k in K}
		{
			printf "\n\t\tCentr. de Procesamiento %s \t Cantidad %s \t Costo Unidad %s", k, xikp[i,k,p], cikp[i,k,p];
			printf "\n\t\t\t Costo Total %s", xikp[i,k,p]*cikp[i,k,p];
			printf "\n\t\t\t-*-*-\n";
		}
	}
}

for{j in J}
{
	printf "\nCentro de Desamblaje\t %s", j;
	for{k in K}
	{
		printf "\n\tCentro de Procesamiento\t %s", k;
		for {m in M}
		{
			printf "\n\t\tParte %s \t Cantidad %s \t Costo Unidad %s", m, xjkm[j,k,m], cjkm[j,k,m];
			printf "\n\t\t\t Costo Total %s", xjkm[j,k,m]*cjkm[j,k,m];
			printf "\n\t\t\t-*-*-\n";
		}
	}
}


for{j in J}
{
	printf "\nCentro de Desamblaje\t %s", j;
	for{m in M}
	{
		printf "\n\tParte\t %s", m;
		printf "\n\t\tCantidad Enviada al Basurero\t %s", xjDm[j,m];
		printf "\n\t\tCantidad Enviada a Reciclaje\t %s", xjRm[j,m];
	}
	printf "\n\n";
}

for{j in J}
{
	printf "\nCentro de Desamblaje\t %s", j;
	for{m in M}
	{
		printf "\n\tParte\t %s", m;
		printf "\n\t\tCantidad Enviada al Basurero\t %s", xjDm[j,m];
		printf "\n\t\tCantidad Enviada a Reciclaje\t %s", xjRm[j,m];
	}
	printf "\n\n";
}

for{k in K}
{
	printf "\nCentro de Procesamiento\t %s", k;
	for{m in M}
	{
		printf "\n\tParte\t %s", m;
		printf "\n\t\tCantidad Enviada al Basurero\t %s", xkDm[k,m];
		printf "\n\t\tCantidad Enviada a Reciclaje\t %s", xkRm[k,m];
		printf "\n\t\tCantidad Enviada a Fabrica\t %s", xkFm[k,m];
	}
	printf "\n\n";
}


for{m in M}
{
		printf "\nCantidad de partes %s enviada desde el Suplidor al Manufacturador:\t %s", m, ySFm[m];
}


for{j in J}
{
	printf "\n\nCentro de Desamblaje %s", j;
	for{p in P}
	{
		printf "\n\tProducto %s , Estado %s \t\t[1, activo][0, no activo]", p, zjp[j,p];
	}
}

for{k in K}
{
	printf "\n\nCentro de Procesamiento %s", k;
	for{m in M}
	{
		printf "\n\tParte %s , Estado %s \t\t[1, activo][0, no activo]", m, wkm[k,m];
	}
}


printf "\n\n\n";

printf "COSTO TOTAL MINIMIZADO\t %s", Z;

printf "\n\n\n";

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
      'I_1' 10000
      'I_2' 20000;

param bjm: 'M_1'  'M_2'  'M_3':= #capacity of disassembly center j for part m
    'J_1'   800    800    800
    'J_2'   1200   1200   1200
    'J_3'   1500    1500    1500;

param ukm: 'M_1'  'M_2'  'M_3':= #capacity of processing center k for part m
      'K_1' 1600    1600    1600
      'K_2' 1400    1400    1400;

param ur:= 10000; #capacity of recycling

param: dm := #Demand of part m in manufacturer F
'M_1' 3000
'M_2' 3000
'M_3' 3000;

param: sLm := #Limite de Oferta por Surtidor
'M_1' 500
'M_2' 500
'M_3' 500;

param: nm :=  #number of part for the type m from disassembling one unit of product
'M_1' 10
'M_2' 8
'M_3' 2;

param cijp :=  #unit cost of shipping from returning center i to disassembly j for product p
[*,*,'P_1']: 'J_1'  'J_2'  'J_3' :=
'I_1'        20    20    20
'I_2'        20    20    20;

param cikp := #Unit cost of shipping from returning center i to processing center k for product p
[*,*,'P_1']: 'K_1'  'K_2' :=
'I_1'        15    15
'I_2'        15    15;

param cjkm := #Unit cost of shipping from disassembly center j to processing center k for part m
[*,*,'M_1']: 'K_1'  'K_2' :=
'J_1'        10    10
'J_2'        10    10
'J_3'        10    10

[*,*,'M_2']: 'K_1'  'K_2' :=
'J_1'        18    18
'J_2'        18    18
'J_3'        18    18

[*,*,'M_3']: 'K_1'  'K_2' :=
'J_1'        25    25
'J_2'        25    25
'J_3'        25    25;

param cjRm : 'M_1'  'M_2'  'M_3' := #Unit cost of shipping from disassembly center j to recycling R for part m
        'J_1' 5    5      5
        'J_2' 5    5      5
        'J_3' 5    5      5;

param ckFm : 'M_1'  'M_2'  'M_3' :=  #Unit cost of shipping from processing center k to manufacturer F for part m
        'K_1' 16    16     16
        'K_2' 16    16     16;


param ckRm : 'M_1'  'M_2'  'M_3' := #Unit cost of shipping from processing center k to recycling R for part m
        'K_1' 8    8     8
        'K_2' 8    8     8;

param ckDm : 'M_1'  'M_2'  'M_3' := #Unit cost of shipping from processing center k to disposal D for part m
        'K_1' 4    4     4
        'K_2' 4    4     4;

param cSFm := #Unit cost of shipping from supplier S to manufacturer F for part m
        'M_1' 30
        'M_2' 30
        'M_3' 30;

param codjp: 'P_1' := #The fixed opening cost for disassembly center j for product p op
    'J_1'     1000
    'J_2'     1000
    'J_3'     1000;

param copkm: 'M_1'  'M_2'  'M_3' := #The fixed opening cost for processing center k for part m
    'K_1'     400   200    400
    'K_2'     200   400    200;

###########################################
###########################################

end;
