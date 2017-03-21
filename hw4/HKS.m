function [ sig ] = HKS( shape, t_vec )

[ M, A ] = cotangent_LB( shape );
[V,D] = eigs(M,A,200,'sm');
V = normc(V);
D = abs(D);


sig = V.^2 * exp( - diag(D) * t_vec);

end

