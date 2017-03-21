function path = shortestPath(T,startPoint)
alpha = 0.1;
steps = 25000;
T(T==Inf) = max(max(T(T~=Inf)))*10000;
[gx,gy]=imgradientxy(T);
path = stream2(-gx,-gy,startPoint(2),startPoint(1), [alpha steps]);
return;

