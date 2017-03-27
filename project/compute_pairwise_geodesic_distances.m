function [ D ] = compute_pairwise_geodesic_distances( shape )

N = numel(shape.X);
V = [shape.X shape.Y shape.Z];
F = shape.TRIV;
D = zeros(N);

for i=1:N
    [d,~,~] = perform_fast_marching_mesh(V, F, i);
    D(:,i) = d;
end

end

