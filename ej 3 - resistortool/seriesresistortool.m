
function [ r1, r2, error ] = seriesresistortool( r, values, minres, maxres )
% devuelve dos valores de r1 y r2 tales que error = |(r - (r1+r2))/r|
% esta minimizado, y r1,r2 son:
%   - mayores o iguales a MIN_RES
%   - menores o iguales a MAX_RES
%   - son iguales a Nx10^n, donde N pertenece al arreglo 'values'
%
%  si el argumento r no es un arreglo de 1x1, o si su valor no es positivo
% devuelve -1 en todos los argumentos de salida. lo mismo si values no es 
% un vector no vacio, o contiene numeros por fuera de [1,10)

if size(size(r),2) ~= 2 || size(r, 1) ~= 1 || size(r,2) ~= 1 ||...
        r <= 0 || isempty(values) || size(size(values),2) ~= 2 ...
        || size(values,1) ~= 1 || min(values)<1 || max(values)>=10 ...
        || minres <= 0 || maxres <= minres
    r1 = -1; r2 = -1; error = -1;
   return;
end

magr = magorder(r);
n = size(values, 2);
R1 = 0; R2 = 0;
error = +inf;
values = unique(values); % saco los repetidos
values = sort(values);

for exp1 = magr-1:magr
% al menos una de las resistencias debe ser del mismo orden de magnitud
% que r, o a lo sumo un orden menos 
    for i=1:n
    % voy probando con todos los valores que puede tomar R1 en este orden
        R1 = values(i)*10^exp1;
        if R1 >= minres && R1 <= maxres
            if R1 < r
                magdif = magorder(abs(r-R1)); % si r<R1 no sirve
                for j=1:n
                    R2 = values(j)*10^magdif;
                    
                    if R2 >= minres && R2 <= maxres
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

if R1 == 0 && R2 == 0
    r1 = 0; r2 = 0; error = 1;
end

        

end


