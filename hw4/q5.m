clear, close all;
addpath(genpath(pwd));

[I,labels] = readMNIST(60000);

ind0 = labels==0;
A0 = I(ind0);
B0 = double(reshape(cell2mat(A0),28*28,size(A0,2)));

ind1 = labels==1;
A1 = I(ind1);
B1 = double(reshape(cell2mat(A1),28*28,size(A1,2)));

% for showing one of them:
% imshow(reshape(B1(:,4),28,28)');

M = mean([B0 B1],2);
C = [B0 B1] - repmat(M,1,size([B0 B1],2));
[V,~] = eigs(C' * C, 20);
V = normc(C * V);

euclidean = V \ C;
euclidean = euclidean - min(min(euclidean));
euclidean =  euclidean / max(max(euclidean));

distances = euclidean' * euclidean;
distances = 1./ distances;

Graph = sparse(zeros(size(distances)));
distances_t = distances;
for i=1:20
    [Val, Ind] = min(distances_t);
    Ind = sub2ind(size(Graph),Ind,1:size(Graph,1));
    Graph      (Ind) = Val;
    distances_t(Ind) = Inf;
end

Graph = max(Graph,Graph');

% graph_distances = zeros(size(Graph));
% for i=1:size(graph_distances,1)
%     graph_distances(i,:) = graphshortestpath(Graph, i);
% end
graph_distances = graphallshortestpaths(Graph);

plannar_coords = classical_mds( graph_distances,2 );
plannar_coords2 = real(plannar_coords) + imag(plannar_coords);

scatter(plannar_coords2(1:size(B0,2),1),plannar_coords2(1:size(B0,2),2),'filled','MarkerFaceColor',[1 0 0]);
hold on;
scatter(plannar_coords2(size(B0,2)+1:end,1),plannar_coords2(size(B0,2)+1:end,2),'filled','MarkerFaceColor',[0 0 1]);
hold off;
% M0 = mean(B0,2);
% M1 = mean(B1,2);
% C0 = B0 - repmat(M0,1,size(B0,2));
% C1 = B1 - repmat(M1,1,size(B1,2));
% 
% [V0,~] = eigs(C0' * C0, 2);
% V0 = normc(C0 * V0);
% 
% [V1,~] = eigs(C1' * C1, 2);
% V1 = normc(C1 * V1);


%%
plannar_coords3 = classical_mds(distances,2 );
scatter(plannar_coords3(1:size(B0,2),1),plannar_coords3(1:size(B0,2),2),'filled','MarkerFaceColor',[1 0 0]);
hold on;
scatter(plannar_coords3(size(B0,2)+1:end,1),plannar_coords3(size(B0,2)+1:end,2),'filled','MarkerFaceColor',[0 0 1]);
hold off;