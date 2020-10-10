% Punto 5. Procedimiento ForAllTail que aplica un procedimiento P a cada sublista no vacía de Xs

declare ForAllTail

proc {ForAllTail Xs P}
   if Xs.2 == nil then {P Xs} % Si el resto de la sublista actual es vacío, aplique por última vez el procedimiento sobre la sublista actual
   else
      {P Xs} % Aplicar procedimiento P a la sublista no vacía
      {ForAllTail Xs.2 P} % Iterar con el resto de la lista
   end
end


% Pruebas:
declare L = [0 1 2 3 4 5 6 7 8 9]

% Procedimiento que toma una lista y la imprime en pantalla
declare Proc1
proc {Proc1 L}
   {Browse L}
end

{ForAllTail L Proc1}

% Procedimiento que toma una lista, invierte su orden y la imprime en pantalla
declare Proc2
proc {Proc2 L}
   {Browse {List.reverse L}}
end

{ForAllTail L Proc2}

% Procedimiento que toma una lista, saca su primera posición y la imprime en pantalla
declare Proc3
proc {Proc3 L}
   {Browse L.1}
end

{ForAllTail L Proc3}