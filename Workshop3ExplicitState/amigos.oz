% Punto 6. Problema Amigos y dinero

declare PagoDeuda

% Función para construir matriz que representa el grafo de las amistades
fun {PagoDeuda Amistades Deudas}
   
   % Inizializar todas las amistades de la matriz (grafo) en false
   LenDeudas = {Length Deudas} % Tamaño de la matriz (grafo): [LenDeudas]x[LenDeudas]
   MatrizAmistades = {Array.new 1 LenDeudas nil}
   for N in 1..LenDeudas do
      MatrizAmistades.N := {Array.new 1 LenDeudas false} % Insertar un array en cada posición del array exterior
   end
   
   % Crear diccionario de amistades para fácil manipulación
   LenAmistades = {Length Amistades}
   DictAmistades = {Record.toDictionary {List.toTuple amistades Amistades}}
   
   % Añadir amistades conocidas a la matriz (grafo)
   for I in 1..LenAmistades do
      MatrizAmistades.(DictAmistades.I.1).(DictAmistades.I.2) := true
   end
   
   Resultado = {NewCell 0}       % Celda para sumar los grupos de amistades
   FlagTrue = {NewCell false}    % Celda para verificar la solución del problema
   FlagFalse = {NewCell false}   % Celda para verificar la solución del problema
   ArrayDeudas = {Tuple.toArray {List.toTuple deudas Deudas}}
   KeyGrupo = {NewCell 1}        % Celda para añadir llaves al diccionario de los grupos de amigos
   CrearGrupo = {NewCell false}  % Celda para determinar si se debe crear un grupo en el diccionario de amigos
   AgregarAmigo = {NewCell true} % Celda para determinar si se debe seguir iterando sobre el diccionario de amigos
   
   % Diccionario de grupos de amigos (para ser usado luego de calcular la clausura transitiva del grafo de amigos)
   GruposAmigosDict = {Dictionary.new}
   {Dictionary.put GruposAmigosDict 1 nil}
   
   % Procedimiento que construye la clausura transitiva del grafo (matriz) de las amistades
   proc {StateTrans Grafo}
      for K in 1..LenDeudas do
	 for I in 1..LenDeudas do
	    if Grafo.I.K then
	       for J in 1..LenDeudas do
		  Grafo.I.J := Grafo.I.J orelse Grafo.K.J
 	       end
	    end
	 end
      end
   end
   
   % Procedimiento que imprimir la matriz (Grafo) de amistades
   proc {ShowGraph Grafo}
      for I in 1..LenDeudas do
	 for J in 1..LenDeudas do
	    {Show I#J#Grafo.I.J}
	    {Delay 500}
	 end
      end
   end
   
   % Procedimiento para construir un diccionario que contiene los grupos de las amistades que se pueden transferir dinero
   proc {GruposAmigos Grafo Diccionario}
      for I in 1..LenDeudas do
	 for J in 1..LenDeudas do
	    if Grafo.I.J then % Evaluar sólo las amistades existentes (pareja I#J == true)
	       for K in 1..{Length {Dictionary.entries Diccionario}} do              % Recorrer el diccionario de los grupos de amigos actual
		  if @AgregarAmigo == true then % Si ya fue agregada la pareja actual I#J al grupo, entonces no evaluar más hasta la otra pareja
		     {EvaluarGrupo {Dictionary.get Diccionario K} Diccionario I J K}
		  end
	       end
	       if @CrearGrupo then
		  KeyGrupo := @KeyGrupo + 1
		  {Dictionary.put Diccionario @KeyGrupo [I J]}
		  CrearGrupo := false
	       end
	       AgregarAmigo := true
	    end
	 end
      end
   end
   
   % Procedimiento para evaluar si una pareja de amigos puede agregarse a un grupo de amigos
   proc {EvaluarGrupo ListaGrupo Diccionario I J K}
      if ListaGrupo == nil then
	 {Dictionary.put Diccionario @KeyGrupo [I J]}
      elseif {List.member I ListaGrupo} andthen {Not {List.member J ListaGrupo}} then
	 {Dictionary.exchange Diccionario K _ {List.append Diccionario.K [J]}}
	 CrearGrupo := false
	 AgregarAmigo := false
      elseif {Not {List.member I ListaGrupo}} andthen {List.member J ListaGrupo} then
	 {Dictionary.exchange Diccionario K _ {List.append Diccionario.K [I]}}
	 CrearGrupo := false
	 AgregarAmigo := false
      elseif {Not {List.member I ListaGrupo}} andthen {Not {List.member J ListaGrupo}} then
	 CrearGrupo := true % Crear grupo de momento
      elseif {List.member I ListaGrupo} andthen {List.member J ListaGrupo} then
	 CrearGrupo := false
	 AgregarAmigo := false
      else skip skip end
   end
   
   % Procedimiento para verificar si se puede cumplir los pagos para un respectivo grupo de amigos
   proc {VerificarPagoDeudas Diccionario Deudas}
      for I in 1..{Length {Dictionary.entries Diccionario}} do  % Recorrer el diccionario de los grupos de amistades final
	 for J in {Dictionary.get Diccionario I} do
	    Resultado := @Resultado + {Array.get Deudas J}
	 end
	 if @Resultado == 0 then
	    FlagTrue := true
	    Resultado := 0 % Reiniciar resultado para otra iteración
	 else
	    FlagFalse := true % Si al menos la suma de un grupo es diferente de 0, no se pueden pagar
	    Resultado := 0
	 end
      end
   end
   
   % Función para sumar los elementos de una lista
   fun {SumList L I}
      case L of nil then I
      [] LH | LT then
	 {SumList LT I+LH}
      end
   end
in
   {StateTrans MatrizAmistades} % Crear clausura transitiva del grafo de amistades
   %{ShowGraph MatrizAmistades}  % Imprimir grafo de amistades
   {GruposAmigos MatrizAmistades GruposAmigosDict}
   {VerificarPagoDeudas GruposAmigosDict ArrayDeudas}
   if @FlagFalse then false
   else @FlagTrue end
end

{Browse {PagoDeuda [1#2 2#3 4#5] [100 ~75 ~25 ~42 42]}}
{Browse {PagoDeuda [1#3 2#4] [15 20 ~10 ~25]}}
{Browse {PagoDeuda [1#3 3#5 4#2 2#6 5#7] [~23 60 108 ~20 ~100 ~40 15]}}