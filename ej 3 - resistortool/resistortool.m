function [ r1, r2, error, PorS ] = resistortool( r, tolerance, topology )
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

if size(size(r),2) ~= 2 || size(r, 1) ~= 1 || size(r,2) ~= 1 || r <= 0 
    r1 = -1; r2 = -1; error = -1; PorS = '-1';
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
minr = 0.5; maxr = 10*10^6;

PorS = 0;
if nargin == 3
    if topology == 'p'
        [r1, r2, error] = parallelresistortool(r, values, minr, maxr);
        PorS = 'p';
    elseif topology == 's'
        [r1, r2, error] = seriesresistortool(r, values, minr, maxr);
        PorS = 's';
    end
end

if PorS == 0
    [sr1, sr2, serror] = seriesresistortool(r, values, minr, maxr);
    [pr1, pr2, perror] = parallelresistortool(r, values, minr, maxr);
    
    if serror < perror
        r1 = sr1; r2 = sr2; error = serror; PorS = 's';
    else
        r1 = pr1; r2 = pr2; error = perror; PorS = 'p';
    end
end

end

