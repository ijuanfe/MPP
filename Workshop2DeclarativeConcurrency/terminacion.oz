% Punto 7. Función Wait: sincronizando terminación de hilos

declare
L1 L2 L3 L4 L2T L3T L4T %L5
L1 = [1 2 3]
thread L2 = {Map L1 fun {$ X} {Delay 200} X*X end} L2T = true end
thread L3 = {Map L1 fun {$ X} {Delay 200} 2*X end} L3T = true end
thread L4 = {Map L1 fun {$ X} {Delay 200} 3*X end} L4T = true end

% Solución 3:
%{Wait L2T}
%{Wait L3T}
%{Wait L4T}

% Las condiciones de la declaración if se suspenden hasta que L2T, L3T y L4T sean ligados (true)
if L2T andthen L3T andthen L4T then
   %L5 = true % Solución 2
   {Show L2#L3#L4}
end

% Solución 2
%{Wait L5}
%{Show L2#L3#L4}