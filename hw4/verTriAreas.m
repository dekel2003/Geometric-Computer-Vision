function [ facArea, verArea  ] = verTriAreas( vertex,face )
%
% facArea: Is a vector of the triangle areas, the indexs 
%          are respectively to faces matrix.
% verArea: Is a vector of the vertices areas, the indexs
%          are respectively to vertices matrix.
%
% accumarray - http://www.mathworks.com/help/matlab/ref/accumarray.html
%
    P1 = vertex(face(:,1)',:);
    P2 = vertex(face(:,2)',:);
    P3 = vertex(face(:,3)',:);
    A = cross(P2-P1,P3-P1);
    norms = sqrt(sum(A.^2,2)); % Calculate norm of each row.
    facArea = 1/2*norms;
    
    if nargout > 1 
        S = adjacencyAreaMatrix( vertex,face );
        [ii, ~] = find( S );
        verArea = (1/3)*accumarray( ii, facArea(nonzeros(S)), [size(S,1), 1] ).';
    end
end

