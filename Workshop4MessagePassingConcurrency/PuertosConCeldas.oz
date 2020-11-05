% Punto 1. Implementando puertos con celdas

declare NuevoPuerto Enviar

% 1. NewPort definition: Create a new port with entry point P and stream S
fun {NuevoPuerto S}
   
   % TAD con estado y empaquetado
   P = {NewCell S} % Puerto en terminos de celda
   
   % Send definition: Append X to the stream corresponding to the entry point P
   proc {EnviarAux X}
      Flujo in       % Variable no ligada Flujo: _
      @P = X | Flujo % Crea la lista X|Flujo (i.e. X|_) y la liga con la anterior variable no ligada del puerto
      P := Flujo     % La pareja del puerto siempre es una variable no ligada Flujo: _
   end
in
   proc {$ Op} % Procedimiento de despacho
      case Op of enviar(X) then
	 {EnviarAux X}
      end
   end
end

% 2. Send definition: Append X to the stream corresponding to the entry point P
proc {Enviar P X}
   {P enviar(X)}
end


% Pruebas:
declare S P
P = {NuevoPuerto S} % Crear un nuevo puerto (P es un procedimiento con estado)
{Browse S}          % Imprimir el flujo del puerto
{Enviar P hola}     % Enviar mensajes al puerto
{Enviar P profe}
{Enviar P ':)'}