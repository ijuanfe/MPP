% Punto 5. Foo vs Bar: Consumidor y Productor de Cerveza

declare Bar

% Procedimiento que simula el agente Bar que sirve cervezas (Hilo Productor)
proc {Bar N Xs}
   case Xs of X | Xr then
      {Delay 3000} % Bar puede servir una cerveza cada 3 segundos
      X = N
      {Bar N+1 Xr}
   end
end

declare Foo

% Función que simula el agente Foo que consume cervezas (Hilo Consumidor)
fun {Foo ?Xs A Limit}
   {Delay 24000} % Foo puede consumir media cerveza cada 12 segundos (12ms). Cerveza completa: 12ms*2 = 24ms
   if Limit > 0 then
      X | Xr = Xs
   in
      {Foo Xr A+1 Limit-1}
   else A end
end

declare MemIntermedia

% Procedimiento que simula el Buffer (Memoria Intermedia) que controla la Producción y Consumo de cervezas
proc {MemIntermedia N ?Xs Ys}

   % Función que inicia la producción de Bar
   fun {Iniciar N ?Xs}
      if N == 0 then Xs
      else Xr in Xs = _ | Xr {Iniciar N-1 Xr} end
   end

   % Procedimiento que atiende las peticiones del consumidor Foo con el buffer actual
   proc {CicloAtender Ys ?Xs ?Final}
      case Ys of Y | Yr then Xr Final2 in
	 Xs = Y | Xr        % Obtener cerveza del buffer
	 Final = _ | Final2 % Rellenar el buffer (Bar sirve más cervezas)
	 {CicloAtender Yr Xr Final2}
      end
   end
   Final = {Iniciar N Xs}
in
   {CicloAtender Ys Xs Final}
end

local Xs Ys S in
   thread {Bar 1 Xs} end              % Hilo Productor (Servidor de cervezas Bar)
   thread {MemIntermedia 5 Xs Ys} end % Hilo Buffer (Memoria Intermedia)
   thread S = {Foo Ys 0 150} end      % Hilo Consumidor (Consumidor de cervezas Foo)
   {Browse Xs}
   {Browse Ys}
   {Browse S} % Cantidad total de cervezas tomadas por Foo
end