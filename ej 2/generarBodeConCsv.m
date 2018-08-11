close all;
clear all;
datos=csvread('bode.csv');
ganancia=datos(:,3)./datos(:,2);
ganancia=20*log10(ganancia);
fase=datos(:,4);
frecuencia=datos(:,1).*1000;
%semilogx(frecuencia,ganancia)
semilogx(frecuencia,fase)