syms vi vo i1 i2 i3 i4 i5 i6 r1 r2 r3 c1 c2 c3 s

%seteo el sistema de ecuaciones del circuito
eqn1 = -i6+ i3 -i2;
eqn2 = i1 + i2 -i5;
eqn3 = vi - i1*r1 -i5/s/c3;
eqn4 = vi - i3/s/c1 - i6 * r3;
eqn5 = vo - i2*r2 - i5/s/c3;
eqn6 = vo +i2/s/c2 -i6*r3;

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
transfer = subs(transfer,r1,2*r3);
transfer = subs(transfer,r2,2*r3);
transfer = subs(transfer,c1,c3/2);
transfer = subs(transfer,c2,c3/2);
transfer = simplify(transfer)		%obtengo la funcion de transferencia del notch normal.

c3 = 82e-9;
r3 = 0.18e3;
time = 0:.1:1e3;
figure();
h = ilaplace(transfer)		%respuesta impulsiva
y = ilaplace(transfer/s)	%respuesta al escalón

%paso a graficar el bode
clearvars
c3 = 82e-9;
r3 = 0.18e3;
s = tf('s');
%harcodie aca porque tuvce que pasar de syms s a tf('s')
H = (c3^2*r3^2*s^2 + 1)/(c3^2*r3^2*s^2 + 4*c3*r3*s + 1);
opt = bodeoptions();
opt.FreqUnits = 'Hz';
bode(H, opt);
step(H);
impulse(H);


