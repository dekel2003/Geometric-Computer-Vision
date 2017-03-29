clear;
close all;

%% load pictures to cell array
% num_frames = 17;
% img = cell(num_frames,1);
% for k = 1:num_frames
%     fileName = sprintf('f%d.jpg', k);
%     img{k} = imread(fileName);
% end

%% load video
v = VideoReader('fvid2.mp4');
video = read(v);
num_frames = size(video,4);
clear video;

%% measure distance between pics
num_frames = double(round(num_frames));
D = zeros(num_frames);
G = sparse(D);
for k1 = 1:num_frames-1
    for kk2 = k1+1:k1+4
        k2 = mod(kk2-1,num_frames)+1;
%         img1 = rgb2gray(imresize(img{k1}, 0.4));
%         img2 = rgb2gray(imresize(img{k2}, 0.4));

        img1 = imresize(read(v,k1),0.7);
        img1 = [(img1(:,:,1)-mean(mean(img1(:,:,1)))), 128+img1(:,:,2)-mean(mean(img1(:,:,2))), 256+img1(:,:,3)-mean(mean(img1(:,:,3)))];
        img2 = imresize(read(v,k2),0.7);
        img2 = [(img2(:,:,1)-mean(mean(img2(:,:,1)))), 128+img2(:,:,2)-mean(mean(img2(:,:,2))), 256+img2(:,:,3)-mean(mean(img2(:,:,3)))];
        
%         [optimizer, metric] = imregconfig('multimodal');
%         optimizer.InitialRadius = 0.009;
%         optimizer.Epsilon = 2;
%         optimizer.GrowthFactor = 1.01;
%         optimizer.MaximumIterations = 300;
%         T = imregtform(img1, img2, 'affine', optimizer, metric);
% 
%         movingRegistered = imregister(img1, img2, 'affine', optimizer, metric);
        
        p = size(img2)/2;

        img1 = double(img1(:));
        img2 = double(img2(:));
        h1 = hist(img1-mean(mean(img1)), 128);
        h2 = hist(img2-mean(mean(img2)), 128);
        d = sqrt(sum((h2-h1).^2))/norm(p*2);
        G(k1,k2) = G(k1,k2) + d;
        G(k2,k1) = G(k2,k1) + d;
    end
end
D = graphallshortestpaths(G);
mds_dist = sphere_embedding( D, 3 );
scatter3(mds_dist(:,1),mds_dist(:,2),mds_dist(:,3));

%% plot sphere
CC = [];
PP = [];
r = max(max(D))/pi;
for k = 1:num_frames
    im = imresize(read(v,k), 0.4);
    z = mds_dist(k,:);
    p = size(im)/2;
    [H,W,~] = size(im);
    [A,B] = meshgrid(1:W,1:H);
    A = A - p(2);
    B = B - p(1);
    %%% change max p...
    A = A /sqrt(r);
    B = B /sqrt(r);
    pos = reshape(cat(3,B,A,zeros(size(A)),ones(size(A))),[],4);
    c = im;
    c = reshape(c,[],3);
    
    % rotate
%     if z(2) > 0
%         R =     rotx(acos(z*normc([0 0 1]'))*180/pi );
%         R = R * roty(-asin(z*normc([1 0 0]'))*180/pi);
%         pos(:,1:3) = pos(:,1:3) * R;
%     else
%         R =     rotx(-acos(z*normc([0 0 1]'))*180/pi );
%         R = R * roty(-asin(z*normc([1 0 0]'))*180/pi);
%         pos(:,1:3) = pos(:,1:3) * R;
%     end

    dx = z * [1 0 0]' ;
    dy = z * [0 1 0]' ;
    if (z(3)<0)
        dx=-dx; dy=-dy;
    end
%     if (dy<0)
%         dy=dy+pi;
%     end
%     if (dx<0)
%         dx=dx+pi;
%     end
    R =     rotx(acos(dy)* 180 / pi + 90) * roty(acos(dx)* 180 / pi + 90);
    pos(:,1:3) = pos(:,1:3) * R;
    
    % translate
    T = [eye(3) z' ; 0 0 0 1];
    pos = pos * T';
    pos = pos(:,1:3);
    pos = normr(pos(:,1:3));
    
    PP=cat(1,PP,pos);
    CC=cat(1,CC,c);
end

PP=PP + 0.01 * (rand(size(PP))-0.5);
showPointCloud(PP,CC,'MarkerSize',5);



