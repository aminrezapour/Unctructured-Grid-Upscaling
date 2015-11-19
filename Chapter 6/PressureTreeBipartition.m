X = 20;
Y = 40;
n = 800;
F = 2*ones(n,1);

for i = 0:2*X:X*Y-1
    F(i+1:1:i+X) = 1;
end

for i = X:2*X:X*Y-1
    F(i+2:2:i+X) = 1;
end