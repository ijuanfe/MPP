% Punto 3. Contador con múltiples clientes

% 1. Simulación del servidor (contador de caracteres)

declare PuertoEntradaServidor in % Se deja el puerto de entrada 'público' para poder servir de canal de comunicación entre clientes y servidor

% Inicializar servidor
local FlujoEntradaServidor FlujoSalidaServidor PuertoSalidaServidor Incr RetornarEstado MsgLoop in
   
   % Función auxiliar que añade o suma la ocurrencia de un caracter en un diccionario
   fun {Incr Key Dict} % Dict: estado, Key: valor a añadir al estado
      case Dict
      of nil then [Key#1]
      [] K#V | Tail andthen K == Key then Key#V+1 | Tail
      [] K#V | Tail andthen K > Key  then Key#1 | K#V | Tail
      [] K#V | Tail andthen K < Key  then K#V | {Incr Key Tail}
      end
   end
   
   % Función que envía el conteo actual por el flujo de salida del servidor y actualiza el estado del servidor
   fun {RetornarEstado NuevoEstado}
      {Send PuertoSalidaServidor NuevoEstado} % Se envía el resultado por el puerto de salida del servidor
      NuevoEstado                             % Se retorna el nuevo estado al mismo servidor
   end
   
   % Función que actualiza el estado del servidor por el flujo de entrada y envía el resultado al flujo de salida
   proc {MsgLoop S1 Estado}
      case S1 of Msg | S2 then
	 {MsgLoop S2 {RetornarEstado {Incr Msg Estado}}}
      [] nil then skip
      end
   end
   
   thread {MsgLoop FlujoEntradaServidor nil} end        % Simulador del servidor (contador) en un hilo independiente con estado inicial nil
   {NewPort FlujoEntradaServidor PuertoEntradaServidor} % Puerto entrada del servidor (comunicación entre clientes y servidor)
   {NewPort FlujoSalidaServidor PuertoSalidaServidor}   % Puerto de salida del servidor (resultados del contador)
   {Browse FlujoSalidaServidor}                         % Retornar flujo de salida
end


% 2. Simulación de clientes con hilos

% Pool de caracteres (alfabeto español)
declare Pool PoolLength
Pool = [a b c d e f g h i j k l m n ñ o p q r s t u v w x y z] % 27 posibles letras (atomos)
PoolLength = {List.length Pool}

declare Cliente1 Cliente2 Cliente3

Cliente1 = {New Time.repeat
	   setRepAll(action: % Procedimiento que genera un número aleatorio para seleccionar una letra y enviarla al puerto del servidor
			proc {$}
			   local Pos Letra in
			      Pos = {OS.rand} mod PoolLength+1   % Generar número aleatorio entre 1 y 27
			      Letra = {List.nth Pool Pos}        % Seleccionar una letra del Pool en la posición aleatoria
			      {Send PuertoEntradaServidor Letra} % Enviar letra al puerto de entrada del servidor-contador
			   end
			end
		     delay: 5000)} % Enviar letra cada 5 segundos

Cliente2 = {New Time.repeat
	   setRepAll(action:
			proc {$}
			   local Pos Letra in
			      Pos = {OS.rand} mod PoolLength+1
			      Letra = {List.nth Pool Pos}
			      {Send PuertoEntradaServidor Letra}
			   end
			end
		     delay: 5000)}

Cliente3 = {New Time.repeat
	   setRepAll(action:
			proc {$}
			   local Pos Letra in
			      Pos = {OS.rand} mod PoolLength+1
			      Letra = {List.nth Pool Pos}
			      {Send PuertoEntradaServidor Letra}
			   end
			end
		     delay: 5000)}

% Procedimiento para iniciar envío de caracteres de los clientes
declare IniciarClientes
proc {IniciarClientes}
   thread {Cliente1 go()} end
   thread {Cliente2 go()} end
   thread {Cliente3 go()} end
end

% Procedimiento para detener el envío de caracteres de los clientes
declare DetenerClientes
proc {DetenerClientes}
   {Cliente1 stop()}
   {Cliente2 stop()}
   {Cliente3 stop()}
end

{IniciarClientes} % Iniciar envío de caracteres
{DetenerClientes} % Detener envío de caracteres