% Punto 6. Escriba una función que reciba dos listas [x1 x2 .. xn] y [y1 y2 .. yn]
% y devuelva su convolución simbólica, [x1#yn x2#yn-1 .. xn#y1]. La función debe ser
% recursiva por la cola y no realizar más de n invocaciones recursivas

% Definición Convolución: es una operación matemática aplicada a dos funciones,
% (f y g), tal que produzca una tercera función (f*g) expresando como la forma
% de una función es modificada con por la otra

declare Convolucion

fun {Convolucion LX LY}
   proc {ConvolucionRecur LX LY ?Result1}
      case LX of nil then ?Result1 = nil
      [] LXH | LXT then
	 case LY of LYH | LYT then ?Result2 in
	    ?Result1 = LXH # LYH | ?Result2
	    {ConvolucionRecur LXT LYT ?Result2} % LLamado recursivo por cola
	 end
      end
   end
in
   {ConvolucionRecur LX {List.reverse LY}} % Invertir orden de una de las dos listas antes de llamar la función
end


% Identificadores de variables:
% LX: lista [x1 x2 .. xn]
% LY: lista [y1 y2 .. yn]
% HLX: Head LX
% TLX: Tail LX

% Pruebas:
{Browse {Convolucion [m n a e i r d] [o a f c j s e]}}             % --> [m#e n#s a#j e#c i#f r#a d#o]
{Browse {Convolucion [m d l s p r d g a] [s m i a a y o e o]}}     % --> [m#o d#e l#o s#y p#a r#a d#i g#m a#s]
{Browse {Convolucion [0 1 2 3 4 5 6 7 8 9] [9 8 7 6 5 4 3 2 1 0]}} % --> [0#0 1#1 2#2 3#3 4#4 5#5 6#6 7#7 8#8 9#9]