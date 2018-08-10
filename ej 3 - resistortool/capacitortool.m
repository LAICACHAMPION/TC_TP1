function [ c1, c2, error, PorS ] = capacitortool( c, tolerance, topology )
% RESISTOR TOOL devuelve la mejor aproximacion al valor de r con los valores
% comerciales existentes para la tolerancia indicada y con la topologia 
% indicada (serie/paralelo)
%
%    si la tolerancia no se indica o no es valida, se asume 5%
%    si la topologia no se indica o no es valida se devuelve la que tenga
%  aproxime mejor el valor pedido
%    si el valor de r no es valido (<=0, o no es un unico numero) se 
% devuelve -1 en todos los resultados

if nargin == 0
    return;
end

if size(size(c),2) ~= 2 || size(c, 1) ~= 1 || size(c,2) ~= 1 || c <= 0 
    c1 = -1; c2 = -1; error = -1; PorS = '-1';
   return;
end

t = 0;
if nargin >= 2
    if ~isempty(ismember(tolerance,[1,2 ,5, 10]))
        t = tolerance; 
    end
end;
if t == 0
    t=5;
end

values = commercialValuesGenerator(t);
minc = 10^-6; maxc = 4700; % de 1pF a 4700uF

PorS = 0;
if nargin == 3
    if topology == 'p'
        [c1, c2, error] = seriesresistortool(c, values, minc, maxc);
        PorS = 'p';
    elseif topology == 's'
        [c1, c2, error] = parallelresistortool(c, values, minc, maxc);
        PorS = 's';
    end
end

if PorS == 0
    [sc1, sc2, serror] = parallelresistortool(c, values, minc, maxc);
    [pc1, pc2, perror] = seriesresistortool(c, values, minc, maxc);
    
    if serror < perror
        c1 = sc1; c2 = sc2; error = serror; PorS = 's';
    else
        c1 = pc1; c2 = pc2; error = perror; PorS = 'p';
    end
end

end

