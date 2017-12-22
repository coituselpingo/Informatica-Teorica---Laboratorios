#Reverse Logistic

set I; #return centers
set J; #disassembly centers
set K; #processing centers

set M; #parts

set R; #recycling centers
set S; #supplier centers
set D; #disposal centers


###########################################



param a{i in I };
                  param b{j in J };
                  param u{k in K };
                  param dM{m in M}; #capacidad de remanufactura
				  param uR{r in R}; #capacidad de reciclaje
                  param uS{s in S}; # capacidad del proveedor
                  param uD{d in D}; #capacidad de disposal

     #costos  transporte
param c1{i in I , j in J};
param c2{i in I, k in K};
param c3{j in J , k in K};
param c5{j in J , r in R};
param c6{k in K, m in M};
param c7{k in K, r in R};
param c8{k in K,d in D};
param c9{j in J};
param c10{k in K};
param c11{s in S,m in M};

                                                   #variables

var x1{i in I , j in J} >= 0 ,integer ;
var x2{i in I , k in K} >= 0 ,integer ;
var x3{j in J , k in K} >= 0 ,integer ;
var x5{j in J , r in R} >= 0 ,integer ;
var x6{k in K , m in M} >= 0 ,integer ;
var x7{k in K , r in R} >= 0 ,integer ;
var x8{k in K , d in D} >= 0 ,integer ;
var  y{s in S , m in M} >= 0 ,integer ;

var z{j in J} , binary;
var w{k in K}, binary;


minimize Z : sum{j in J} c9[j]*z[j]  +
			 sum{k in K} c10[k]*w[k] +
			 sum{i in I,j in J} c1[i,j]*x1[i,j]  +
			 sum{i in I,k in K} c2[i,k]*x2[i,k]  +
			 sum{j in J,k in K} c3[j,k]*x3[j,k]  -
			 sum{j in J, r in R} c5[j,r]*x5[j,r] +
			 sum{k in K, m in M} c6[k,m]*x6[k,m] -
			 sum{k in K, r in R} c7[k,r]*x7[k,r] +
			 sum{k in K , d in D} c8[k,d]*x8[k,d]+
			 sum{s in S,m in M} c11[s,m]*y[s,m];



s.t. R1{i in I}: sum{j in J} x1[i,j] + sum{k in K} x2[i,k] >= a[i];
s.t. R2{j in J}: sum{k in K} x3[j,k] + sum{r in R} x5[j,r] <= b[j]*z[j];
s.t. R3{k in K}: ( sum{m in M} x6[k,m] + sum{r in R} x7[k,r] + sum{d in D} x8[k,d])<= u[k]*w[k];
s.t. R4{j in J}: (sum{i in I} x1[i,j]) = (sum{k in K} x3[j,k])  + (sum{r in R} x5[j,r]) ;
s.t. R5{k in K}: (sum{i in I} x2[i,k]) + (sum{j in J} x3[j,k]) = (sum{m in M} x6[k,m]) + (sum{r in R} x7[k,r]) + (sum{d in D} x8[k,d]) ;
s.t. R6{j in J}: z[j]<= 3;
s.t. R7{k in K}: w[k]<= 5 ;
s.t. R8{r in R}: (sum{j in J} x5[j,r]) + (sum{k in K} x7[k,r]) <= uR[r];
s.t. R9{d in D}:  (sum{k in K} x8[k,d]) <= uD[d];
s.t. R10{m in M}: sum{s in S} y[s,m] + sum{k in K} x6[k,m] >= dM[m];





solve;

printf '\n';
printf 'Costo transporte Centros de Retorno a Centros de Clasificacion: %s\n', sum{i in I, j in J} c1[i,j]*x1[i,j];
printf '\n';
printf '......................................................................';
printf '\n';
	printf 'Centro_Retorno Centro_Clasificacion Cantidad\n';
for {i in I} {
	for {j in J} {
		printf ' %6s%15s%22s\n',i,j, x1[i,j];
	}
}

printf '\n';
printf '......................................................................';
printf '\n';

printf 'Costo transporte Centros de Retorno a Centros de Transformacion: %s\n', sum{i in I, k in K} c2[i,k]*x2[i,k];
printf '\n';

	printf 'Centro_Retorno Centro_Transformacion Cantidad\n';
for {i in I} {
	for {k in K} {
		printf ' %6s%15s%22s\n',i,k, x2[i,k];
	}
}


printf '\n';
printf '.....................................................................';
printf '\n';

printf 'Costo transporte Centros de Clasificacion a Centros de Transformacion: %s\n', sum{j in J, k in K} c3[j,k]*x3[j,k];
printf '\n';
	printf 'Centro_Clasificacion Centro_Transformacion Cantidad\n';
for {j in J} {
	for {k in K} {
		printf ' %6s%15s%22s\n',j,k, x3[j,k];
	}
}

printf '\n';
printf '......................................................................';
printf '\n';
printf '\n';
printf '';
printf '\n';

printf 'Costo Centro de Clasificacion  a Recycling: %s\n', sum{j in J, r in R} c5[j,r]*x5[j,r];
printf '\n';
	printf 'Centro_Clasificacion Recycling Cantidad\n';
for {j in J} {
	for {r in R} {
		printf ' %6s%15s%22s\n',j,r, x5[j,r];
	}
}

printf '\n';
printf '......................................................................';
printf '\n';

printf 'Costo Centro de Transnformacion  a Manufactura: %s\n', sum{k in K, m in M} c6[k,m]*x6[k,m];
printf '\n';
	printf 'Centro_Transformacion Manufactura Cantidad\n';
for {k in K} {
	for {m in M} {
		printf ' %6s%15s%22s\n',k,m, x6[k,m];
	}
}

printf '\n';
printf '......................................................................';
printf '\n';

printf 'Costo Centro de transformacion  a Recycling: %s\n', sum{k in K, r in R} c7[k,r]*x7[k,r];
printf '\n';
	printf 'Centro_Transformacion Recycling Cantidad\n';
for {k in K} {
	for {r in R} {
		printf ' %6s%15s%22s\n',k,r, x7[k,r];
	}
}


printf '\n';
printf '';
printf '\n';

printf 'Costo Centro de transformacion  a Disposal: %s\n', sum{k in K, d in D} c8[k,d]*x8[k,d];
printf '\n';
	printf 'Centro_Transformacion Disposal Cantidad\n';
for {k in K} {
	for {d in D} {
		printf ' %6s%15s%22s\n',k,d, x8[k,d];
	}
}

printf '\n';
printf '......................................................................';
printf '\n';

printf 'Costo Supplier  a Manufactura: %s\n', sum{s in S, m in M} c11[s,m]*y[s,m];
printf '\n';
	printf 'Supplier Manufactura Cantidad\n';
for {s in S} {
	for { m in M} {
		printf ' %6s%15s%22s\n',s,m, y[s,m];
	}
}

printf '\n';
printf '';
printf '\n';


printf 'Apertura de los centros de clasificacion: %s\n';
printf '\n';
	printf 'Centro_Clasificacion Estado\n';
	for {j in J} {
		printf ' %10s%15s%20s\n',j,z[j];
		printf '\n';
	}

printf '\n';
printf '';
printf '\n';


printf 'Apertura de los centros de transformacion: %s\n';
printf '\n';
	printf 'Centro_Transformacion Estado\n';
	for {k in K} {
		printf ' %10s%15s%20s\n',k,w[k];printf '\n';
	}

printf '\n';
printf '';
#end;

data;
set I:=  i1 i2 i3 i4 i5;
set J:=  j1 j2 j3;
set K:= k1 k2 k3 k4 k5;
set M:= m1;
set R:= r1;
set S:= s1;
set D:= d1;

param a:=
i1 18
i2 60
i3 50
i4  40
i5  50;
param b:=
j1 80
j2 150
j3 100;
param u:=
k1 100
k2 180
k3 50
k4 15
k5 10;


param dM:=
m1 100;
param uR:=
r1 100;

param uD:=
d1 100;


param c1: j1 j2 j3:=
i1 0 18 0
i2  10 0 12
i3 0 13 0
i4 16 0 14
i5 0 20 0;
param c2: k1 k2 k3 k4 k5:=
i1 150 0 0 0 0
i2 140 0 0 0 0
i3 250 0 0 0 0
i4 250 0 0 0 0
i5 250 0 0 0 0;
param c3: k1 k2 k3 k4 k5:=
j1 26 0 0 30 0
j2 43 0 24 0 0
j3 15 0 0 23 0;

param c5: r1:=
j1 110
j2 85
j3 70;

param c6: m1:=
k1 0
k2 10
k3 0
k4 10
k5 0;
param c7: r1:=
k1 0
k2 11
k3 0
k4 12
k5 0;
param c8: d1:=
k1 0
k2 10
k3 0
k4 10
k5 0;

param c9:=
j1 12
j2 10
j3 9;
param c10:=
k1 10
k2 11
k3 10
k4 12
k5 10;

param c11: m1 :=
s1 12;
end;
