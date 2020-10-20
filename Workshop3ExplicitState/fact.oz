% Punto 3. Función factorial utilizando celdas

declare Fact

fun {Fact N}
   Result = {NewCell 1} % El contenido de la celda Result inicia en 1
in
   for X in 2..N do
      Result := @Result * X % Se actualiza el contenido de la celda Result en cada iteración
   end
   @Result
end


% Pruebas:
{Browse {Fact 0}} % --> 1
{Browse {Fact 2}} % --> 2
{Browse {Fact 6}} % --> 720