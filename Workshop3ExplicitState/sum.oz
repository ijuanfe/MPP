% Punto 2. Suma iterativa de elementos entre A y B inclusivos utilizando celdas

declare Q

fun{Q A B}
   Sum = {NewCell 0} % El contenido de la celda Sum inicia en 0
in
   for X in A..B do
      Sum := @Sum + X % Se actualiza el contenido de la celda Sum en cada iteración
   end
   @Sum
end


% Pruebas:
{Browse {Q 1 5}}  % --> 15
{Browse {Q 7 9}}  % --> 24
{Browse {Q 10 5}} % --> 0