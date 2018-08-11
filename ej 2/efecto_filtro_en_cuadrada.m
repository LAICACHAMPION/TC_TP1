f0 = 4 * 8000;   %Frecuencia de la senial cuadrada
A = 10; %amplitud pico a pico de la senial cuadrada

N  = 1000; %cantidad de armonicos que se muestran

armonico = 1 : N;
armonico  = armonico*f0;
amplitud = zeros([1 N]);
fase = zeros([1 N]);


for n = 1:N  
     if(rem(n,2))   %si es impar
         amplitud(n) = 4 / (pi*n);
     end;
end;

R = 500;
C = 4.7e-9;
tau = R*C;
%modH(f) = 1/((2*pi*tau*f)^2+1);
%phsH(f) = -arctg(2*pi*tau);


   Fs = armonico(N) * 100;      % samples per second
   dt = 1/Fs;                   % seconds per sample
   StopTime = 2/f0;             % seconds
   t = (0:dt:StopTime-dt)';     % seconds
   Fc = 60;                     % hertz


% modificacion del filtro
for n = 1:N  
     if(rem(n,2))   %si es impar
         f = armonico(n);
         amplitud(n) = amplitud(n) * 1/sqrt((2*pi*tau*f)^2+1);
         fase(n) = fase(n) + (-atan(2* pi * tau * f));
     end;
end;
 


figure;
x = 0;
for n = 1:N  
%   x = amplitud(n) * sin(2*pi*armonico(n)*t + fase(n));
    if(armonico(n))
        x = x + amplitud(n) * sin(2*pi*armonico(n)*t + fase(n));
%        x =amplitud(n)*sin(2*pi*armonico(n)*t);
    end;
   % Plot the signal versus time:
%   if n==N
   plot(t,x);
%   end;
   hold on;
end;
