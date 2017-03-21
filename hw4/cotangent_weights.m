function [ W ] = cotangent_weights( vertex,face )

n = max(max(face)); % num vertices?
% W = sparse(n,n);
W = zeros(n);
% ring = compute_vertex_face_ring(face);
Neighbors = adjacencyAreaMatrix( vertex, face );

for i = 1:n
    ns = find(Neighbors(i,:));
    for ring = unique([Neighbors(i,ns) Neighbors(ns,i)'])
        curr_face = face(ring,:);

        if curr_face(1)==i
            v = curr_face(2:3);
        elseif curr_face(2)==i
            v = curr_face([1 3]);
        elseif curr_face(3)==i
            v = curr_face(1:2);
        else
            error('Problem in face ring.');
        end
        j = v(1); k = v(2);
        vi = vertex(i,:);
        vj = vertex(j,:);
        vk = vertex(k,:);
        % angles
        alpha = get_angel(vk-vi,vk-vj);
        beta = get_angel(vj-vi,vj-vk);
        % add weight
        W(i,j) = W(i,j) - cot( alpha );
        W(i,k) = W(i,k) - cot( beta );
        W(i,i) = W(i,i) + cot( alpha) + cot(beta);
    end
end
W = W / 2;

end


function angel = get_angel(u,v)
    du = sqrt( sum(u.^2) );
    dv = sqrt( sum(v.^2) );
    du = max(du,eps); dv = max(dv,eps);
    angel = acos( sum(u.*v) / (du*dv) );
end
  