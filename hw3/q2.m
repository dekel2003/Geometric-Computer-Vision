
%% calculate chosen cube's edges


cube = [0 0 0; ...
        1 0 0;
        1 1 0;
        0 1 0;
        0 1 1;
        0 0 1;
        0 0 0;
];

Dp = 0.1;
vec = 0:Dp:0.99;
vec_ones = ones(size(vec));
edges1 = (cube(2:end,:) - cube(1:end-1,:));
pts = cube(1:end-1,:);
edges2 = (edges1(:) * vec)' + (pts(:) * vec_ones)';
edges3 = reshape(edges2, numel(edges2)/3, 3);
R = roty(45);
edges = edges3 * R;
edges = [edges ; 0 0 0];
X = edges(:,1);
Y = edges(:,2);
Z = edges(:,3);
plot3(X,Y,Z);

%% build the surface with the initial data
Dp = 0.1;
R = roty(45);
[A,B,C] = meshgrid(0:Dp:1,0:Dp:1,0);
S1 = [A(:),B(:),C(:)] * R;

x = reshape(S1(:,1), size(A));
y = reshape(S1(:,2), size(A));
z = reshape(S1(:,3), size(A));

u = [fliplr(-x) x];
v = [fliplr(y) y];
w = [fliplr(z) z];
u(:,12) = [];
v(:,12) = [];
w(:,12) = [];

edges = nan(size(w));
edges([1 end], :) = w([1 end], :);
edges(:, [1 end]) = w(:, [1 end]);

% surf(u,v,w);
mean_curvature_flow(u,v,w, edges);

%% remove 1 edge:
edges(:,1) = NaN;
[a,b,c] = mean_curvature_flow(u,v,w, edges);

