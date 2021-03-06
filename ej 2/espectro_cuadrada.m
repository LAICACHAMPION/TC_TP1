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



xlim([0 (N+1)*f]);
set(gca,'color','none') 

scatter(x,y,'*');
title('Diagrama espectral de se�al de entrada')
grid on;

xticklabels = {'f_0', '3f_0', '5f_0', '7f_0', '9f_0', '11f_0', '13f_0', '15f_0', '17f_0', '19f_0'};
set(gca,'xtick',f:2*f:N*f); 
set(gca,'xticklabel',xticklabels,'interpreter','latex');
set(gca, 'xlabel', 'Frecuencia (Hz)','interpreter','latex');
ylabel('Amplitud(V)','interpreter','latex');


set(gca,'TickLabelInterpreter','latex');
xticks(f:2*f:19*f);
xlabel('Frecuencia','interpreter','latex');
ylabel('Amplitud(V)','interpreter','latex');
title('Diagrama espectral de se\~nal de entrada', 'interpreter', 'latex');