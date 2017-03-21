clear, close all;
addpath(genpath(pwd));

load('cat0.mat');
Pts = FPS(surface,10,1);

figure;
h = trisurf(surface.TRIV,surface.X,surface.Y,surface.Z);
        axis image, shading interp, view([0 1]), axis off,
        camlight headlight
        set(h,'SpecularColorReflectance',0.1,'SpecularExponent',100);

hold on;
scatter3(surface.X(Pts),surface.Y(Pts),surface.Z(Pts),'filled','MarkerFaceColor',[1 0 0]);
hold off;
