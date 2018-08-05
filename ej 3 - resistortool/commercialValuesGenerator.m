function [ commercialValues ] = commercialValuesGenerator( tolerancia)
%COMMERCIAL VALUES GENERATOR: devuelve los valores comerciales para las tolerancias
% 1,2,5,10 y 20
paso=0;
vDecada=0;
redondeo=1;
if nargin==0
    tolerancia=10;
end
 switch tolerancia
     case 20
         paso=6;
     case 10
         paso=12;
     case 5
         paso=24;
     case 2
         paso=48;
         redondeo=2;
     case 1
         paso=96;
         redondeo=2
     otherwise
         commercialValues=0;
 end
 if paso~=0
     commercialValues=1;
     vDecada=10^(1/paso);
     for i=1:(paso-1)
         commercialValues=[commercialValues,round((vDecada^i),redondeo)];         
     end
 end
 
end

