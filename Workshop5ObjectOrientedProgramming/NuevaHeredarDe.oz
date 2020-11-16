% Punto 1. Implementando herencia múltiple en general

% Creación de las funciones Envolver y Desenvolver
declare Envolver Desenvolver
{NuevoEmpacador Envolver Desenvolver}

declare NuevaHeredarDe

fun {NuevaHeredarDe Clase SuperClases} % SuperClases: (e.g. [Class1 Class2 .. ClassN])
   
   c(metodos:M1 atrbs:A1) = {Desenvolver Clase} % Clase base
   c(metodos:M2 atrbs:A2) = {Desenvolver SuperClases.1}
   MA1 = {Arity M1} % Arity: lista de los features en orden ascendente
   MA2 = {Arity M2}
   InterMetAux = {NewCell MA2} % Celda para almacenar las intercepciones parciales de los metodos
   InterAtrAux = {NewCell A2}  % Celda para almacenar las intercepciones parciales de los atributos
   AnulMetAux  = {NewCell M2}  % Celda para almacenar las anulaciones de los métodos heredados de las superclases
   AtrHerAux   = {NewCell A2}  % Celda para almacenar los atributos heredados de las superclases
   MetEnConfl  = {NewCell _}   % Celda para almacenar si hay conflictos de herencia de métodos en cada iteración
   AtrEnConfl  = {NewCell _}   % Celda para almacenar si hay conflictos de herencia de atributos en cada iteración
   MetEnConflFinal = {NewCell false} % Celda para almacenar cuando se detecta algún conflicto de herencia de métodos
   AtrEnConflFinal = {NewCell false} % Celda para almacenar cuando se detecta algún conflicto de herencia de atributos
   
   % Ciclo que recorre las superclases y resuelve:
   % Desenvolver, Arity, MetEnConfl, AtrEnConfl, Adjoin (Anulación de métodos) y Union (atributos heredados)
   for SuperClase in SuperClases.2 do % Iniciar el ciclo desde el resto de la lista, ya que la primer superclase se extrajo
      local Mn An MAn in
	 
	 c(metodos:Mn atrbs:An) = {Desenvolver SuperClase}
	 MAn = {Arity Mn}
	 InterMetAux := {Inter @InterMetAux MAn}
	 InterAtrAux := {Inter @InterAtrAux An}
	 AnulMetAux  := {Adjoin @AnulMetAux Mn}
	 AtrHerAux   := {Union @AtrHerAux An}
	 
	 % Verificar conflictos de herencia de métodos y atributos de las superclases
	 MetEnConfl  := {Minus @InterMetAux MA1}
	 AtrEnConfl  := {Minus @InterAtrAux A1}
	 if @MetEnConfl \= nil then
	    MetEnConflFinal := true
	 end
	 if @AtrEnConfl \= nil then
	    AtrEnConflFinal := true
	 end
      end
   end
in
   if @MetEnConflFinal then
      raise herenciaIlegal(metEnConfl:MetEnConfl) end
   end
   if @AtrEnConflFinal then
      raise herenciaIlegal(atrEnConfl:AtrEnConfl) end
   end
   
   % Si no hay conflictos, entonces envolver todos los métodos de las superclases
   {Envolver c(metodos:{Adjoin @AnulMetAux M1} % Adjoin: anula (overrides) los métodos de las superclases
	       atrbs:{Union @AtrHerAux A1})}   % Union: hereda todos los atributos de las superclases
end