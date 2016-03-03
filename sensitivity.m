function sensitivities = sensitivity(solution, sym_params, float_params)
len = length(float_params)

sensitivities = cell(len, 1);

unused = [];
float_unused = [];

for i = 1:len
    for j = 1:len
        if j ~= i
            unused = [unused sym_params(j)];
            float_unused = [float_unused float_params(j)];
        end
    end

    f(sym_params(i)) = subs(solution, unused, float_unused);
    sensitivities{i} = diff(f, sym_params(i)) * sym_params(i) ./ f(sym_params(i));

    unused = [];
    float_unused = [];
end
