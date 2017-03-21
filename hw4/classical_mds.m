function [ Z ] = classical_mds( D,dim )

n = size(D,1);
J = eye(n) - ones(n)./n;
B = -0.5 * J * D * J;
[Q,L] = eigs(B,dim,'LM');

Z = fliplr(Q * sqrt(L));

end

