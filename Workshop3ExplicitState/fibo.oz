% Punto 4. Función Fibonacci utilizando celdas

declare Fibo

fun {Fibo N}
   FiboM2 = {NewCell 1} % Celda que representa la posición fib(N-2) y su contenido inicia en 1
   FiboM1 = {NewCell 1} % Celda que representa la posición fib(N-1) y su contenido inicia en 1
   FiboR  = {NewCell 1} % Celda que almacena el resultado y su contenido inicia en 1
in
   for X in 2..N do
      	 FiboR  := @FiboM1 + @FiboM2
	 FiboM2 := @FiboM1 % Desplazar FiboM2 a la posición de FiboM1
	 FiboM1 := @FiboR  % Desplazar FiboM1 a la posición de FiboR
   end
   @FiboR
end


% Pruebas:
{Browse {Fibo 0}}  % --> 1
{Browse {Fibo 5}}  % --> 8
{Browse {Fibo 10}} % --> 89