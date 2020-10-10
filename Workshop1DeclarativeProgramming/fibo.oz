% Punto 7. Fibonacci Recursivo vs Fibonacci Iterativo

% Definición Fibonacci:
% fib(n) = 1                     si n < 2
% fib(n) = fib(n-1) + fib(n-2)   si n >= 2

% Función Fibonacci Computación Recursiva (Forma intuitiva):
declare FibonacciRecur

fun {FibonacciRecur N}
   if N < 2 then 1
   else
      {FibonacciRecur N-1} + {FibonacciRecur N-2}
   end
end
{Browse {FibonacciRecur 2}}

% Función Fibonacci Computación Iterativa: formular el problema como una secuencia de transformación de estados (I1=I1+I2, I2=I1)
declare FibonacciIter

fun {FibonacciIter N} % Se formula el problema como una secuencia de transformación de estados
   fun {FibonacciIterAux N I1 I2}
      if N < 2 then I1+I2 % Estado final: Sf
      else
	 {FibonacciIterAux N-1 I1+I2 I1} % Transformación de estados (Invariante): (I1=I1+I2, I2=I1) se va almacenando el resultado de cada iteración
      end
   end
in
   {FibonacciIterAux N 1 0} % Estado inicial: S0 (I1=1, I2=0)
end


% Identificadores de variables:
% I1: (n-1)
% I2: (n-2)

% Pruebas:
declare N = 41

% Fibonacci recursivo: toma alrededor de 1 minuto en calcularlo
{Browse {FibonacciRecur N}}

% Fibonacci iterativo: toma alrededor de 1 segundo en calcularlos
{Browse {FibonacciIter N+1}}
{Browse {FibonacciIter 10*N}}
{Browse {FibonacciIter 100*N}}

% Especificaciones equipo de computo pruebas:
% - Procesador: Intel Core I9 8-Core 2.3 Ghz
% - Memoria RAM: 16GB
% - Disco Duro: 1TB SSD NVMe