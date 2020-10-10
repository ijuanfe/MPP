% Punto 2. Reescribir la función utilizando notación procedimental

% Función que retorna el máximo número de una lista de enteros:
%declare Max
%fun {Max L}
%   fun {MaxLoop L M}
%      case L of nil then M
%      [] H|T then
%	 if M > H then {MaxLoop T M} else {MaxLoop T H} end
%      end
%   end
%in
%   if L == nil then error
%   else {MaxLoop L.2 L.1} end
%end

% Función Max reescrita utilizando notación procedimental:
declare Max

proc {Max L ?ResultMax}
   local MaxLoop = proc {$ L M ?ResultMaxLoop}  % L: Tail, M: Head
		      case L of nil then ?ResultMaxLoop = M
		      [] H | T then
			 if M > H then {MaxLoop T M ?ResultMaxLoop}
			 else {MaxLoop T H ?ResultMaxLoop} end
		      end
		   end
   in
      if L == nil then ?ResultMax = error
      else {MaxLoop L.2 L.1 ?ResultMax} end
   end
end


% Pruebas:
{Browse {Max [5 1 6 3 2 0 8 9 7 4]}}           % --> 9
{Browse {Max [13 21 50 4 11 0 35 91 70 43]}}   % --> 91
{Browse {Max [1321 2123 4189 3980 2781 2911]}} % --> 4189