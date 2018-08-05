function [ r1, r2, error ] = parallelresistortool( r, values, minres, maxres )
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
        || minres <= 0 || maxres <= minres
    r1 = -1; r2 = -1; error = -1;
   return;
end




adm = 1/sym(r); maxadm = 1/sym(minres); minadm = 1/sym(maxres);
values = unique(values); % saco los repetidos
values = sym(values); % n\in[1,10) => (n^-1)\in(0,1]
values = values.^-1 *10;
sort(values);
if(values(1) == 10)
    values(1) = 1; %si estaba el 1 tengo que corregir esto
end

[ adm1, adm2, error ] = seriesresistortool(adm, values, minadm, maxadm);

if adm1 == -1
    r1 = -1; r2 = -1; error = -1;
else
    r1 = double(1/adm1); r2 = double(1/adm2);
    error = double(abs((r - (1/r1+1/r2)^-1)/r));
end
end
