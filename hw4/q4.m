
clear, close all;
addpath(genpath(pwd));

load('bunny.mat');
surface.TRIV = trigs;
surface.X = Xc(:,1);
surface.Y = Xc(:,2);
surface.Z = Xc(:,3);

D = compute_pairwise_geodesic_distances(surface);

mds_dist = classical_mds(D,3);
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
        
        
        
%% mapping between swissrolls
load('swiss1.mat');
load('swiss2.mat');

figure;

subplot(2,2,1);
h = trisurf(surface_1.TRIV,surface_1.X,surface_1.Y,surface_1.Z);
        axis image, shading interp, view([0 90]), axis off,
        lighting phong, camlight headlight
        set(h,'SpecularColorReflectance',0.1,'SpecularExponent',100);

subplot(2,2,2);
h = trisurf(surface_2.TRIV,surface_2.X,surface_2.Y,surface_2.Z);
        axis image, shading interp, view([0 90]), axis off,
        lighting phong, camlight headlight
        set(h,'SpecularColorReflectance',0.1,'SpecularExponent',100);

D1 = compute_pairwise_geodesic_distances(surface_1);
D2 = compute_pairwise_geodesic_distances(surface_2);
mds_dist1 = classical_mds(D1,3);
mds_dist2 = classical_mds(D2,3);

Z_axis = ones(size(mds_dist1(:,2)));

subplot(2,2,3);
h = trisurf(surface_1.TRIV,mds_dist1(:,1),mds_dist1(:,2),mds_dist1(:,3));
        axis image, view([0 90]), axis off,
        lighting phong, camlight headlight
        set(h,'SpecularColorReflectance',0.1,'SpecularExponent',100);

subplot(2,2,4);
h = trisurf(surface_2.TRIV,mds_dist2(:,1),mds_dist2(:,2),mds_dist2(:,3));
        axis image, view([0 90]), axis off,
        lighting phong, camlight headlight
        set(h,'SpecularColorReflectance',0.1,'SpecularExponent',100);

% [V1, ~] = eigs(mds_dist1'*mds_dist1,3);
% [V2, ~] = eigs(mds_dist2'*mds_dist2,2);
% V1 = normc(V1);
% V2 = normc(V2);
% mds_dist1_ = V1 * (V1' * mds_dist1);
% mds_dist2_ = V2 * (V2' * mds_dist2);

% map = knnsearch(mds_dist2,mds_dist1);

cmap = spring(numel(Z_axis));
[~,surf_1_x_ascendinf_indices]  = sort(mds_dist1(:,1));
[~,surf_2_x_ascendinf_indices]  = sort(mds_dist2(:,1));
map(surf_2_x_ascendinf_indices) = surf_1_x_ascendinf_indices;
cmap1(surf_1_x_ascendinf_indices,:) = cmap;
cmap2 = cmap1(map,:);

figure;
h = trisurf(surface_1.TRIV,surface_1.X,surface_1.Y,surface_1.Z);
% h = surf(surface_1.X,surface_1.Y,surface_1.Z, cmap);
        axis image, shading interp, view([0 90]), axis off,
%         lighting phong, camlight headlight
%         set(h,'SpecularColorReflectance',0.1,'SpecularExponent',100);
set(h,...
       'FaceVertexCData',cmap1,...
       'CDataMapping','scaled');
   
 
%    subplot(2,2,2);
figure;
h = trisurf(surface_2.TRIV,surface_2.X,surface_2.Y,surface_2.Z);
% h = surf(surface_1.X,surface_1.Y,surface_1.Z, cmap);
        axis image, shading interp, view([0 90]), axis off,
%         lighting phong, camlight headlight
%         set(h,'SpecularColorReflectance',0.1,'SpecularExponent',100);
set(h,...
       'FaceVertexCData',cmap2,...
       'CDataMapping','scaled');

