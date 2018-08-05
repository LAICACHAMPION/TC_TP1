f = 8 * 1000;   %Frecuencia de la senial cuadrada
A = 10; %amplitud pico a pico de la senial cuadrada

N  = 20; %cantidad de armonicos que se muestran

x = 1 : N;
x  = x*f;
y = zeros([1 N]);


for n = 1:N  
     if(rem(n,2))   %si es impar
         y(n) = 4 / n;
     end;
end;


xlabel('Frecuencia (Hz)');
ylabel('?????')
xlim([0 (N+1)*f]);
set(gca,'color','none') 

scatter(x,y,'*');
title('Diagrama espectral de se�al de entrada')
grid on;
