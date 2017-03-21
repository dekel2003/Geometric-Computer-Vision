
%% create mesh
Dp = 0.01;
% [X,Y] = meshgrid(-1:Dp:1,-1:Dp:1);
% 
% Z = sqrt(max((X-0.5)^2 +Y^2 , (X+0.5)^2+Y^2));

[X,Y] = meshgrid(-2:Dp:2,-2:Dp:2);
Z = zeros(size(X));
theta = deg2rad(45:315);
R = 1;

Z( (X-0.75).^2 + Y.^2 <= 1 & (X-0.75).^2 + Y.^2 > 0.98 & X>=0) = 1;
Z( (X+0.75).^2 + Y.^2 <= 1 & (X+0.75).^2 + Y.^2 > 0.98 & X<0) = 1;
F = inf(size(X));
F( (X-0.75).^2 + Y.^2 <= 1) = 1;
F( (X+0.75).^2 + Y.^2 <= 1) = 1;
[srcx,srcy] = find(Z);
T = fmm(F, [srcx';srcy'], zeros(numel(srcx),1), 'silent');
T(T==0) = 0;
img = zeros([size(T) 3]);
img(:,:,3) = T ./ max(T(:));

img(abs(img(:,:,3)-0.1) < 5e-3) = 1;
img(abs(img(:,:,3)-0.3) < 5e-3) = 1;
img(abs(img(:,:,3)-0.5) < 5e-3) = 1;
img(abs(img(:,:,3)-0.7) < 5e-3) = 1;
img(abs(img(:,:,3)-0.9) < 5e-3) = 1;
img(abs(img(:,:,3)-1) < 5e-3) = 1;
imshow(img);

