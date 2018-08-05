
function [ r1, r2, error ] = seriesresistortool( r, values, minr, maxr, N )
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
        r <= 0 || size(size(values),2) ~= 2 || size(values,1) ~= 1 || ...
        min(values)<1 || max(values)>=10 || minr <= 0 || maxr <= minr
    r1 = -1; r2 = -1; error = -1;
   return;
end

if size(size(N),2) ~= 2 || size(N, 1) ~= 1 || size(N,2) ~= 1 ||...
        N <= 0 || isnan(N) || N>100
    clearvar N;
    N = 1;
end

magr = magorder(r);
n = size(values, 2);
r1 = zeros(1,N); r2 = zeros(1,N);
%si la mejor aprox es con 0 no lo va a poner en el loop
error = ones(1, N)*(+inf); maxerror = +inf;
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
                magdif = magorder(abs(r-R1)); % si r<R1 no sirve
                for j=1:n
                    R2 = values(j)*10^magdif;
                    
                    if R2 >= minr && R2 <= maxr
                        abserror = abs((r-R1-R2)/r);
                        if (abserror < maxerror)
                            if isempty(ismember(find(r1==R2), find(r2==R1)))                    
                                k=find(error == maxerror);
                                if size(k,2)>1
                                    k=k(1);
                                end
            
                            r1(k) = R1; r2(k) = R2; error(k)=abserror;
                            maxerror = max(error);
                            end
                        end
                    end
                    
                    if R1+R2 > r
                        break;
                    end % si me pase paso al prox R1
                end
            else
                abserror = abs((r-R1)/r);
                 if (abserror < maxerror)
                            if isempty(ismember(find(r1==R2), find(r2==R1)))                             
                                k=find(error == maxerror);
                                if size(k,2)>1
                                    k=k(1);
                                end
            
                            r1(k) = R1; r2(k) = 0; error(k)=abserror;
                            maxerror = max(error);
                            end
                end
                break; %una vez que me pase de r ya no sigo
            end
        end
    end
end

if isempty(find(r1,1)) && isempty(find(r2,1))
%     if r<minr
        error = ones(1,N);
%     else
%         r1 = maxr; r2 = maxr; error = abs((r-2*maxr)/r);
%     end
end
     
end


