function [ r1, r2, error ] = parallelresistortool( r, values, minr, maxr, N )
% devuelve dos valores de r1 y r2 tales que error = |(r - (r1//r2))/r|
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
        || minr <= 0 || maxr <= minr
    r1 = -1; r2 = -1; error = -1;
   return;
end

adm = 1/r; maxadm = 1/minr; minadm = 1/maxr;
values = unique(values); % saco los repetidos

commvalue = ~isempty(ismember(r/10^magorder(r), values));

values = values.^-1 *10;
sort(values);
if(values(1) == 10)
    values(1) = 1; %si estaba el 1 tengo que corregir esto
end

[ adm1, adm2 ] = seriesresistortool(adm, values, minadm, maxadm, N);

if adm1 == -1
    r1 = -1; r2 = -1; error = -1;
else
    r1 = min(adm1.^-1, maxr); % por si devuelve admitancia 0
    r2 = adm2.^-1; % en este caso r2 puede ser inf
    error = abs((r - (r1.^-1+r2.^-1).^-1)/r);
    
    if commvalue == true && isempty(ismember(find(r1==r), find(r2==maxr)))  
        
        k=find(error == max(error));
        if size(k,2)>1
            k=k(1);
        end
            
        r1(k) = r; r2(k) = inf; error(k) = 0;
    return;
    end
end
end

