
clear, close all;
addpath(genpath(pwd));

load('al0.mat');
[ M, A ] = cotangent_LB( shape );

[V,DDD] = eigs(M,A,5,'sm');
V = normc(V);

figure;
for i=5:-1:1
    subplot(2,5,i);
h = trisurf(shape.TRIV,shape.X,shape.Y,shape.Z,V(:,i));
        axis image, shading interp, view([-180 -90]), axis off, colormap jet
        camlight headlight
        set(h,'SpecularColorReflectance',0.1,'SpecularExponent',100);
end


load('al4.mat');
[ M, A ] = cotangent_LB( shape );

[V,~] = eigs(M,A,5,'sm');
V = normc(V);

for i=5:-1:1
    subplot(2,5,5+i);
h = trisurf(shape.TRIV,shape.X,shape.Y,shape.Z,V(:,i));
        axis image, shading interp, view([-180 -90]), axis off, colormap jet
        camlight headlight
        set(h,'SpecularColorReflectance',0.1,'SpecularExponent',100);
end