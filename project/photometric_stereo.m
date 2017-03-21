function [rho, n] = photometric_stereo(I, L)


[N1, N2, M] = size(I);
N = N1*N2;
I = reshape(I, [N, M]);

V = L \ I';

b = reshape(V', [N1, N2, 3]);
rho = sqrt(sum(b.^2, 3));
n = b ./ repmat(rho, [1 1 3]);

end

