% This is a way to keep track of all the moving pieces
classdef PopulationSimulator < handle
    properties
        % Model parameters
        r1 = 0.05;
        r2 = 0.08;
        K1 = 1.5e+5;
        K2 = 4.0e+5;
        a1 = 1.0e-8;
        a2 = 1.0e-8;

        % Initial population levels
        blue_init
        fin_init

        % Symbolic representation of the model differential equations and relevant symbols
        diffeq1
        diffeq2
        eq_symbols

        % Number of years during simulation
        years = 50;
        % populations stores the ODE system solution, while interval is the relevant time interval for the solution.
        populations
        interval
    end
    methods
        % Class constructor. This is what is called to initialize a PopulationSimulator object.
        % Arguments:
        %   x0      -- the initial level of blue whales
        %   y0      -- the initial level of fin whales
        %   de1     -- the first differential equation
        %   de2     -- the second differential equation
        %   eqnsyms -- the symbols that express de1 and de2
        function obj = PopulationSimulator(x0, y0, de1, de2, eqnsyms)
            obj.blue_init = x0;
            obj.fin_init = y0;
            obj.diffeq1 = de1;
            obj.diffeq2 = de2;
            obj.eq_symbols = eqnsyms;
        end

        % Setter methods
        function obj = set.populations(obj, pop)
            obj.populations = pop;
        end

        function obj = set.interval(obj, interval)
            obj.interval= interval;
        end

        % Simulate the solution to the differential equations specified by the
        % constructor. The default interval is 50 years, but this can be
        % overwritten.
        % Arguments:
        %   obj     -- the class instance (this stores all of the local parameters)
        % Returns:
        %   [called for side effects]
        function simulate(obj)
            symbol_subs = @(pops) [pops(1) pops(2) obj.r1 obj.r2 obj.K1 obj.K2 obj.a1 obj.a2];
            interval = [0 obj.years];
            initials = [obj.blue_init obj.fin_init];

            f =  @(t, pops) double([subs(obj.diffeq1, obj.eq_symbols, symbol_subs(pops)); ...
                                    subs(obj.diffeq2, obj.eq_symbols, symbol_subs(pops))]);

            [obj.interval, obj.populations] = ode45(f, interval, initials);
        end

        % Compute the population level that maximizes the combined growth rate of blue and fin whales.
        % Arguments:
        %   obj             -- the class instance (this stores all of the local parameters)
        % Retuns:
        %   sol             -- (array) the optimal quantities of blue and fin whales
        %   sensitivities   -- (cell) sensitivitiy functions of solutions with respect to each model parameter
        function [sol sensitivities] = compute_maximal_combined_growth(obj)
            float_params = [obj.r1 obj.r2 obj.K1 obj.K2 obj.a1 obj.a2];
            syms x y r1 r2 K1 K2 a1 a2;
            sym_params = [r1 r2 K1 K2 a1 a2];
            r = obj.diffeq1 + obj.diffeq2;
            de1 = diff(subs(r, obj.eq_symbols, [sym_params]), x) == 0;
            de2 = diff(subs(r, obj.eq_symbols, [sym_params]), y) == 0;

            [A, B] = equationsToMatrix([de1, de2], [x, y]);
            sol = linsolve(A, B);
            
            % call the sensitivity function found in sensitivity.m
            sensitivities = sensitivity(sol, sym_params, float_params);

        end

        % Compute the feasible and sustainable population levels of blue and fin whales.
        % Arguments:
        %   obj             -- the class instance (this stores all of the local parameters)
        % Retuns:
        %   sol             -- (array) the optimal quantities of blue and fin whales
        %   sensitivities   -- (cell) sensitivitiy functions of solutions with respect to each model parameter
        function [region sensitivities] = compute_feasible_sustainable_region(obj)
            float_params = [obj.r1 obj.r2 obj.K1 obj.K2 obj.a1 obj.a2];
            syms x y r1 r2 K1 K2 a1 a2;
            sym_params = [r1 r2 K1 K2 a1 a2];

            ineq1 = simplify(subs(obj.diffeq1, obj.eq_symbols, sym_params, x) / x) == 0;
            ineq2 = simplify(subs(obj.diffeq2, obj.eq_symbols, sym_params, y) / y) == 0;
            assume(x > 0);
            assume(y > 0);

            % Solve for the intersection of the sustainability curves
            [A, B] = equationsToMatrix([ineq1, ineq2], [x, y]);
            X = linsolve(A, B);

            ineq3 = subs(ineq1, y, 0);
            ineq4 = subs(ineq2, x, 0);

            Y = solve(ineq3, x);
            Z = solve(ineq4, y);

            region = {X Y Z};
            sensitivities = cell(3,1);

            for i = 1:3
                % call the sensitivity function found in sensitivity.m
                sensitivities{i} = sensitivity(region{i}, sym_params, float_params);
            end
        end
    end
end
