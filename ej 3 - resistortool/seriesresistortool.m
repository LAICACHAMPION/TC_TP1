
function [ r1, r2, error ] = seriesresistortool( r, values, minr, maxr )
% devuelve dos valores de r1 y r2 tales que error = |(r - (r1+r2))/r|
% esta minimizado, y r1,r2 son:
%   - mayores o iguales a MIN_RES
%   - menores o iguales a MAX_RES
%   - son iguales a Nx10^n, donde N pertenece al arreglo 'values'
%
%  si el argumento r no es un arreglo de 1x1, o si su valor no es positivo
% devuelve -1 en todos los argumentos de salida. lo mismo si values no es 
% un vector no vacio, o contiene numeros por fuera de [1,10)

if isempty(values) || size(size(values),2) ~= 2 || size(values,1) ~= 1 ...
    || minr <= 0 || maxr <= minr || r <= 0 || isnan(r) 
    r1 = -1; r2 = -1; error = -1;
    return;
end

if min(values)<1 || max(values)>=10
    r1 = -1; r2 = -1; error = -1;
    return;
end
   
magr = magorder(r);
maxorder = magorder(maxr);
if 10^magr > maxr           % si me paso de maxr, uso lo mas grande que 
    magr = maxorder;        % pueda
end

n = size(values, 2);
r1 = 0; r2 = 0; %si la mejor aprox es con 0 no lo va a poner en el loop
error = +inf;
values = unique(values); % saco los repetidos
values = sort(values);

for exp1 = magr-1:magr
% al menos una de las resistencias debe ser del mismo orden de magnitud
% que r, o a lo sumo un orden menos 
    for i=1:n
    % voy probando con todos los valores que puede tomar R1 en este orden
        R1 = values(i)*10^exp1;
        if R1 >= minr && R1 <= maxr
            if R1 < r 
                magdif = min(maxorder,magorder(abs(r-R1))); 
                for j=1:n
                    R2 = values(j)*10^magdif;
                    
                    if R2 >= minr && R2 <= maxr
                        abserror = abs((r-R1-R2)/r);
                        if (abserror < error)
                            error = abserror;
                            r1 = R1; r2 = R2;
                        end
                    end
                    
                    if R1+R2 > r
                        break;
                    end % si me pase paso al prox R1
                end
            else
                abserror = abs((r-R1)/r);
                    if (abserror < error)
                        error = abserror;
                        r1 = R1; r2 = 0;
                    end
                break; %una vez que me pase de r ya no sigo
            end
        end
    end
end

if r1 == 0 && r2 == 0
    error = 1;
end
     
end


