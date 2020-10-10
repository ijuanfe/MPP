% Punto 9. Método de Newton Genérico

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Punto a. Función Derivar
declare Derivar

fun {Derivar F A}

   % Función que identifica la fórmula a derivarse: Número (Float), Atom (Variable) y Tuple (Operación)
   fun {DerivarAux F A}
      if     {Float.is F} then {DerivarConst F}
      elseif {Atom.is F}  then {DerivarVar F A}
      elseif {Tuple.is F} then {IdentificarTupla F A}
      else error end
   end

   % Función que identifica el caso de derivación para la tupla (operación)
   fun {IdentificarTupla F A}
      if     {Record.label F} == s then {DerivarSuma F A}
      elseif {Record.label F} == r then {DerivarResta F A}
      elseif {Record.label F} == m then {DerivarMul F A}
      elseif {Record.label F} == d then {DerivarDiv F A}
      elseif {Record.label F} == e then {DerivarExp F A}
      elseif {Record.label F} == l then {DerivarLN F A}
      else error end
   end
   
   % Reglas de derivación
   fun {DerivarConst F}
      0.0
   end
   
   fun {DerivarVar F A}
      if F == A then 1.0 % Si la fórmula F se deriva con respecto a A (Variable F == Derivar A), entonces derivarla
      else {DerivarConst F} end % De lo contrario, F se considera como una constante
   end
   
   fun {DerivarSuma F A}
      s({DerivarAux F.1 A} {DerivarAux F.2 A})
   end
   
   fun {DerivarResta F A}
      r({DerivarAux F.1 A} {DerivarAux F.2 A})
   end
   
   fun {DerivarMul F A}
      s(m({DerivarAux F.1 A} F.2) m(F.1 {DerivarAux F.2 A}))
   end
   
   fun {DerivarDiv F A}
      d(r(m({DerivarAux F.1 A} F.2) m(F.1 {DerivarAux F.2 A})) e(F.2 2))
   end
   
   fun {DerivarLN F A}
      d({DerivarAux F.1 A} F)
   end
   
   fun {DerivarExp F A}
      m(F s(d(m({DerivarAux F.1 A} F.2) F.1) m({DerivarAux F.2 A} l(F.1))))
   end
in
   {DerivarAux F A}
end


% Pruebas:
{Browse {Derivar m(5.0 k) x}}
{Browse {Derivar m(3.0 e(x 2.0)) x}}
{Browse {Derivar s(m(5.0 k) d(l(3.0) e(r(8.0 x) x))) x}}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Punto b. Función Evaluar
declare Evaluar

fun {Evaluar F A V}

   % Función que identifica la fórmula a evaluarse
   fun {EvaluarAux F A V}
      if     {Float.is F} then F % Retornar el número
      elseif {Atom.is F}  then V % Reemplazar el valor V por la variable A
      elseif {Tuple.is F} then {AplicarOperacion F A V}
      else error end
   end

   % Función que identifica y aplica el caso de operación de la tupla
   fun {AplicarOperacion F A V}
      if     {Record.label F} == s then {Suma F A V}
      elseif {Record.label F} == r then {Resta F A V}
      elseif {Record.label F} == m then {Mul F A V}
      elseif {Record.label F} == d then {Div F A V}
      elseif {Record.label F} == e then {Exp F A V}
      elseif {Record.label F} == l then {LN F A V}
      else error end
   end
   
   % Casos de operaciones
   fun {Suma F A V}
      {EvaluarAux F.1 A V} + {EvaluarAux F.2 A V}
   end
   
   fun {Resta F A V}
      {EvaluarAux F.1 A V} - {EvaluarAux F.2 A V}
   end
   
   fun {Mul F A V}
      {EvaluarAux F.1 A V} * {EvaluarAux F.2 A V}
   end
   
   fun {Div F A V}
      {EvaluarAux F.1 A V} / {EvaluarAux F.2 A V}
   end
   
   fun {Exp F A V}
      {Number.pow {EvaluarAux F.1 A V} F.2}
   end
   
   fun {LN F A V}
      {Float.log {EvaluarAux F.1 A V}}
   end
in
   {EvaluarAux F A V}
end


% Pruebas:
{Browse {Evaluar d(2.0 x) x 4.0}}
{Browse {Evaluar m(3.0 e(x 2.0)) x 3.0}}
{Browse {Evaluar s(4.0 r(d(6.0 x) m(3.0 x))) x 4.0}}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Punto d. Función Raiz
declare Raiz BuenaAprox

fun {Raiz F X0 BuenaAprox}
   local Xn A = x in % Evaluar y derivar con respecto a x
      Xn = X0 - ({Evaluar F A X0} / {Evaluar {Derivar F A} A X0}) % Método de Newton
      if {BuenaAprox F Xn} then true % Si halla una buena aproximación, entonces detenerse
      else {Raiz F Xn BuenaAprox} end % De lo contrario, siga iterando para aproximarse más a la raiz
   end
end

% Función anónima para determinar si ya se tiene una buena aproximación de una raiz
BuenaAprox = fun {$ F1 V}
		local A = x in
		   if {Evaluar F1 A V} < 0.0001 then true % Buena aproximación si raiz < 0.0001
		   else false end
		end
	     end

% Pruebas:
{Browse {Raiz m(3.0 e(x 2.0)) 3.0 BuenaAprox}}


% Notas muy importantes:

% 1. Se asume que la fórmula siempre se evalúa y deriva con respecto a 'x'.
% Se infiere que se trata de 'x', ya que el valor inicial contiene una 'x': X0
% Esto lo traigo a colación ya que en los argumentos de las funciones "Raiz" y "BuenaAprox"
% no se especifica la variable sobre la cual derivar y quise ceñirme estrictamente al enunciado.
% De igual manera la función "Derivar" puede derivar sobre cualquier variable, sólo haría falta
% modificar la función "Raiz" para que evalúe y derive con respecto a la variable deseada.

% 2. Se establece que una raiz menor a 0.0001 es una buena aproximación.

% 3. La función "Limpiar", correspondiente al punto c, consideré dejarla para la etapa de correcciones del taller,
% argumentando que la función "Evaluar" permite realizar los cálculos sin necesidad de tener que hacer una limpieza
% de estos registros. Es de notar que computacionalmente es más costoso iterar sobre un registro colmado de ceros no
% necesarios, pero me pregunto si: ¿limpiar un registro de ceros no necesarios para luego procesarla no tendría el mismo
% costo computacional que evaluar la fórmula como está? Creo que es una buena discusión que hay que realizar en clase.