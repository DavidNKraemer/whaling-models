classdef PopulationSimulator
    properties
        r1 = 0.05;
        r2 = 0.08;
        K1 = 1.5e+5;
        K2 = 4.0e+5;
        a1 = 1.0e-8;
        a2 = 1.0e-8;

        blue_init
        fin_init
        years = 50;
        populations
        interval 
        diffeq1
        diffeq2
        eq_symbols
    end
    methods
        function obj = PopulationSimulator(x0, y0, de1, de2, eqsyms)
            obj.blue_init = x0;
            obj.fin_init = y0;
            obj.diffeq1 = de1;
            obj.diffeq2 = de2;
            obj.eq_symbols = eqsyms;
        end
        function simulate(obj)
            symbol_subs = @(pops) [pops(1) pops(2) obj.r1 obj.r2 obj.K1 obj.K2 obj.a1 obj.a2];
            interval = [0 obj.years];
            initials = [obj.blue_init obj.fin_init];

            f =  @(t, pops) double([subs(obj.diffeq1, obj.eq_symbols, symbol_subs(pops)); subs(obj.diffeq2, obj.eq_symbols, symbol_subs(pops))]);

            [obj.interval, obj.populations] = ode45(f, interval, initials) 
        end
        function [sol sensitivities] = compute_maximal_combined_growth(obj)
            float_params = [obj.r1 obj.r2 obj.K1 obj.K2 obj.a1 obj.a2];
            syms x y r1 r2 K1 K2 a1 a2;
            sym_params = [r1 r2 K1 K2 a1 a2];
            de1 = diff(subs(obj.diffeq1, obj.eq_symbols, [x y sym_params]), x) == 0;
            de2 = diff(subs(obj.diffeq2, obj.eq_symbols, [x y sym_params]), y) == 0;

            [A, B] = equationsToMatrix([de1, de2], [x, y]);
            sol = linsolve(A, B);

            sensitivities = cell(6,1);
            unused = [];
            float_unused = [];

            % compute the sensitivities functions with respect to each of the model parameters
            % sensitivities{i} is the sensitivities functions of x,y with respect to sym_params(i)
            for i = 1:6
                % hold one parameter as a variable, and plug in the oter five
                for j = 1:6
                   if j ~= i
                       unused = [unused sym_params(j)];
                       float_unused = [float_unused float_params(j)];
                   end
                end
                
                % compute the functions dx/dt, dy/dt with respect to the held parameter
                % and then compute the sensitivities
                f(sym_params(i)) = subs(sol, unused, float_unused);
                sensitivities{i} = diff(f, sym_params(i)) * sym_params(i) ./ f(sym_params(i));
            
                % reset and repeat!
                unused = [];
                float_unused = [];
            end
        end

    end

end
