function [ commercialValues ] = commercialValuesGenerator( tolerancia)
%COMMERCIAL VALUES GENERATOR: devuelve los valores comerciales para las tolerancias
% 1,2,5,10 y 20
tabalaValoresComerciales=csvread('valoresComerciales.txt');
sizeTabla=size(tabalaValoresComerciales);
commercialValues=0;
data=0;
if nargin==0
    tolerancia=10;
end
for i=1:sizeTabla(1)
    if(tabalaValoresComerciales(i,1)==tolerancia)
        data=i;
    end
end
if(data~=0)
    commercialValues=tabalaValoresComerciales(data,:);
    commercialValues=commercialValues(3:(commercialValues(2)+2));
end


 
end

