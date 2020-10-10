% Punto 3. Productor-Filtro-Consumidor: suma números impares

local GenInt FilterInt SumList EsImpar Xs Ys S in
   
   % Función que genera números enteros en un rango dado
   fun {GenInt Inicio Final}
      if Inicio == Final then nil % No incluye el último número a la lista. Si se quisiera incluir: then Inicio | nil ó Final | nil
      else Inicio | {GenInt Inicio + 1 Final} end
   end
   
   % Función que filtra números impares de una lista de enteros
   fun {FilterInt IntList EsImpar}
      case IntList of nil then nil
      [] IntListH | IntListT then
	 if {EsImpar IntListH} then IntListH | {FilterInt IntListT EsImpar}
	 else {FilterInt IntListT EsImpar} end
      end
   end
   
   % Función que suma los números de una lista de enteros
   fun {SumList L I}
      case L of nil then I
      [] LH | LT then
	 {SumList LT I+LH} % Computación Iterativa
      end
   end
   
   % Función que determina si un número es impar o no
   fun {EsImpar X}
      X mod 2 \= 0
   end
   
   thread Xs = {GenInt 0 10000} end        % Hilo Productor
   thread Ys = {FilterInt Xs EsImpar} end  % Hilo Filtrador, Transductor sencillo o Canal (Consumidor y Productor)
   thread S  = {SumList Ys 0} end          % Hilo Consumidor
   {Browse S}
end