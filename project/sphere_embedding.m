function [ Z ] = sphere_embedding( D, r, dim )

%% initialization - perform a classical MDS and convert to spherical coords

Z = classical_mds( D,dim-1 );
numelZ = size(Z,1);

Z = (Z - repmat(min(Z),numelZ,1));
Z = (Z ./ repmat(max(Z),numelZ,1) ) .* pi;
Z(:,end) = Z(:,end) * 2;


sin_array_cum_prod = cumprod([ones(numelZ,1), sin(Z)],2);
cos_array          = [cos(Z) ones(numelZ,1)];

D_ = D/r;

Z = sin_array_cum_prod .* cos_array;

Ds = real(acos((Z*Z')));

E = sum(sum((Ds - D_).^2));

%% steepest descent to minimize the error E
max_iter = 25;
lambda = 0.01;

for iter = 1:max_iter
    % eps for avoid numerical errors that make sqrt return imaginary
    % matrix..
    diffD_ = sqrt(10*eps + 1 - (Z*Z').^2);
    diffD_ = diffD_ - diag(diag(diffD_));
    diffD_ = inv(diffD_);
    diffD_ = diffD_ - diag(diag(diffD_));
    diffD = - 2 * (Z') * diffD_;

    diffE = 2 * (Ds - D_) * diffD';
    Z = Z - lambda * diffE;
    Ds = real(acos((Z*Z')/r^2));
    E = sum(sum((Ds - D_).^2));
end

end

