function [ sample ] = FPS( shape, N, idx )

if N==0
    sample = [];
    return;
end

sample = zeros(1,N);

V = [shape.X shape.Y shape.Z];
F = shape.TRIV;

sample(1) = idx;
for i=2:N
    [D,~,~] = perform_fast_marching_mesh(V, F, sample(1:i-1));
    [~,new_sample] = max(D);
    sample(i) = new_sample(1);
end

end

