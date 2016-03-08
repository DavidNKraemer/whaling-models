function root = bisection(f, a, b, iterations)
if a > b
    temp = a;
    a = b;
    b = temp;
else
    root = (a + b) / 2;
    n = 1;
    while ( abs(f(root)) > 1e-10 && n < iterations)
       if f(root) > 0
           b = root;
       else
           a = root;
       end
       root = (a + b) / 2;
       n = n + 1;
    end

end
