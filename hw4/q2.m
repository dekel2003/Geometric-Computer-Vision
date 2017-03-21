
%% 
clear, close all;
addpath(genpath(pwd));


load('al0.mat');


times = [0 2.^(0:8) *10];
sig = HKS(shape,times);

%% compute feature points:
V = [shape.X shape.Y shape.Z];
F = shape.TRIV;
Neighbors = adjacencyAreaMatrix( V, F );
features_t = zeros(1,4000);
for i=1:4000
    ns = [i find(Neighbors(i,:))];
    for j=1:10
%         features_t = find(sig(i,j) == max(sig(ns,j)));
%         if features_t == []
%             continue
%         end
        if (sig(i,j) == max(sig(ns,j)))
            features_t(i) = features_t(i)+1;
        end
    end
end

features = find(features_t==10);


%% 
nsig = normc(sig);
figure;
for i=1:10
    subplot(2,5,i);
h = trisurf(shape.TRIV,shape.X,shape.Y,shape.Z,nsig(:,i));
        axis image, shading interp, view([-180 -90]), axis off, colormap jet
        camlight headlight
        set(h,'SpecularColorReflectance',0.1,'SpecularExponent',100);
        caxis ([0.005 ; 0.03])
        header = sprintf('%d: t=%d',i,times(i));
        title(header);
        hold on;
        scatter3(shape.X(features),shape.Y(features),shape.Z(features),'filled','MarkerFaceColor',[1 0 0]);
        hold off;
end





