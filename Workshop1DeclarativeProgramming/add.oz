% Punto 8. Escriba una función {Add B1 B2} que retorna el resultado de sumar los números binarios
% B1 y B2. Un número binario es representado como una lista de dígitos binarios. El dígito más
% significativo es el primer elemento de la lista {Add [1 1 0 1 1 0] [0 1 0 1 1 1]} ---> [1 0 0 1 1 0 1]
% Asuma que las dos listas tienen el mismo número de elementos

declare Add

fun {Add B1 B2}
   
   % Función que cálcula el caso de la suma de 2 números binarios teniendo en cuenta el acarreo actual (Cf: Carry Flag)
   fun {AddBinCf B1H B2H Cf}
      if     B1H + B2H + Cf == 0 then 0
      elseif B1H + B2H + Cf == 1 then 1
      elseif B1H + B2H + Cf == 2 then 2
      elseif B1H + B2H + Cf == 3 then 3
      else error end
   end
   
   % Función que invierte el orden de una lista
   fun {ListReverse L}
      {List.reverse L} % También se puede usar {Reverse L}
   end

   % Función auxiliar principal que genera el resultado de la suma dos números binarios
   fun {AddAux B1 B2 Cf}
      case B1 of nil then % Caso parada: no hay más números
	 if Cf == 0 then nil % Si no quedó acarreo: nil
	 else Cf | nil end % Si quedó acarreo, tenerlo en cuenta: Cf | nil
      [] B1H | B1T then
	 case B2 of B2H | B2T then
	    local BinCondResult = {AddBinCf B1H B2H Cf} in
	       if     BinCondResult == 0 then
		  0 | {AddAux B1T B2T 0} % Caso: 0, Suma = 0, Cf = 0
	       elseif BinCondResult == 1 then
		  1 | {AddAux B1T B2T 0} % Caso: 1, Suma = 1, Cf = 0
	       elseif BinCondResult == 2 then
		  0 | {AddAux B1T B2T 1} % Caso: 2, Suma = 0, Cf = 1
	       elseif BinCondResult == 3 then
		  1 | {AddAux B1T B2T 1} % Caso: 3, Suma = 1, Cf = 1
	       else error end
	    end
	 end
      end
   end
in
   {ListReverse {AddAux {ListReverse B1} {ListReverse B2} 0}} % El acarreo inicia en 0 (Cf = 0)
end


% Identificadores de variables:
% B1: número binario 1 (lista)
% B2: número binario 2 (lista)
% Cf: Carry flag (acarreo)
% B1H: B1 Head
% B2H: B2 Head
% B1T: B1 Tail
% B2T: B2 Tail

% Casos suma binaria con acarreo: 2^3 posibles configuraciones de suma
% Cf  B1H B2H         Casos
%  0   0   0  Caso: 0, Suma = 0, Cf = 0
%  0   0   1  Caso: 1, Suma = 1, Cf = 0
%  0   1   0  Caso: 1, Suma = 1, Cf = 0
%  1   0   0  Caso: 1, Suma = 1, Cf = 0
%  0   1   1  Caso: 2, Suma = 0, Cf = 1
%  1   0   1  Caso: 2, Suma = 0, Cf = 1
%  1   1   0  Caso: 2, Suma = 0, Cf = 1
%  1   1   1  Caso: 3, Suma = 1, Cf = 1

% Pruebas:
{Browse {Add [1 1 0 1 1 0] [0 1 0 1 1 1]}}             % --> [1 0 0 1 1 0 1]
{Browse {Add [1 1 1 1 1 1 1 1 1] [0 0 0 0 0 0 0 0 0]}} % --> [1 1 1 1 1 1 1 1 1]
{Browse {Add [1 1 1 1 1 1 1 1 1] [1 1 1 1 1 1 1 1 1]}} % --> [1 1 1 1 1 1 1 1 1 0]