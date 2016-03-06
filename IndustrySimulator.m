classdef IndustrySimulator < PopulationSimulator
    properties
        % model prices for blue and fin whales
        p1 = 12000;
        p2 = 6000;
    end
    methods
        function obj = IndustrySimulator(x0, y0, de1, de2, eqnsyms)
            obj@PopulationSimulator(x0, y0, de1, de2, eqnsyms);
        end

        function [profit sensitivities] = compute_maximum_feasible_profit(obj)
            [region, asdf] = obj.compute_feasible_sustainable_region();
            optimal_vertex = region{1};

            syms r1 r2 K1 K2 a1 a2 b1 b2 p1 p2;
            sym_params = [r1 r2 K1 K2 a1 a2 b1 b2 p1 p2];
            float_params = [obj.r1 obj.r2 obj.K1 obj.K2 obj.a1 obj.a2 obj.b1 obj.b2 obj.p1 obj.p2];

            profit = p1 * optimal_vertex(1) + p2 * optimal_vertex(2);

            sensitivities = sensitivity(profit, sym_params, float_params);
        end
    end
end
