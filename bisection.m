function root = bisection(f, a, b)
if a > b
    temp = a;
    a = b;
    b = temp;
else
    root = (a + b) / 2;
    while ( abs(f(root)) > 1e-10 )
       if f(root) > 0
           b = root;
       else
           a = root;
       end
       root = (a + b) / 2;
    end

end