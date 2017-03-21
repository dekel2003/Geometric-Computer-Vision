

clear all
x = linspace(-3, 3, 100)';
y = linspace(-3, 3, 100)';
[X, Y] = meshgrid(x, y);
M=[4,2;2,3];
t=2;
F = @(t) ((1/(4*pi*t*sqrt(det(M))))*exp((-[x,y]*inv(M)*[x,y]')/(4*t)));
figure, surfc(X,Y,F(t));
figure, contour(X, Y, F(t));
