function [ c1, c2, error, PorS ] = capacitortool( c, tolerance, topology )
% CAPACITOR TOOL devuelve la mejor aproximacion al valor de c con los valores
% comerciales existentes para la tolerancia indicada y con la topologia 
% indicada (serie/paralelo)
%
%    si la tolerancia no se indica o no es valida, se asume 10%
%    si la topologia no se indica o no es valida se devuelve la que 
%  aproxime mejor el valor pedido
%    si el valor de c no es valido (<=0, o no es un unico numero) se 
% devuelve -1 en todos los resultados

if nargin == 0 %verifico si recibi c
    return;
end

if size(size(c),2) ~= 2 || size(c, 1) ~= 1 || size(c,2) ~= 1 || ~isreal(c)...
    || ~isnumeric(c) %verifico la validez del c que recibi
    c1 = -1; c2 = -1; error = -1; PorS = '-1';
   return;
end

t = 0;
if nargin >= 2
    if ~isempty(find([5, 10, 20]==tolerance(1),1))
        t = tolerance(1); % si me pasaron una tolerancia valida la uso
    end
end;
if t == 0
    t=10; %si no, uso 10%
end

values = commercialValuesGenerator(t); 
minc = 10^-6; maxc = 4700; % de 1pF a 4700uF

PorS = 0;
if nargin == 3 %si me pasan una topologia valida, uso esa
    if topology == 'p'
        [c1, c2, error] = parallelresistortool(c, values, minc, maxc);
        PorS = 'p';
    elseif topology == 's'
        [c1, c2, error] = seriesresistortool(c, values, minc, maxc);
        PorS = 's';
    end
end

if PorS == 0 %si no, uso la que menos error tenga
    [sr1, sr2, serror] = seriesresistortool(c, values, minc, maxc);
    [pr1, pr2, perror] = parallelresistortool(c, values, minc, maxc);
    
    if serror < perror
        c1 = sr1; c2 = sr2; error = serror; PorS = 's';
    else
        c1 = pr1; c2 = pr2; error = perror; PorS = 'p';
    end
end

%por si hubo un error de redondeo, verifico si me pasaron un valor
%comercial
if ~isempty(find(values == c/10^magorder(c), 1)) == true && c1 ~= c  ...
    && c<=maxc && c>=minc
    c1 = c; error = 0;
    if PorS == 'p'
        c2 = +inf;
    else
        c2 = 0;
    end
end

end

