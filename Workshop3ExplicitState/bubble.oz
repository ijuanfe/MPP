% Punto 5. Algoritmo de ordenamiento BubbleSort utilizando celdas

declare BubbleSort

fun {BubbleSort L}

   % Declaración de celdas
   HN = {NewCell nil}     % Celda que contiene el número a ser comparado para ordenarse
   Result = {NewCell nil} % Celda que contiene el resultado (lista) de los movimientos del ordenamiento
   End = {NewCell nil}    % Celda auxiliar para determinar si ya está ordenada la lista (para verificar última iteración)
   
   fun {BubbleSortAux L}
      
      % Inicializando celdas (variables) para una nueva iteración
      HN := L.1 % Cabeza de la lista (número a comparar)
      Result := nil
      End := true

      % Ciclo donde ocurre la creación y ordenamiento de la lista
      for X in L.2 do % Iterar sobre el resto de la lista
	 if @HN > X then
	    Result := {List.append @Result [X]}   % Si el valor de la cabeza es mayor, entonces concatenar el siguiente número en la lista (cabeza HN queda igual)
	    End := false                          % No puede terminar aún porque realizó un movimiento de ordenamiento
	 else
	    Result := {List.append @Result [@HN]} % Si el valor de la cabeza no es mayor, entonces concatenarlo en la lista ..
	    HN := X                               % .. y cambiar su valor al siguiente número de la lista (mover la cabeza HN)
	 end
      end

      % Para cualquiera de los casos la cabeza siempre queda para concatenarse al final
      Result := {List.append @Result [@HN]}

      % Si se realiza al menos un movimiento de ordenamiento, entonces iterar de nuevo con el resultado actual
      if @End == false then
	 {BubbleSortAux @Result}
      else % Si no realiza ningún movimiento de ordenamiento, i.e. ya está ordenado, entonces retorne el resultado
	 @Result
      end
   end
in
   {BubbleSortAux L}
end


% Pruebas:
{Browse {BubbleSort [10 9 8 7 6 5 4 3 2 1 0]}}
{Browse {BubbleSort [10 1 9 2 8 3 7 4 6 5]}}
{Browse {BubbleSort [22 7 5 50 43 135 155 1124 1240 12 14 1 0]}}