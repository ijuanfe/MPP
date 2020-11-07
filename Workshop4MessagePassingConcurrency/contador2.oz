% Punto 4.b. Contador con objeto puerto

declare Counter

% Función que retorna un objeto puerto (servidor-contador)
fun {Counter Output}
   
   % Procedimiento que simula el comportamiento del servidor-contador
   proc {Servidor S1 Estado}
      case S1 of Key | S2 then
	 {Servidor S2 {Comp Key Estado}}
      [] nil then skip
      end
   end
   
   % Función que calcula el nuevo estado del conteo: lo retorna como resultado y también como estado nuevo del servidor
   fun {Comp Key Estado}
      NuevoEstado in
      NuevoEstado = {Incr Key Estado} % Calcular siguiente estado (Dict)
      {Send PuertoSalida NuevoEstado} % 1. Enviar el nuevo estado al puerto de salida
      NuevoEstado                     % 2. Retornar el nuevo estado al servidor
   end
   
   % Función auxiliar que añade o suma la ocurrencia de un caracter en un diccionario
   fun {Incr Key Dict} % Key: valor a añadir al estado, Dict: estado
      case Dict
      of nil then [Key#1]
      [] K#V | Tail andthen K == Key then Key#V+1 | Tail
      [] K#V | Tail andthen K > Key  then Key#1 | K#V | Tail
      [] K#V | Tail andthen K < Key  then K#V | {Incr Key Tail}
      end
   end
   PuertoSalida = {NewPort Output} % Puerto salida servidor: por el cual se retorna el resultado de cada conteo (estado) al Output
   Sin                             % Flujo entrada servidor: por el cual el servidor recibe los caracteres enviados por los clientes
in
   thread {Servidor Sin nil} end % El servidor-contador se ejecuta en un hilo independiente con estado inicial nil
   {NewPort Sin}
end

declare Contador Output
Contador = {Counter Output} % Crear servidor-contador (Contador es un objeto puerto)
{Browse Output}             % Retornar resultado del conteo actual de caracteres


% Simulación de clientes con hilos

% Pool de caracteres (alfabeto español)
declare Pool PoolLength
Pool = [a b c d e f g h i j k l m n ñ o p q r s t u v w x y z] % 27 posibles letras (atomos)
PoolLength = {List.length Pool}

declare Cliente1 Cliente2 Cliente3

Cliente1 = {New Time.repeat
	   setRepAll(action: % Procedimiento que genera un número aleatorio para seleccionar una letra y enviarla al puerto del servidor
			proc {$}
			   local Pos Letra in
			      Pos = {OS.rand} mod PoolLength+1 % Generar número aleatorio entre 1 y 27
			      Letra = {List.nth Pool Pos}      % Seleccionar una letra del Pool en la posición aleatoria
			      {Send Contador Letra}            % Enviar letra al puerto de entrada del servidor-contador
			   end
			end
		     delay: 5000)} % Enviar letra cada 5 segundos

Cliente2 = {New Time.repeat
	   setRepAll(action:
			proc {$}
			   local Pos Letra in
			      Pos = {OS.rand} mod PoolLength+1
			      Letra = {List.nth Pool Pos}
			      {Send Contador Letra}
			   end
			end
		     delay: 5000)}

Cliente3 = {New Time.repeat
	   setRepAll(action:
			proc {$}
			   local Pos Letra in
			      Pos = {OS.rand} mod PoolLength+1
			      Letra = {List.nth Pool Pos}
			      {Send Contador Letra}
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