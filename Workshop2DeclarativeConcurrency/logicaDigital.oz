% Punto 6. Simulación de la lógica digital

% Punto 6.c.
declare Simulate

fun {Simulate G Ss}
   
   % Punto 6.a.
   % Función que simula la compuerta Not
   fun {CompuertaNot Xs}
      fun {Not Xs}
	 case Xs of X|Xr then (1-X) | {Not Xr} end
      end
   in
      thread {Not Xs} end
   end
   
   % Punto 6.b.
   % Función que simula la compuerta And
   fun {CompuertaAnd Xs Ys}
      fun {And Xs Ys}
	 case Xs#Ys of (X|Xr)#(Y|Yr) then (X*Y) | {And Xr Yr} end
      end
   in
      thread {And Xs Ys} end
   end
   
   % Punto 6.b.
   % Función que simula la compuerta Or
   fun {CompuertaOr Xs Ys}
      fun {Or Xs Ys}
	 case Xs#Ys of (X|Xr)#(Y|Yr) then X+Y-X*Y | {Or Xr Yr} end
      end
   in
      thread {Or Xs Ys} end
   end

   % Punto 6.d.
   % Función que simula la compuerta Xor
   fun {CompuertaXor Xs Ys}
      fun {Xor Xs Ys}
	 case Xs#Ys of (X|Xr)#(Y|Yr) then X+Y-2*X*Y | {Xor Xr Yr} end
      end
   in
      thread {Xor Xs Ys} end
   end
   
   % Función que identifica el tipo de gate
   fun {SimulateAux G}
      if {Value.hasFeature G value} == false  then Ss.{Value.'.' G 1} % Si es un input retornar su valor asociado al registro de inputs (Ss)
      elseif {Value.'.' G value}    == 'not'  then thread {CompuertaNot {SimulateAux {Value.'.' G 1}}} end
      elseif {Value.'.' G value}    == 'and'  then thread {CompuertaAnd {SimulateAux {Value.'.' G 1}} {SimulateAux {Value.'.' G 2}}} end
      elseif {Value.'.' G value}    == 'or'   then thread {CompuertaOr  {SimulateAux {Value.'.' G 1}} {SimulateAux {Value.'.' G 2}}} end
      elseif {Value.'.' G value}    == 'xor'  then thread {CompuertaXor {SimulateAux {Value.'.' G 1}} {SimulateAux {Value.'.' G 2}}} end
      else error end
   end
in
   {SimulateAux G}
end


% Punto 6.d.

declare SumadorCompleto
proc {SumadorCompleto InputCS ?ResultC ?ResultS}
   proc {SumadorCompletoAux Cg Sg InputCS ?ResultCa ?ResultSa}
      thread ?ResultCa = {Simulate Cg InputCS} end
      thread ?ResultSa = {Simulate Sg InputCS} end
   end
in
   local C S in
      C = gate(value:'or'
	       gate(value:'and'
		    input(x)
		    input(y))
	       gate(value:'or'
		    gate(value:'and' input(y) input(z))
		    gate(value:'and' input(x) input(z))))
      S = gate(value:'xor'
	       input(z)
	       gate(value:'xor'
		    input(x)
		    input(y)))
      {SumadorCompletoAux C S InputCS ?ResultC ?ResultS}
   end
end


% Prueba 1: Función Simulate en puntos A, B y C 
declare G = gate(value:'or'
		 gate(value:'and'
		      input(x)
		      input(y))
		 gate(value:'not'
		      input(z)))

{Browse {Simulate G input(x:1|0|1|0|_ y:0|1|0|1|_ z:1|1|0|0|_ )}}


% Prueba 2: Sumador Completo en Punto D
local ResultC ResultS InputCS = input(x:1|1|0|_ y:0|1|0|_ z:1|1|1|_) in
   {SumadorCompleto InputCS ResultC ResultS}
   {Browse InputCS # sum(ResultC ResultS)}
end