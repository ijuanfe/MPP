% Punto 3. Implementar una función que reciba como parámetro un entero N y retorne una lista incremental
% de factoriales, comenzando en 1! hasta N!. Implemente la función de manera que la computación sea recursiva
% {FactList 4} retorna [1 2 6 24], que corresponde a la lista de factoriales [1! 2! 3! 4!]

declare FactList

fun {FactList N}
   
   % Función que calcula el factorial de un número
   fun {Fact N}
      if N == 0 then 1
      else
	 N * {Fact N-1} % Computación recursiva
      end
   end
   
   % Función que invierte el orden de una lista (decremental --> incremental)
   fun {ListReverse L}
      {List.reverse L} % También se puede usar {Reverse L}
   end
   
   % Función auxiliar principal que construye una lista decremental de factoriales
   fun {FactListAux N}
      if N == 0 then nil
      else
	 {Fact N} | {FactListAux N-1}
      end
   end
in
   {ListReverse {FactListAux N}}
end


% Pruebas:
{Browse {FactList 4}}  % --> [1 2 6 24]
{Browse {FactList 8}}  % --> [1 2 6 24 120 720 5040 40320]
{Browse {FactList 12}} % --> [1 2 6 24 120 720 5040 40320 362880 3628800 39916800 479001600]