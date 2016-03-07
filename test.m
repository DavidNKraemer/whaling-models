run('setup.m');

f = @(t, pops) double([subs(eqn1, [x y eqnsymbols], [pops(1) pops(2) floatsyms]); subs(eqn2, [x y eqnsymbols], [pops(1) pops(2) floatsyms])]);

g = @(tf, x0, y0) ode45(f, [0 tf], [x0 y0]);



for x0 = 0:1000:20000
   for y0 = 0:1000:20000
      [interval, populations] = g(100, x0, y0);
      fprintf('%f\t%f\n',x0,y0);
      fprintf('%f\n', fsolve(h, 0));
   end
end