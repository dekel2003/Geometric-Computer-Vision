function [ M, A ] = cotangent_LB( shape )

V = [shape.X shape.Y shape.Z];
F = shape.TRIV;

M = cotangent_weights(V,F);
[~, A] = verTriAreas(V,F);
A = sparse(diag(A));
end

