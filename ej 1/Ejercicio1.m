syms vi vo i1 i2 i3 i4 i5 i6 r_1 r_2 r_3 c_1 c_2 c_3 s

%seteo el sistema de ecuaciones del circuito
eqn1 = -i6+ i3 -i2;
eqn2 = i1 + i2 -i5;
eqn3 = vi - i1*r_1 -i5/s/c_3;
eqn4 = vi - i3/s/c_1 - i6 * r_3;
eqn5 = vo - i2*r_2 - i5/s/c_3;
eqn6 = vo +i2/s/c_2 -i6*r_3;

eqns = [eqn1 eqn2 eqn3 eqn4 eqn5 eqn6];

%resuelvo el sistema de ecuaciones, despejando la transferencia
eqns = subs(eqns,i6,solve(eqns(1)==0, i6));
eqns = subs(eqns,i5,solve(eqns(2)==0, i5));

eqns(4) = subs(eqns(4),vi,solve(eqns(3)==0, vi));
eqns = subs(eqns,i1,solve(eqns(4)==0, i1));
eqns(6) = subs(eqns(6),vo,solve(eqns(5)==0, vo));
eqns = subs(eqns,i2,solve(eqns(6)==0,i2));

transfer = solve(eqns(5)==0, vo)/solve(eqns(3)==0,vi)

%sigo la sugerencia de los valores de r1, r2, c1,c2
transfer = subs(transfer,r_1,2*r_3);
transfer = subs(transfer,r_2,2*r_3);
transfer = subs(transfer,c_1,c_3/2);
transfer = subs(transfer,c_2,c_3/2);
transfer = simplify(transfer)		

%obtengo la funcion de transferencia del notch normal.

c_3 = 82e-9;
r_3 = 0.18e3;
time = 0:.1:1e3;
figure();
h = ilaplace(transfer)		%respuesta impulsiva
y = ilaplace(transfer/s)	%respuesta al escal�n

%paso a graficar el bode
clearvars
c_3 = 82e-9;
r_3 = 0.18e3;
s = tf('s');
%harcodie aca porque tuvce que pasar de syms s a tf('s')
H = (c_3^2*r_3^2*s^2 + 1)/(c_3^2*r_3^2*s^2 + 4*c_3*r_3*s + 1);
opt = bodeoptions();
opt.FreqUnits = 'Hz';
DatosSimulados=csvread('simulacion.csv');
DatosMedidos=csvread('medido.csv');
opt.PhaseVisible='off';
[mag,phase,wout]=bode(H, opt);
mag=squeeze(mag);
mag=20*log10(mag);
phase=squeeze(phase);
wout=squeeze(wout);
semilogx(DatosSimulados(:,1),DatosSimulados(:,2),'r');
hold on;
semilogx(wout/(2*pi),mag,'b');
semilogx(DatosMedidos(:,1).*1000,DatosMedidos(:,5),'g');
%figure();
%step(H);
%figure();
%impulse(H);



