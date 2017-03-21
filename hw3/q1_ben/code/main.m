%% init
clear all;
close all;
clc
mex  fastMarching/fmm.cpp fastMarching/fmm_mex.cpp fastMarching/fheap/fib.cpp
Maze_obj=load('maze');
maze=double(Maze_obj.I);
P0=[384 ; 815];
Pf=[234 ; 9];
src = P0;
t0=0;
disp='Silent';
%disp='iter';
%% part1 - run the fast marching method on the maze
figure,
T = fmm(maze, src-1, t0,disp);
T(T>=1e7) = Inf;
A=colorDistanceMap(T);
imshow(A);

%% part2 - calculate the shortest path
figure, imshow(A);
minPath = shortestPath(T,Pf);
h=streamline(minPath);
set(h,'Color','red','LineWidth',2);
%% part 3
figure,
[m,n]=size(maze);
% Rmat=@(theta) [cosd(theta) -sind(theta) 0; sind(theta) cosd(theta) 0; 0 0 1];
Tmat=@(tx,ty) [1,0,tx;0,1,ty;0,0,1];
tform = affine2d(rotz(45)); 
maze45=imwarp(maze,tform,'nearest');
[m45,n45]=size(maze45);
sx=m45/m; sy=n45/n;
src45 = src' - [m/2,n/2];
src45 = rotz(45)*[src45 1]';
src45=round([m45/2,n45/2] + src45(1:2)')';
imshow(maze45);
T45 = fmm(maze45, src45-1, t0,disp);
T45(T45>=1e7) = Inf;
A45=colorDistanceMap(T45);
imshow(A45);

%% part4
pool=load('pool');
pool=double(pool.n);
P0=[500;400];
Pf=[1;1];
src = P0;
t0=0;
disp='Silent';
figure,
T_pool = fmm(pool, src-1, t0,disp);
T_pool(T_pool>=1e7) = Inf;
A=colorDistanceMap(T_pool);
imshow(A);
minPath = shortestPath(T_pool,Pf);
h=streamline(minPath);
set(h,'Color','red','LineWidth',2);

figure, imagesc(pool), h=streamline(minPath);
set(h,'Color','red','LineWidth',2);