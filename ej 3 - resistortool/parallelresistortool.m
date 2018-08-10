function [ r1, r2, error ] = parallelresistortool( r, values, minr, maxr)
% devuelve dos valores de r1 y r2 tales que error = |(r - (r1//r2))/r|
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

adm = 1/r; maxadm = 1/minr; minadm = 1/maxr;
values = unique(values); % saco los repetidos

commvalue = ismember(r/10^magorder(r), values);

values = values.^-1 *10;
sort(values);
if(values(1) == 10)
    values(1) = 1; %si estaba el 1 tengo que corregir esto
end

[ adm1, adm2 ] = seriesresistortool(adm, values, minadm, maxadm);

if adm1 == -1
    r1 = -1; r2 = -1; error = -1;
else
    r1 = min(adm1.^-1, maxr); % por si devuelve admitancia 0
    r2 = adm2.^-1; % en este caso r2 puede ser inf
    error = abs((r - (r1.^-1+r2.^-1).^-1)/r);
    
    if commvalue == true && ~ismember(find(r1==r), find(r2==maxr))  
        
        k=find(error == max(error));
        if size(k,2)>1
            k=k(1);
        end
            
        r1(k) = r; r2(k) = inf; error(k) = 0;
    return;
    end
end
end

% 
% [ r1, r2, error ] = parallelresistortool( r, values, minr, maxr )
% % devuelve dos valores de r1 y r2 tales que error = |(r - (r1//r2))/r|
% % esta minimizado, y r1,r2 son:
% %   - mayores o iguales a MIN_RES
% %   - menores o iguales a MAX_RES
% %   - son iguales a Nx10^n, donde N pertenece al arreglo 'values'
% %
% %  si el argumento r no es un arreglo de 1x1, o si su valor no es positivo
% % devuelve -1 en todos los argumentos de salida. lo mismo si values no es 
% % un vector no vacio, o contiene numeros por fuera de [1,10)
% 
% if isempty(values) || size(size(values),2) ~= 2 || size(values,1) ~= 1 ...
%     || minr <= 0 || maxr <= minr || r <= 0 || isnan(r) 
%     r1 = -1; r2 = -1; error = -1;
%     return;
% end
% 
% if min(values)<1 || max(values)>=10
%     r1 = -1; r2 = -1; error = -1;
%     return;
% end
% 
% adm = 1/sym(r); maxadm = 1/sym(minr); minadm = 1/sym(maxr);
% values = unique(values); % saco los repetidos
% values = values); % n\in[1,10) => (n^-1)\in(0,1]
% values = values.^-1 *10;
% sort(values);
% if(values(1) == 10)
%     values(1) = 1; %si estaba el 1 tengo que corregir esto
% end
% 
% [ adm1, adm2 ] = seriesresistortool(adm, values, minadm, maxadm);
% 
% if adm1 == -1
%     r1 = -1; r2 = -1; error = -1;
% else
%     r1 = double(1/adm1); r2 = double(1/adm2);
%     error = double(abs((r - (1/r1+1/r2)^-1)/r));
% end
% end
% 
