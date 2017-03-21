function A = adjacencyAreaMatrix( vertex,faces )

% A is NxN matrix, when N is the number of vertices.
% A_ij equals to the face index which consist i and j.


f = double(faces);
L = length(f(:,1));
a = linspace(1,L,L);

A1 = [f(:,1); f(:,2); f(:,3) ];
A2 = [f(:,2); f(:,3); f(:,1) ];
face_values = [a a a]';

[~, ind] = unique([A1 A2],'rows');
% duplicate indices
duplicate_ind = setdiff(1:size([A1 A2], 1), ind);
face_values(duplicate_ind) = 0;

    

A = sparse(A1 , ...
           A2 , ...
           face_values);
