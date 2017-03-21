function coloredDist = colorDistanceMap(D)
[Y,X] = size(D);
% M = ones(Y,X);
c = 1-hot(256);
Borders = D==Inf;
D(Borders) = NaN;
% D(D==Inf)=max(D(D~=Inf))+1;
I = floor(255*(normalizeND(D)))+1;
I(Borders) = 255;
coloredDist = c(I(:),:);
coloredDist = reshape(coloredDist, [Y X 3]);
% tmp1 = repmat(normalizeND(M), [1 1 3]);
% tmp2 = repmat(D, [1 1 3]);
% coloredDist(tmp2==Inf) = tmp1(tmp2==Inf);