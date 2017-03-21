function [ I ] = LinearHeat2D( I,dt,scale )
%I grayscale image
%scale = [dx,dy]
iterations=10;
[rows,cols]=size(I);
dx=scale(1);
dy=scale(2);
for n=1:iterations
    for i=2:rows-1
        for j=2:cols-1
            I(i,j)=I(i,j)+dt*((I(i+1,j)-2*I(i,j)+I(i-1,j))/dx^2+(I(i,j+1)-2*I(i,j)+I(i,j-1))/dy^2);
        end
    end
end

end

