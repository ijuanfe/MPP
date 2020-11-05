% Punto 4.a. Portero

declare NuevoObjetoPuerto Portero

% Función que retorna un objeto puerto
fun {NuevoObjetoPuerto Comp Inic}
   proc {MsgLoop S1 Estado}
      case S1 of Msg | S2 then
	 {MsgLoop S2 {Comp Msg Estado}} % Función Comp (Portero) calcula el nuevo estado
      [] nil then skip
      end
   end
   Sin
in
   thread {MsgLoop Sin Inic} end
   {NewPort Sin}
end

% Función que simula el comportamiento del portero
fun {Portero Msg Estado}
   case Msg
   of getIn(N)    then Estado + N
   [] getOut(N)   then Estado - N
   [] getCount(N) then N = Estado
   end
end


% Pruebas:
declare ObjPuerto
ObjPuerto = {NuevoObjetoPuerto Portero 0} % Estado inicial: 0

declare Out1 Out2
{Send ObjPuerto getIn(15)}      % 15 personas entran al concierto
{Send ObjPuerto getCount(Out1)} % Obtener las personas actuales en el concierto
{Browse Out1}                   % --> 15
{Send ObjPuerto getOut(7)}      % 7 personas se van del concierto
{Send ObjPuerto getCount(Out2)} % Obtener las personas actuales en el concierto
{Browse Out2}                   % --> 8