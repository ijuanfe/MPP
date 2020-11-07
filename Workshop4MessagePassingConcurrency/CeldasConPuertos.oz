% Punto 2. Implementando celdas con puertos

declare NuevaCelda Acceder Asignar

% Cell definition: Create a new cell C with initial content X
fun {NuevaCelda X} % Función que retorna un objeto puerto
   
   % Función que simula el comportamiento de las operaciones una celda
   fun {CeldaOp Op Estado}
      case Op
      of acceder(N) then N = Estado % X = @C: Bind X to the current content of cell C
      [] asignar(N) then N          % C := X: Set X to be the new content of cell C
      end
   end
   
   proc {MsgLoop S1 Estado}
      case S1 of Op | S2 then
	 {MsgLoop S2 {CeldaOp Op Estado}}
      [] nil then skip
      end
   end
   Sin
in
   thread {MsgLoop Sin X} end
   {NewPort Sin}
end

% Procedimiento que sirve de interfaz para acceder al contenido de una celda
proc {Acceder C X}
   {Send C acceder(X)}
end

% Procedimiento que sirve de interfaz para cambiar el contenido de una celda
proc {Asignar X C}
   {Send C asignar(X)}
end


% Pruebas:
declare Celda1 Out1 Out2
Celda1 = {NuevaCelda hola} % Crear una nueva celda con un valor inicial (Celda1 es un puerto)
{Acceder Celda1 Out1}      % Acceder al contenido de la celda
{Browse Out1}              % Retornar el contenido de la celda

{Asignar profe Celda1} % Cambiar el contenido de la celda
{Acceder Celda1 Out2}  % Acceder al nuevo contenido de la celda
{Browse Out2}          % Verificar el nuevo contenido de la celda

{Asignar ':)' Celda1}
{Browse {Acceder Celda1}} % {Browse @Celda1}