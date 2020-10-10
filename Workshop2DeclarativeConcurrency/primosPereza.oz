% Punto 8. Números Primos: Lazy Evaluation

declare ShowPrimes

% Punto 8.c.
fun {ShowPrimes N}

   % Punto 8.b.
   fun {Primes}
      
      % Punto 8.a.
      % Función que genera perezosamente una lista de todos los enteros comenzando en I
      fun lazy {Gen I}
	 I | {Gen I+1}
      end
      
      % Función que genera perezosamente una lista de números primos en orden ascendente
      fun lazy {Criba Xs}
	 case Xs of nil then nil
	 [] X | Xr then Ys in
	    thread Ys = {Filter Xr fun {$ Y} Y mod X \= 0 end} end
	    X | {Criba Ys}
	 end
      end
      
      % Función que filtra perezosamente números divisibles exactos de una lista de números naturales de un número
      fun lazy {Filter Nn EsDivExac}
	 case Nn of nil then nil
	 [] NnH | NnT then
	    if {EsDivExac NnH} then NnH | {Filter NnT EsDivExac}
	    else {Filter NnT EsDivExac} end
	 end
      end
      Nn = {Gen 2}
   in
      {Criba Nn} % Iniciador de la criba con los números naturales iniciando en 2
   end
in
   local P in
      P = {Primes} % Hilo Perezoso generador de números primos
      
      % La siguiente instrucción retorna el elemento N de la lista P de números primos 
      % Nota: en realidad este último valor que se retorna no es necesario, pero el llamado a la función si obliga a las funciones
      %       perezosas que calculen los números primos hasta N, en otras palabras: dispara la necesidad de calcular los primos hasta N
      _ = {List.nth P N}
      P % Retorna los números primos calculados perezosamente
   end
end

{Browse {ShowPrimes 15}}