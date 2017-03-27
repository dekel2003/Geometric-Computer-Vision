
clear, close all;
addpath(genpath(pwd));

load('bunny.mat');
surface.TRIV = trigs;
surface.X = Xc(:,1);
surface.Y = Xc(:,2);
surface.Z = Xc(:,3);

D = compute_pairwise_geodesic_distances(surface);

% mds_dist = classical_mds(D,3);
%%%%%%%%%%
mds_dist = sphere_embedding( D, 1, 3 );
%%%%%%%%%%

X = mds_dist(:,1);
Y = mds_dist(:,2);
Z = mds_dist(:,3);

figure;


subplot(1,2,1);
h = trisurf(surface.TRIV,surface.X,surface.Y,surface.Z);
        axis image, shading interp, view([0 90]), axis off,
        lighting phong, camlight headlight
        set(h,'SpecularColorReflectance',0.1,'SpecularExponent',100);

        
subplot(1,2,2);
h = trisurf(surface.TRIV,X,Y,Z);
        axis image, shading interp, view([0 90]), axis off,
        lighting phong, camlight headlight
        set(h,'SpecularColorReflectance',0.1,'SpecularExponent',100);
        
