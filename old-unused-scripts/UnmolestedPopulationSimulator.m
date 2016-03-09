classdef UnmolestedPopulationSimulator < PopulationSimulator
    methods
        function obj = UnmolestedPopulationSimulator(x0, y0)
            obj = obj@PopulationSimulator(x0, y0)
        end
        function simulate()
            f = @(t,x) [r1 * x(1) * (1 - x(1) / K1) - a1 * x(1) * x(2); ...
            r2 * x(2) * (1 - x(2) / K2) - a2 * x(1) * x(2)];
            [time, populations] = ode45(f, [0 years], [blue_init fin_init]);
        end
    end
end
