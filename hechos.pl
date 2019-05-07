esCafe(espresso).
esCafe(americano).
esCafe(latte).
esCafe(mokaccino).
%esCafe(macchiato).
esCafe(capuccino).
esCafe(cortado).
granoCafe(arabica).
granoCafe(robusta).
granoCafe(combinado).
granoCafe(descafeinado).
intensidad(arabica, suave).
intensidad(robusta, intenso).
intensidad(combinado, medio).
intensidad(descafeinado, suave).
preparacion(espresso, 7,30,0,0). %nombre, cafe, agua, leche, chocolate
preparacion(americano, 7,60,0,0).
preparacion(cortado, 7,50,3,0).
preparacion(capuccino,7,150,19,0).
preparacion(latte, 7,90,9,0).
preparacion(mokaccino,7,100,9,3).
instalada(si).
esTamanio(pequenio).
esTamanio(mediano).
esTamanio(grande).
tamanioTaza(pequenio, 150).
tamanioTaza(mediano, 225).
tamanioTaza(grande, 300).
estacionDelAnio(primavera).
estacionDelAnio(otonio).
estacionDelAnio(invierno).
estacionDelAnio(verano).
%Tiempo de preparacion en segundos
tiempoPreparacion(verano,60).
tiempoPreparacion(otonio,90).
tiempoPreparacion(primavera,90).
tiempoPreparacion(invierno,120).

%P: preparacion, TT: tamanio taza, MEDIDAS: resultado, medidas pra el
% tamanio de taza ingresado uwu
%
evaluate(X,R):- R is X.
multiplicar(V,[R1,R2,R3,R4]):- R1 = R1*(V/R2),R2 = R2*(V/R2),R3 = R3*(V/R2),R4 = R4*(V/R2).
%P: tipo preparacion, TT: tamanio taza
preparacionTaza2(P, TT, [R11,R22,R33,R44]):- esTamanio(TT),tamanioTaza(TT,TAMANIO),preparacion(P,R1,R2,R3,R4),  R11 is R1*(TAMANIO/R2), R22 is R2*(TAMANIO/R2), R33 is R3*(TAMANIO/R2), R44 is R4*(TAMANIO/R2).
preparacionTaza(espresso, grande, [70,300,0,0]).
preparacionTaza(espresso, medio, [52.5,225,0,0]).
preparacionTaza(espresso, pequenio, [35,150,0,0]).

preparacionTaza(americano, grande, [35,300,0,0]).
preparacionTaza(americano, medio, [26.25,225,0,0]).
preparacionTaza(americano, pequenio, [17.5,150,0,0]).

preparacionTaza(cortado, grande, [42,300,18,0]).
preparacionTaza(cortado, medio, [31.5,225,13.5,0]).
preparacionTaza(cortado, pequenio, [21,150,9,0]).

preparacionTaza(capuccino, grande, [14,300,38,0]).
preparacionTaza(capuccino, medio, [10.5,225,28.5,0]).
preparacionTaza(capuccino, pequenio, [7,150,19,0]).

preparacionTaza(latte, grande, [23.4,300,30,0]).
preparacionTaza(latte, medio, [17.5,225,22.5,0]).
preparacionTaza(latte, pequenio, [11.7,150,15,0]).

preparacionTaza(mokaccino, grande, [21,300,27,9]).
preparacionTaza(mokaccino, medio, [15.75,225,20.25,6.75]).
preparacionTaza(mokaccino, pequenio, [10.5,150,13.5,4.5]).

%GRANDE: 300ml de agua, MEDIO: 225ml de agua, PEQUE�O: 150ml de agua
% TT: tamanio taza, TP: tipo preparacion, TC: tipo cafe, E_ estacion del
% a�o, S: salida
flatten2([a, [b,c], [[d],[],[e]]], R).
my_flatten(X,[X]) :- \+ is_list(X).
my_flatten([],[]).
my_flatten([H|T],R) :-
    my_flatten(H,HFlat),
    my_flatten(T,TFlat),
    append(HFlat,TFlat,R).
flatArray([],[]).
flatArray([Head|Tail],R) :-
	flatArray(Head,New_Head),
	flatArray(Tail,New_Tail),
	append(New_Head,New_Tail,R).
flatArray([Head|Tail1], [Head|Tail2]) :-
	Head \= [],
	Head \= [_|_],
flatArray(Tail1,Tail2).
concatenarListas(Listas, Respuesta):- concatenarListasR(Listas,Respuesta).
concatenarListasR([X],X). %Hecho
concatenarListasR([X,Y|Xs],Respuesta):- append(X,Y,Aux), concatenarListasR([Aux|Xs],Respuesta).
list_min([L|Ls], Min) :- foldl(num_num_min, Ls, L, Min).
num_num_min(X, Y, Min) :- Min is min(X, Y).
% TT: tamanio taza, TP: tipo preparacion, TC: tipo cafe, E: estacion, R:
% salida
prepararCafe(TT,TP,TC,E,R):- esTamanio(TT),estacionDelAnio(E),esCafe(TP),granoCafe(TC), preparacionTaza2(TP,TT,HH),tiempoPreparacion(E,HH2),intensidadCafeTamanio(TC,TP,TT,HH1) , concatenarListas([HH,[HH1],[HH2]],R).
% TT: tamanio taza, TP: tipo preparacion, TC: tipo cafe, E: estacion,
% CC: cantidad cafe, CL: cantidad leche, CA: cantidad agua
cantidadTazas(TT,TP,TC,E,CC,CL,CA,[CANTIDAD,TIEMPO]):-
 granoCafe(TC),
 esTamanio(TT),
 esCafe(TP),
 estacionDelAnio(E),
 prepararCafe(TT,TP,TC,E,[R1,R2,R3,R4,R5,R6]),
 compare(>,R3,0),
 TAZASSEGUNCAFE is CC/R1,
 TAZASSEGUNAGUA is CA/R2,
 TAZASSEGUNLECHE is CL/R3,
 list_min([TAZASSEGUNCAFE,TAZASSEGUNAGUA,TAZASSEGUNLECHE],CANTIDADPARCIAL),
 floor(CANTIDADPARCIAL,CANTIDAD),
 tiempoPreparacion(E,T),
 TIEMPO is CANTIDAD*T;
 granoCafe(TC),
 esTamanio(TT),
 esCafe(TP),
 estacionDelAnio(E),
 prepararCafe(TT,TP,TC,E,[R1,R2,R3,R4,R5,R6]),
 TAZASSEGUNCAFE is CC/R1,
 TAZASSEGUNAGUA is CA/R2,
 list_min([TAZASSEGUNCAFE,TAZASSEGUNAGUA],CANTIDADPARCIAL),
 floor(CANTIDADPARCIAL,CANTIDAD),
 tiempoPreparacion(E,T),
 TIEMPO is T*CANTIDAD.
%I: instalada, CA: cantidad agua, CF: cantidad cafe, CL: cantidad leche
sePuedeUsar(I,CA,CF,CL):- instalada(I),CA>=150,CF>=30,CL>=30.
% CA: cantidad agua, CL: cantidad leche, IO: intensidad original, IN:
% intensidad nueva
modificarIntensidad(CA,CL,IO,IN):- IO==suave, IN=IO; CA>=100, CL > 0, IO == intenso, IN =medio; CA>=100,CL>0, IO == medio, IN = suave; CA < 100,  IN = IO;CL=:=0, IN = IO;CA<100,CL=:=0,IN=IO.

%TC: tipo cafe, TP: tipo preparacion, I: intensidad
intensidadCafe(TC,TP,I):- intensidad(TC,S),preparacion(TP,_,CA,CL,_),modificarIntensidad(CA,CL,S,I).
intensidadCafeTamanio(TC,TP,TT,I):- intensidad(TC,S),preparacionTaza2(TP,TT,[_,CA,CL,_]),modificarIntensidad(CA,CL,S,I).














