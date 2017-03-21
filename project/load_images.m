function I = load_images( imgDir, imgSuffix )

% Get image names and dimension.
imgFiles = dir(fullfile(imgDir, ['Image_*.' imgSuffix]));
nImgs = length(imgFiles);
I = imread(fullfile(imgDir, imgFiles(1).name));
[M, N, ~] = size(I);

% Load images.
I = zeros(M, N, nImgs);
for i = 1:nImgs
  Itmp = im2double(imread(fullfile(imgDir, imgFiles(i).name)));
  I(:,:,i) = rgb2gray(Itmp);
end


end

