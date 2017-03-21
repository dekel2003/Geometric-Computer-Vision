function y = normalizeND(x)
a = 0;
b = 1;
m = min(x(~isnan(x)));
M = max(x(~isnan(x)));
if M-m<eps
    y = x;
else
    y = (b-a) * (x-m)/(M-m) + a;
end


