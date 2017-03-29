clear;
close all;

%% load pictures to cell array
img = cell(5,1);
for k = 1:5
    fileName = sprintf('f%d.jpg', k);
    img{k} = imread(fileName);
end

%% measure distance between pics
D = zeros(numel(img));
for k1 = 1:4
    for k2 = k1+1:5
        img1 = rgb2gray(imresize(img{k1}, 0.4));
        img2 = rgb2gray(imresize(img{k2}, 0.4));

%         [optimizer, metric] = imregconfig('multimodal');
%         optimizer.InitialRadius = 0.009;
%         optimizer.Epsilon = 2;
%         optimizer.GrowthFactor = 1.01;
%         optimizer.MaximumIterations = 300;
%         T = imregtform(img1, img2, 'affine', optimizer, metric);
% 
%         movingRegistered = imregister(img1, img2, 'affine', optimizer, metric);

%         figure
%         subplot(1,3,1);
%         imshow(movingRegistered);
%         subplot(1,3,2);
%         imshow(rgb2gray(imresize(img{k1}, 0.4)));
%         subplot(1,3, 3);
%         imshow(rgb2gray(imresize(img{k2}, 0.4)));
%         drawnow;
        
        p = size(img2)/2;
%         d = norm((T.T - eye(3)) * [p 1]')/norm(p*2);
%         D(k1,k2) = d;
%         D(k2,k1) = d;

        img1 = double(img1(:));
        img2 = double(img2(:));
        h1 = hist(img1-mean(mean(img1)), 128);
        h2 = hist(img2-mean(mean(img2)), 128);
        d = sqrt(sum((h2-h1).^2))/norm(p*2);
        D(k1,k2) = D(k1,k2) + d;
        D(k2,k1) = D(k2,k1) + d;
    end
end

mds_dist = sphere_embedding( D, 3 );
scatter3(mds_dist(:,1),mds_dist(:,2),mds_dist(:,3));

%% plot sphere
CC = [];
PP = [];
r = max(max(D))/pi;
for k = 1:5
    im = imresize(img{k}, 0.1);
    z = mds_dist(k,:);
    p = size(im)/2;
    [H,W,~] = size(im);
    [A,B] = meshgrid(1:W,1:H);
    A = A - p(2);
    B = B - p(1);
    %%% change max p...
    A = A / p(2);
    B = B / p(1);
    pos = reshape(cat(3,B,A,zeros(size(A)),ones(size(A))),[],4);
    c = im;
%     if z(1)<0
%         c = fliplr(c);
%     end
%     if z(2)<0
%         c = flipud(c);
%     end
    c = reshape(c,[],3);

    % translate
    T = [eye(3) z' ; 0 0 0 1];
    pos = pos * T';
    pos = pos(:,1:3);
    R = rotx(z*[0 1 0]') * roty(z*[1 0 0]');
    pos = normr(pos * R);
    PP=cat(1,PP,pos);
    CC=cat(1,CC,c);
end

showPointCloud(PP,CC,'MarkerSize',50);



