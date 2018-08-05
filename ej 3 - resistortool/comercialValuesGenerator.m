function [ comercialValues ] = comercialValuesGenerator( tolerancia)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
paso=0;
vDecada=0;
redondeo=1;
if nargin==0
    tolerancia=10;
end
 switch tolerancia
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
         comercialValues=0;
 end
 if paso~=0
     comercialValues=1;
     vDecada=10^(1/paso);
     for i=1:(paso-1)
         comercialValues=[comercialValues,round((vDecada^i),redondeo)];         
     end
 end
 
end

