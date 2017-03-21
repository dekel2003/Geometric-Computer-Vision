function [ Img ] = fire( S )
    black = [0 0 0];
    red =   [1 0 0];
    green = [0 1 0];
    
    [R,C] = size(S);
    Img = zeros(R,C,3);
    
    [x,y] = find(S==-1);
    Img(x,y,:) = black;
    
    [x,y] = find(S==0);
    Img(x,y,:) = red;
    
    [x,y] = find(S==1);
    Img(x,y,:) = green;

end

