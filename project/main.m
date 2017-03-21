

Img_dir = 'data\LightProbe-1';
imgSuffix = 'JPG';

I = load_images( Img_dir, imgSuffix );


L = textread(fullfile(Img_dir, 'light_directions.txt'))';
[rho, n] = photometric_stereo(I, L);

MT = get_metric_tensor(n);

figure; imshow(n); axis yx;