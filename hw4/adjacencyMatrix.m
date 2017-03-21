function A = adjacencyMatrix( face )


% return NxN matrix, when N is the number of vertices.
% A_ij == 1 if exsits face with vertex i and j in. 


f = double(face);

A = sparse([f(:,1); f(:,1); f(:,2); f(:,2); f(:,3); f(:,3)], ...
           [f(:,2); f(:,3); f(:,1); f(:,3); f(:,1); f(:,2)], ...
           1.0);

% avoid double links, returns abooolean matrix.
A = double(A>0);

