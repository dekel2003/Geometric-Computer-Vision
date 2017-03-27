

for k = 1:5
    fileName = sprintf('f%d.jpg', k);
    img2 = imread(fileName);
    img2 = imresize(img2, 0.4);
    
    fileName = sprintf('f%d.jpg', k+1);
    img = imread(fileName);
    img = imresize(img, 0.4);
    
    [optimizer, metric] = imregconfig('multimodal');
    optimizer.InitialRadius = 0.009;
    optimizer.Epsilon = 1.5;
    optimizer.GrowthFactor = 1.01;
    optimizer.MaximumIterations = 300;
    T = imregtform(rgb2gray(img2), rgb2gray(img), 'affine', optimizer, metric);
    
    movingRegistered = imregister(rgb2gray(img2), rgb2gray(img), 'affine', optimizer, metric);

    figure
    subplot(1,3,1);
    imshow(movingRegistered);
    subplot(1,3,2);
    imshow(rgb2gray(img2));
    subplot(1,3, 3);
    imshow(rgb2gray(img));
end