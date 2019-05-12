%Definición de hechos en la base de conocimientos:

%Tipos de preparación de café:
esCafe(espresso).
esCafe(americano).
esCafe(latte).
esCafe(mokaccino).
esCafe(capuccino).
esCafe(cortado).

%Tipos de grano de café:
granoCafe(arabica).
granoCafe(robusta).
granoCafe(combinado).
granoCafe(descafeinado).

%Tipos de intensidad regular según grano de café
intensidad(arabica, suave).
intensidad(robusta, intenso).
intensidad(combinado, medio).
intensidad(descafeinado, suave).

%Tipos de preparación con insumos necesarios
% nombre, cantidad de café, cantidad de agua, cantidad de leche,
% cantidad de chocolate
preparacion(espresso, 7,30,0,0).
preparacion(americano, 7,60,0,0).
preparacion(cortado, 7,50,3,0).
preparacion(capuccino,7,150,19,0).
preparacion(latte, 7,90,9,0).
preparacion(mokaccino,7,100,9,3).
%Estado válido de una máquina:
instalada(si).
%Tipos de tamaño de tazas de café
esTamanio(pequenio).
esTamanio(mediano).
esTamanio(grande).
% cantidad de agua según tamaño de taza, esto se usa para determinar
% proporcionalmente el aumento de ingredientes para una
% preparación de una taza de café
tamanioTaza(pequenio, 150).
tamanioTaza(mediano, 225).
tamanioTaza(grande, 300).
%estaciones del año definidas en la base de conocimiento
estacionDelAnio(primavera).
estacionDelAnio(otonio).
estacionDelAnio(invierno).
estacionDelAnio(verano).
%Tiempo de preparacion en segundos, según estación
tiempoPreparacion(verano,60).
tiempoPreparacion(otonio,90).
tiempoPreparacion(primavera,90).
tiempoPreparacion(invierno,120).

% Predicado que recalcula los ingredientes para un tipo de preparación de
% café según el tamaño de la taza escogido
% P: tipo preparacion, TT:tamanio taza, [R11,R22,R33,R44] = [Cantidad
% cafe, cantidad agua, cantidad leche, cantidad chocolate]
preparacionTaza2(P, TT, [R11,R22,R33,R44]):-
    esTamanio(TT),
    tamanioTaza(TT,TAMANIO),
    preparacion(P,R1,R2,R3,R4),
    R11 is R1*(TAMANIO/R2),
    R22 is R2*(TAMANIO/R2),
    R33 is R3*(TAMANIO/R2),
    R44 is R4*(TAMANIO/R2).
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

%GRANDE: 300ml de agua, MEDIO: 225ml de agua, PEQUEÑO: 150ml de agua

%Predicado para concatenar listas, se utiliza dentro de preparar cafe
concatenarListas(Listas, Respuesta):- concatenarListasR(Listas,Respuesta).
concatenarListasR([X],X). %Hecho
concatenarListasR([X,Y|Xs],Respuesta):-
    append(X,Y,Aux),
    concatenarListasR([Aux|Xs],Respuesta).
% Predicado para obtener el elemento mínimo dentro de una lista, se usa
% dentro de cantidadTazas
list_min([L|Ls], Min) :-
    foldl(num_num_min, Ls, L, Min).
num_num_min(X, Y, Min) :-
    Min is min(X, Y).
% Predicado que recibe un tipo de preparación de café, un tipo de grano,
% tamaño de taza y estación. Con todos esos datos se encarga de calcular
% la cantidad de ingredientes necesarios para preparar una taza de
% café, además entrega la intensidad recalculada según las nuevas
% cantidades y el tipo de grano y finalmente el tiempo de preparación
% según la estación del año
%TT: tamaño taza, TP: tipo preparacion, TC:
% tipo cafe, E: estacion, R: salida
prepararCafe(TT,TP,TC,E,R):-
    esTamanio(TT),
    estacionDelAnio(E),
    esCafe(TP),
    granoCafe(TC),
    preparacionTaza2(TP,TT,HH),
    tiempoPreparacion(E,HH2),
    intensidadCafeTamanio(TC,TP,TT,HH1),
    concatenarListas([HH,[HH1],[HH2]],R).
% Predicado que según la cantidad de ingredientes, tamaño de taza,
% estación, tipo de preparación y tipo de grano de café calcula la
% cantidad de tazas resultantes, además del tiempo de preparación total
% de estas
%TT:tamanio taza, TP: tipo preparacion, TC: tipo cafe, E:
% estacion, CC: cantidad cafe, CL: cantidad leche, CA: cantidad agua,
% CCH: cantidad chocolate
cantidadTazas(TT,TP,TC,E,CC,CL,CA,CCH,[CANTIDAD,TIEMPO]):-
    granoCafe(TC), %se comprueba que todos los datos sean válidos
    esTamanio(TT),
    esCafe(TP),
    estacionDelAnio(E),
    prepararCafe(TT,TP,TC,E,[R1,R2,R3,R4,R5,R6]), %se prepara una taza de café con los parámetros ingresados
    compare(>,R3,0), %si la preparación originalmente usa leche, se continúa normalmente
    compare(>,R4,0), %chocolate mayor a 0
    TAZASSEGUNCAFE is CC/R1, %se calcula la cantidad de tazas según la cantidad de café ingresada por argumento
    TAZASSEGUNAGUA is CA/R2, %se calcula la cantidad de tazas según la cantidad de agua ingresada por argumento
    TAZASSEGUNLECHE is CL/R3,%mismo caso que anteriores, pero según la leche
    TAZASSEGUNCHOCOLATE is CCH/R4,%mismo caso que anteriores, segun chocolate
    list_min([TAZASSEGUNCAFE,TAZASSEGUNAGUA,TAZASSEGUNLECHE,TAZASSEGUNCHOCOLATE],CANTIDADPARCIAL), %se busca el mínimo de estos tres valores, el cual será la cantidad de tazas
    floor(CANTIDADPARCIAL,CANTIDAD), %se redondea hacia abajo la cantidad de tazas resultante
    tiempoPreparacion(E,T), %se obtiene el tiempo de preparación por taza según estación
    TIEMPO is CANTIDAD*T; %se multiplica la cantidad de tazas por el tiempo para obtener el tiempo total
    granoCafe(TC),%se tiene una disyuncion, por lo tanto se entra a este caso solo si el tipo de preparacion ingresado no utiliza leche
    esTamanio(TT),
    esCafe(TP),
    estacionDelAnio(E),
    prepararCafe(TT,TP,TC,E,[R1,R2,R3,R4,R5,R6]),
    R3=:=0,%leche y chocolate igual a 0
    R4=:=0,
    TAZASSEGUNCAFE is CC/R1,%debido a que este tipo de preparacion no utiliza leche, la cantidad de esta ingresada por argumento no se considera
    TAZASSEGUNAGUA is CA/R2,
    list_min([TAZASSEGUNCAFE,TAZASSEGUNAGUA],CANTIDADPARCIAL),
    floor(CANTIDADPARCIAL,CANTIDAD),
    tiempoPreparacion(E,T),
    TIEMPO is T*CANTIDAD;%se obtiene la cantidad de tazas y tiempo total de la misma forma que en el caso anterior
     granoCafe(TC),%se tiene una disyuncion, por lo tanto se entra a este caso solo si el tipo de preparacion ingresado no utiliza leche
    esTamanio(TT),
    esCafe(TP),
    estacionDelAnio(E),
    prepararCafe(TT,TP,TC,E,[R1,R2,R3,R4,R5,R6]),
    R3=:=0,%leche igual a 0, chocolate distinto de 0
    compare(>,R4,0),
    TAZASSEGUNCAFE is CC/R1,%debido a que este tipo de preparacion no utiliza leche, la cantidad de esta ingresada por argumento no se considera
    TAZASSEGUNAGUA is CA/R2,
    TAZASSEGUNCHOCOLATE is CCH/R4,
    list_min([TAZASSEGUNCAFE,TAZASSEGUNAGUA,TAZASSEGUNCHOCOLATE],CANTIDADPARCIAL),
    floor(CANTIDADPARCIAL,CANTIDAD),
    tiempoPreparacion(E,T),
    TIEMPO is T*CANTIDAD;%se obtiene la cantidad de tazas y tiempo total de la misma forma que en el caso anterior
    granoCafe(TC),%se tiene una disyuncion, por lo tanto se entra a este caso solo si el tipo de preparacion ingresado no utiliza leche
    esTamanio(TT),
    esCafe(TP),
    estacionDelAnio(E),
    prepararCafe(TT,TP,TC,E,[R1,R2,R3,R4,R5,R6]),
    compare(>,R3,0),%leche distinto de 0, chocolate igual a 0
    R4=:=0,
    TAZASSEGUNCAFE is CC/R1,%debido a que este tipo de preparacion no utiliza leche, la cantidad de esta ingresada por argumento no se considera
    TAZASSEGUNAGUA is CA/R2,
    TAZASSEGUNLECHE is CL/R3,
    list_min([TAZASSEGUNCAFE,TAZASSEGUNAGUA,TAZASSEGUNLECHE],CANTIDADPARCIAL),
    floor(CANTIDADPARCIAL,CANTIDAD),
    tiempoPreparacion(E,T),
    TIEMPO is T*CANTIDAD.%se obtiene la cantidad de tazas y tiempo total de la misma forma que en el caso anterior
% Predicado que verifica si una máquina puede ser usada según si está
% instalada y según las cantidades de ingredientes que contenga
%I:instalada, CA: cantidad agua, CF: cantidad cafe, CL: cantidad leche
sePuedeUsar(I,CA,CF,CL):-
    instalada(I),
    CA>=150,CF>=30,CL>=30.
% Predicado que se encarga de recalcular la intensidad de un café según
% las cantidades de ingredientes de dicha preparación de café
%CA: cantidad agua, CL: cantidad leche, IO: intensidad original, IN:
% intensidad nueva
modificarIntensidad(CA,CL,IO,IN):-
    IO==suave, %si la intensidad es suave, ya no puede disminuir mas
    IN=IO;
    CA>=100,
    CL > 0, %se considera cantidad de leche mayor a 0
    IO == intenso, %si es intenso, pero el agua es mayor a 100, se "diluye" y la intensidad baja a medio
    IN =medio;
    CA>=100,
    CL>0, %se considera cantidad de leche mayor a 0
    IO == medio, %mismo caso al anterior, pero disminuye de medio a suave
    IN = suave;
    CA < 100,%si solo se cumple una condición (agua > 100 o leche > 0), no se produce ningun cambio
    IN = IO;
    CL=:=0,
    IN = IO;
    CA<100,%si la cantidad de agua es menor a 100 y la cantidad de leche es igual a 0, no ocurren cambios
    CL=:=0,
    IN=IO.
% Predicado que recibe un tipo de preparación de café, tipo de grano y
% entrega una intensidad recalculada en base a las cantidades de
% ingredientes básicos para dicha preparación de café
%TC: tipo cafe, TP:
% tipo preparacion, I:intensidad
intensidadCafe(TC,TP,I):-
    intensidad(TC,S),
    preparacion(TP,_,CA,CL,_),
    modificarIntensidad(CA,CL,S,I).
% Predicado que tambien calcula el cambio de la intensidad en un café,
% pero además considerando el cambio de cantidades de ingredientes según
% el tamaño de taza utilizado
intensidadCafeTamanio(TC,TP,TT,I):-
    intensidad(TC,S),
    preparacionTaza2(TP,TT,[_,CA,CL,_]),
    modificarIntensidad(CA,CL,S,I).














