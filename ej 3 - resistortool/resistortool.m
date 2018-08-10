function [ r1, r2, error, PorS ] = resistortool( r, tolerance, topology )
% RESISTOR TOOL devuelve la mejor aproximacion al valor de r con los valores
% comerciales existentes para la tolerancia indicada y con la topologia 
% indicada (serie/paralelo)
%
%    si la tolerancia no se indica o no es valida, se asume 5%
%    si la topologia no se indica o no es valida se devuelve la que 
%  aproxime mejor el valor pedido
%    si el valor de r no es valido (<=0, o no es un unico numero) se 
% devuelve -1 en todos los resultados

if nargin == 0 %verifico que me hayan pasado r
    return;
end

if size(size(r),2) ~= 2 || size(r, 1) ~= 1 || size(r,2) ~= 1 || ~isreal(r)...
    || ~isnumeric(r) %verifico que r sea un valor valido
    r1 = -1; r2 = -1; error = -1; PorS = '-1';
   return;
end

t = 0;
if nargin >= 2 %si me pasan una tolerancia valida, la uso
    if ~isempty(find([5, 10, 20]==tolerance(1),1))
        t = tolerance(1);
    end
end;
if t == 0 % si no, uso 5%
    t=5;
end

values = commercialValuesGenerator(t);
minr = 0.1; maxr = 10*10^6; % de 0.1Ohm a 10MOhm

PorS = 0;
if nargin == 3 %si me pasan serie o paralelo, uso eso
    if topology == 'p'
        [r1, r2, error] = parallelresistortool(r, values, minr, maxr);
        PorS = 'p';
    elseif topology == 's'
        [r1, r2, error] = seriesresistortool(r, values, minr, maxr);
        PorS = 's';
    end
end

if PorS == 0 %si no, devuelvo lo que tenga menos error
    [sr1, sr2, serror] = seriesresistortool(r, values, minr, maxr);
    [pr1, pr2, perror] = parallelresistortool(r, values, minr, maxr);
    
    if serror < perror
        r1 = sr1; r2 = sr2; error = serror; PorS = 's';
    else
        r1 = pr1; r2 = pr2; error = perror; PorS = 'p';
    end
end

%verifico si r es un valor comercial por si hubo un error de redondeo
if ~isempty(find(values == r/10^magorder(r), 1)) == true && r1 ~= r ...
    && r<=maxr && r>=minr
    r1 = r; error = 0;
    if PorS == 'p'
        r2 = +inf;
    else
        r2 = 0;
    end
end

end
