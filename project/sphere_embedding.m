function [ Z ] = sphere_embedding( D, dim )

%% initialization - perform a classical MDS and convert to spherical coords

Z = normr(classical_mds( D,dim ));
numelZ = size(Z,1);

% Z = (Z - repmat(min(Z),numelZ,1));
% Z = (Z ./ repmat(max(Z),numelZ,1) ) .* pi;
% Z(:,end) = Z(:,end) * 2;


% sin_array_cum_prod = cumprod([ones(numelZ,1), sin(Z)],2);
% cos_array          = [cos(Z) ones(numelZ,1)];
r = max(max(D))/pi;
D_ = D/r;

% Z = sin_array_cum_prod .* cos_array;

Ds = real(acos((Z*Z')));

E = sum(sum((Ds - D_).^2));

%% steepest descent to minimize the error E
max_iter = 100;
lambda = 0.01;

for iter = 1:max_iter
    % eps for avoid numerical errors that make sqrt return imaginary
    % matrix..
    diffD_ = sqrt(100*eps + 1 - (Z*Z').^2);
    diffD_ = diffD_ - diag(diag(diffD_));
    diffD_ = inv(diffD_);
    diffD_ = diffD_ - diag(diag(diffD_));
    diffD = - (Z') * diffD_;

    diffE = ((Ds - D_) * diffD') ./ numelZ;
    Z = normr(Z - lambda * diffE);
    Ds = real(acos((Z*Z')));
    E_prev = E;
    E = sum(sum((Ds - D_).^2));
    
    if (E>E_prev)
        lambda = lambda * 2;
    else
        lambda = lambda / 2;
    end
    
end

end

