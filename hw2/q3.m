
load('face.mat');

%% part 1 - displaying...
h = surf(X,Y,Z.*MASK);
axis image, shading interp, view([0 90]),
axis off,lighting phong, camlight head,
set(h,'FaceColor',[1 1 1] * 0.9, 'EdgeColor', 'none',...
'SpecularColorReflectance',0.1,'SpecularExponent',100);

%% part 2 - calc curvatures

[X_u, X_v] = gradient(X);
[Y_u, Y_v] = gradient(Y);
[Z_u, Z_v] = gradient(Z);

[X_uu, X_uv] = gradient(X_u);
[~, X_vv] = gradient(X_v);
[Y_uu, Y_uv] = gradient(Y_u);
[~, Y_vv] = gradient(Y_v);
[Z_uu, Z_uv] = gradient(Z_u);
[~, Z_vv] = gradient(Z_v);


A_u = [X_u(:) Y_u(:) Z_u(:)]';
A_v = [X_v(:) Y_v(:) Z_v(:)]';
A_uu = [X_uu(:) Y_uu(:) Z_uu(:)]';
A_uv = [X_uv(:) Y_uv(:) Z_uv(:)]';
A_vv = [X_vv(:) Y_vv(:) Z_vv(:)]';

N = normc(cross(A_u, A_v));

E = dot(A_u, A_u);
F = dot(A_u, A_v);
G = dot(A_v, A_v);

e = dot(N, A_uu);
f = dot(N, A_uv);
g = dot(N, A_vv);



K = (e.*g - f.*f) ./ (E.*G - F.*F);
H = 0.5 * (e.*G - 2*f.*F + g.*E) ./ ((E.*G - F.*F));

K = reshape(K, size(X));
H = reshape(H, size(X));

h = surf(X,Y,Z.*MASK, K);
axis image, shading interp, view([0 90]), axis off, colormap jet
lighting phong, camlight head
set(h,'SpecularColorReflectance',0.1,'SpecularExponent',100);

h = surf(X,Y,Z.*MASK, H);
axis image, shading interp, view([0 90]), axis off, colormap jet
lighting phong, camlight head
set(h,'SpecularColorReflectance',0.1,'SpecularExponent',100);

%% part 3 - classification of mesh areas..

classification = zeros(size(X));

classification(K>0) = 2;
classification(K<0) = 3;
classification(abs(K)<0.01 & abs(H)<0.01) = 0;

h = surf(X,Y,Z.*MASK, classification);
axis image, shading interp, view([0 90]), axis off, colormap jet
lighting phong, camlight head
set(h,'SpecularColorReflectance',0.1,'SpecularExponent',100);

