I=imread('cameraman.jpg');
I1=LinearHeat2D(I,0.01,[0.1,0.1]);
figure, imshow(I1,[]); title('iterations=10 dt=0.01 dx=dy=0.1')

I2=LinearHeat2D(I,0.001,[0.05,0.05]);
figure, imshow(I2,[]); title('iterations=10 dt=0.001 dx=dy=0.05')

I3=LinearHeat2D(I,0.1,[1,1]);
figure, imshow(I3,[]); title('iterations=10 dt=0.1 dx=dy=1')