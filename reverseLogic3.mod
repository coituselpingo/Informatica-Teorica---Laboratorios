#Reverse Logistic

set I; #return centers
set J; #disassembly centers
set K; #processing centers

set M; #refurbished centers

set R; #recycling centers
set S; #supplier centers
set D; #disposal centers


###########################################
param nj; #number of elementes in J
param nk; #number of elements in K

param aip{i in I}; #capacity of returning center i
param bjm{j in J}; #capacity of disassembly center j
param ukm{k in K}; #capacity of processing center k

param dm{m in M}; #capacity of refurbished center m

param ur{r in R}; #capacity of recycling
param us{s in S}; #capacity of supplier
param ud{d in D}; #capacity of disposal

param cijp{i in I, j in J}; #unit cost of shipping from returning center i to disassembly j
param cikp{i in I, k in K}; #Unit cost of shipping from returning center i to processing center k
param cjkm{j in J, k in K}; #Unit cost of shipping from disassembly center j to processing center k

param cjRm{j in J, r in R}; #Unit cost of shipping from disassembly center j to recycling r

param ckFm{k in K, m in M}; #Unit cost of shipping from processing center k to refurbished m
param ckRm{k in K, r in R}; #Unit cost of shipping from processing center k to recycling r
param ckDm{k in K, d in D}; #Unit cost of shipping from processing center k to disposal d

param cSFm{s in S,m in M}; #Unit cost of shipping from supplier s to refurbished m

param codjp{j in J}; #The fixed opening cost for disassembly center j
param copkm{k in K}; #The fixed opening cost for processing center k

###########################################

var xijp{i in I, j in J} >= 0, integer; #Amount shipped from returning center i to disassembly center j
var xikp{i in I, k in K} >= 0, integer; #Amount shipped from returning center i to processing center k
var xjkm{j in J, k in K} >= 0, integer; #Amount shipped from disassembly center j to processing center k

var xjDm{j in J,d in D} >= 0, integer; #Amount shipped from disassembly center j to disposal d
var xjRm{j in J, r in R} >= 0, integer; #Amount shipped from disassembly center j to recycling r

var xkFm{k in K, m in M} >= 0, integer; #Amount shipped from processing center k to refurbished m
var xkRm{k in K, r in R} >= 0, integer; #Amount shipped from processing center k to recycling r
var xkDm{k in K, d in D} >= 0, integer; #Amount shipped from processing center k to disposal d

var ySFm{s in S, m in M} >= 0, integer; #Amount shipped from supplier s to refurbished m

var zjp{j in J}, binary; #1 if disassembly center j is open; 0, otherwise.
var wkm{k in K}, binary; #1 if processing center k is open; 0, otherwise.


###########################################
###########################################

minimize Z :
	sum{j in J}codjp[j]*zjp[j] + #Fix Cost by Open disassembly center
	sum{k in K}copkm[k]*wkm[k] + #Fix Cost by Open processing center
	sum{i in I, j in J}cijp[i,j]*xijp[i,j] + #Cost for transport between return centers and disassembly centers
	sum{i in I, k in K}cikp[i,k]*xikp[i,k] + #Cost for transport between return centers and processing centers
	sum{j in J, k in K}cjkm[j,k]*xjkm[j,k] - #Cost for transport between disassembly centers and processing centers
	sum{j in J, r in R}cjRm[j,r]*xjRm[j,r] + #Cost (inverse) for transport between disassembly centers and Recycling centers
	sum{k in K, m in M}ckFm[k,m]*xkFm[k,m] - #Cost for transport between processing centers and refurbished centers
	sum{k in K, r in R}ckRm[k,r]*xkRm[k,r] + #Cost (inverse) for transport between processing centers and Recycling centers
	sum{k in K, d in D}ckDm[k,d]*xkDm[k,d] + #Cost for transport between processing centers and disposal centers
	sum{s in S, m in M}cSFm[s,m]*ySFm[s,m]; #Cost for transport between supplier centers and refurbished centers



s.t. R1{i in I}: sum{j in J} xijp[i,j] + sum{k in K} xikp[i,k] >= aip[i]; #

s.t. R2{j in J}: sum{k in K} xjkm[j,k] + sum{r in R} xjRm[j,r] <= bjm[j]*zjp[j];

s.t. R3{k in K}: sum{m in M}xkFm[k,m] + sum{r in R}xkRm[k,r] + sum{d in D}xkDm[k,d] <= ukm[k]*wkm[k]; #only for one product with one piece

s.t. R4{j in J}: sum{i in I}xijp[i,j] = sum{k in K}xjkm[j,k] + sum{r in R}xjRm[j,r] ;

s.t. R5{k in K}: sum{i in I}xikp[i,k] + sum{j in J}xjkm[j,k] = sum{m in M}xkFm[k,m] + sum{r in R}xkRm[k,r] + sum{d in D}xkDm[k,d] ;

s.t. R6{j in J}: zjp[j]<= nj;

s.t. R7{k in K}: wkm[k]<= nk ;

s.t. R8{r in R}: sum{j in J}xjRm[j,r] + sum{k in K}xkRm[k,r] <= ur[r];

s.t. R9{d in D}: sum{k in K}xkDm[k,d] <= ud[d];

s.t. R10{m in M}: sum{s in S}ySFm[s,m] + sum{k in K}xkFm[k,m] >= dm[m];

solve;

###########################################

printf "\n\n\n";
printf "RECICLAJE DE MICROPROCESADORES ATHLOM";

printf "\n\n*~*~*~*\n\n";
printf '\n\n';

printf 'Costo Total Centros de Retorno - Centros de Desensamblaje:\t %s\n', sum{i in I, j in J}cijp[i,j]*xijp[i,j];
printf '\n\n#-#-#-# \n\n';

for {i in I} {
	printf "\nCentro de Retorno :\t %s", i;
	for {j in J} {
		printf "\n\tCentro de Desensamblaje :\t %s", j;
		printf "\n\t\tCantidad Transportada :\t %s", xijp[i,j];
	}
}

printf "\n\n*~*~*~*\n\n";
printf '\n\n';

printf '\n\n';
printf 'Costo Total Centros de Retorno - Centros de Procesamiento:\t %s\n', sum{i in I, k in K}cikp[i,k]*xikp[i,k];
printf '\n\n#-#-#-# \n\n';

for {i in I} {
	printf "\nCentro de Retorno :\t %s", i;
	for {k in K} {
		printf "\n\tCentro de Procesamiento :\t %s", k;
		printf "\n\t\tCantidad Transportada :\t %s", xikp[i,k];
	}
}



printf '\n';
printf '.....................................................................';
printf '\n';

printf 'Costo transporte Centros de Clasificacion aip Centros de Transformacion: %s\n', sum{j in J, k in K} cjkm[j,k]*xjkm[j,k];
printf '\n';
	printf 'Centro_Clasificacion Centro_Transformacion Cantidad\n';
for {j in J} {
	for {k in K} {
		printf ' %6s%15s%22s\n',j,k, xjkm[j,k];
	}
}

printf '\n';
printf '......................................................................';
printf '\n';
printf '\n';
printf '';
printf '\n';

printf 'Costo Centro de Clasificacion  aip Recycling: %s\n', sum{j in J, r in R} cjRm[j,r]*xjRm[j,r];
printf '\n';
	printf 'Centro_Clasificacion Recycling Cantidad\n';
for {j in J} {
	for {r in R} {
		printf ' %6s%15s%22s\n',j,r, xjRm[j,r];
	}
}

printf '\n';
printf '......................................................................';
printf '\n';

printf 'Costo Centro de Transnformacion  aip Manufactura: %s\n', sum{k in K, m in M} ckFm[k,m]*xkFm[k,m];
printf '\n';
	printf 'Centro_Transformacion Manufactura Cantidad\n';
for {k in K} {
	for {m in M} {
		printf ' %6s%15s%22s\n',k,m, xkFm[k,m];
	}
}

printf '\n';
printf '......................................................................';
printf '\n';

printf 'Costo Centro de transformacion  aip Recycling: %s\n', sum{k in K, r in R} ckRm[k,r]*xkRm[k,r];
printf '\n';
	printf 'Centro_Transformacion Recycling Cantidad\n';
for {k in K} {
	for {r in R} {
		printf ' %6s%15s%22s\n',k,r, xkRm[k,r];
	}
}


printf '\n';
printf '';
printf '\n';

printf 'Costo Centro de transformacion  aip Disposal: %s\n', sum{k in K, d in D} ckDm[k,d]*xkDm[k,d];
printf '\n';
	printf 'Centro_Transformacion Disposal Cantidad\n';
for {k in K} {
	for {d in D} {
		printf ' %6s%15s%22s\n',k,d, xkDm[k,d];
	}
}

printf '\n';
printf '......................................................................';
printf '\n';

printf 'Costo Supplier  aip Manufactura: %s\n', sum{s in S, m in M} cSFm[s,m]*ySFm[s,m];
printf '\n';
	printf 'Supplier Manufactura Cantidad\n';
for {s in S} {
	for { m in M} {
		printf ' %6s%15s%22s\n',s,m, ySFm[s,m];
	}
}

printf '\n';
printf '';
printf '\n';


printf 'Apertura de los centros de clasificacion: %s\n';
printf '\n';
	printf 'Centro_Clasificacion Estado\n';
	for {j in J} {
		printf ' %10s%15s%20s\n',j,zjp[j];
		printf '\n';
	}

printf '\n';
printf '';
printf '\n';


printf 'Apertura de los centros de transformacion: %s\n';
printf '\n';
	printf 'Centro_Transformacion Estado\n';
	for {k in K} {
		printf ' %10s%15s%20s\n',k,wkm[k];printf '\n';
	}

printf '\n';
printf '';

###########################################
###########################################

end;
