% Punto 2. Objetos evaluadores: Polimorfismo

% Polimorfismo: igual interfaz para cualquier implementación

declare Expresion

% Los métodos de la superclase Expresion (inic y evaluar) serán
% anulados (overrides) por todas las clases que heredan de ella
class Expresion          % Superclase
   attr res              % Toda expresión tiene un resultado que la representa
   meth inic skip end    % Toda clase (y también expresión) tiene un método inicializador
   meth evaluar skip end % Toda expresión tiene un método para poder ser evaluado su resultado
end

class Constante from Expresion % Se puede acceder (evaluar) al valor de una constante más no modificarse
   meth inic(Valor)
      res := Valor
   end
   meth evaluar(?X)
      ?X = @res
   end
end

class Variable from Constante % Una variable se puede ver como una constante pero que se puede modificar
   meth asg(Valor)
      res := Valor
   end
end


% Operaciones algebraicas

class Operacion from Expresion % También se comporta como superclase de las operaciones algebraicas
   attr valExp1 valExp2
   meth inic(Exp1 Exp2)
      valExp1 := Exp1
      valExp2 := Exp2
   end
end

class Suma from Operacion
   meth evaluar(?X)
      res := {@valExp1 evaluar($)} + {@valExp2 evaluar($)}
      ?X = @res
   end
end

class Diferencia from Operacion
   meth evaluar(?X)
      res := {@valExp1 evaluar($)} - {@valExp2 evaluar($)}
      ?X = @res
   end
end

class Producto from Operacion
   meth evaluar(?X)
      res := {@valExp1 evaluar($)} * {@valExp2 evaluar($)}
      ?X = @res
   end
end

class Potencia from Operacion
   meth evaluar(?X)
      res := {Number.pow {@valExp1 evaluar($)} @valExp2}
      ?X = @res
   end
end


% Pruebas:
declare
VarX = {New Variable inic(0)}
VarY = {New Variable inic(0)}
local
   ExprX2 = {New Potencia inic(VarX 2)}
   Expr3 = {New Constante inic(3)}
   Expr3X2 = {New Producto inic(Expr3 ExprX2)}
   ExprXY = {New Producto inic(VarX VarY)}
   Expr3X2mXY = {New Diferencia inic(Expr3X2 ExprXY)}
   ExprY3 = {New Potencia inic(VarY 3)}
in
   Formula = {New Suma inic(Expr3X2mXY ExprY3)} % Fórmula: 3x^2 - xy + y^3
end

{VarX asg(7)}
{VarY asg(23)}
{Browse {Formula evaluar($)}} % --> 12153

{VarX asg(5)}
{VarY asg(8)}
{Browse {Formula evaluar($)}} % --> 547