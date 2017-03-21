function [ X, Y, Z ] = mean_curvature_flow( X, Y, Z , edges)

figure;
for i=1:4101
    [X_u, X_v] = gradient(X);
    [Y_u, Y_v] = gradient(Y);
    [Z_u, Z_v] = gradient(Z);

    [X_uu, X_uv] = gradient(X_u);
    [~, X_vv] = gradient(X_v);
    [Y_uu, Y_uv] = gradient(Y_u);
    [~, Y_vv] = gradient(Y_v);
    [Z_uu, Z_uv] = gradient(Z_u);
    [~, Z_vv] = gradient(Z_v);


    A_u = [X_u(:) Y_u(:) Z_u(:)]';
    A_v = [X_v(:) Y_v(:) Z_v(:)]';
    A_uu = [X_uu(:) Y_uu(:) Z_uu(:)]';
    A_uv = [X_uv(:) Y_uv(:) Z_uv(:)]';
    A_vv = [X_vv(:) Y_vv(:) Z_vv(:)]';

    N = normc(cross(A_u, A_v));

    E = dot(A_u, A_u);
    F = dot(A_u, A_v);
    G = dot(A_v, A_v);

    e = dot(N, A_uu);
    f = dot(N, A_uv);
    g = dot(N, A_vv);



    % K = (e.*g - f.*f) ./ (E.*G - F.*F);
    gr = max(E.*G - F.*F,0);
    H = 0.5 * (e.*G - 2*f.*F + g.*E) ./ gr;
    flow = H .* sqrt(gr);

%     flow = 0.5 * (e.*G - 2*f.*F + g.*E) ./ ((E.*G - F.*F).^0.5);

    % K = reshape(K, size(X));
%     H = reshape(H, size(X));
%     flow = H * sqrt(g);
    flow = reshape(flow, size(X));
    
%     flow = imfilter(flow,fspecial('gaussian',2));

    edge_indices = ~isnan(edges);
    flow(edge_indices) = 0;
    dt = 0.01;
    Z = Z + flow * dt;
    
    %put edges back to initial values:
%     edge_indices = find(~isnan(edges));
%     Z(edge_indices) = edges(edge_indices);

    if mod(i, 500) == 1
        subplot(3,3,1+floor(i/500));
        h = surf(X,Y,Z,flow);
        axis image, shading interp, view([0 90]), axis off, colormap jet
        lighting phong, camlight head
        set(h,'SpecularColorReflectance',0.1,'SpecularExponent',100);
    end
end




end

