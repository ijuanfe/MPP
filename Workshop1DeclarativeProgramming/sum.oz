% Punto 4. Computación Recursiva vs Computación Iterativa

% Función que calcula la sumatoria de un número

% Versión Recursiva:
declare Sum

fun {Sum N}
   if N == 0 then 0
   else N + {Sum N-1} end % Es una computación recursiva porque la suma "N + {Sum N-1}" se realiza después del llamado recursivo
end


% Versión Iterativa: formular el problema como una secuencia de transformación de estados (I+N)w
declare SumIter

fun {SumIter N} % I: Iterador, se formula el problema como una secuencia de transformación de estados
   fun {SumIterAux I N}
      if N == 0 then I % Estado final: Sf
      else
	 {SumIterAux I+N N-1} % Transformación de estados (Invariante): es una computación iterativa porque la suma "I+N" se realiza antes del llamado recursivo, I: almacena el resultado de cada iteración
      end
   end
in
   {SumIterAux 0 N} % Estado inicial: S0 (I=0)
end


% Pruebas:
{Browse {SumIter 10}} % --> 55
{Browse {SumIter 20}} % --> 210
{Browse {SumIter 30}} % --> 465