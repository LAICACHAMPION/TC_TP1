f = 4 * 8000;   %Frecuencia de la senial cuadrada
A = 10; %amplitud pico a pico de la senial cuadrada

N  = 20; %cantidad de armonicos que se muestran

x = 1 : N;
x  = x*f;
y = zeros([1 N]);


for n = 1:N  
     if(rem(n,2))   %si es impar
         y(n) = 4 / n / pi();
     end;
end;


xlabel('Frecuencia (Hz)');
ylabel('Amplitud (V)')
xlim([0 (N+1)*f]);
set(gca,'color','none') 

scatter(x,y,'*');
title('Diagrama espectral de señal de entrada')
grid on;


xticks(f:2*f:19*f);
set(gca,'TickLabelInterpreter','latex');
xticklabels({'$f$', '$3f$', '$5f$', '$7f$', '$9f$', '$11f$', '$13f$', '$15f$', '$17f$', '$19f$'});
xlabel('Frecuencia','interpreter','latex');
ylabel('Amplitud(V)','interpreter','latex');
title('Diagrama espectral de se\~nal de entrada', 'interpreter', 'latex');