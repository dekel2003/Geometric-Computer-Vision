
%% part 1 - generate curve C(p):
X = @(p) ( -p.*sin(p*pi));
Y = @(p) (sin(p*pi*2));
dp = 0.01;
p = 0:dp:0.99;
sample_points = [X(p);Y(p)]';
x = sample_points(:,1);
y = sample_points(:,2);
figure, plot_curve_points(x, y);


%% part 2 - normal flow:
figure;
sample_points2 = sample_points;
samples = numel(p);
i = 1:samples;
iplus1 = mod(i, samples)+1;
iminus1 = mod(i-2, samples)+1;
for iteration=1:401
    dC_cP = [(x(iplus1) - x(iminus1))/(2*dp) (y(iplus1) - y(iminus1))/(2*dp)];
    N = dC_cP * [0 1 ; -1 0];
    N = normr(N);
    sample_points2 = sample_points2 + 0.0005*N;
    x = sample_points2(:,1);
    y = sample_points2(:,2);
    if mod(iteration, 50) == 1
        subplot(3,3,1+floor(iteration/50));
        plot_curve_points(x, y);
        axis([-1 1 -1 1]);
    end
end
%% part 3 - curvature flow
figure;
sample_points3 = sample_points;
x = sample_points3(:,1);
y = sample_points3(:,2);

for iteration=1:801
    too_close_pts = find(sqrt(sum(abs([x(i) - x(iminus1), y(i) - y(iminus1)]).^2,2))<0.01);
    sample_points3(too_close_pts,:) = [];
    samples = size(sample_points3, 1);
    i = 1:samples;
    iplus1 = mod(i, samples)+1;
    iminus1 = mod(i-2, samples)+1;

    dC_cP = [(x(iplus1) - x(iminus1))/(2*dp) (y(iplus1) - y(iminus1))/(2*dp)];
    N = dC_cP * [0 1 ; -1 0];
    N = normr(N);
    dC2_C2P = [(x(iplus1) + x(iminus1) - 2*x(i))/(4*dp^2) (y(iplus1) + y(iminus1) - 2*y(i))/(4*dp^2)];
    CpXCpp = [dC_cP(i,:)   dC2_C2P(i,:)];
    k = zeros(samples, 1);
    for j = 1:samples % calculate curvature
       k(j) = det(reshape(CpXCpp(j,:),2,2)') / norm(dC_cP(j,:))^3;
    end
    sample_points3 = sample_points3 + 0.0005*N.* repmat(k,1,2);
    x = sample_points3(:,1);
    y = sample_points3(:,2);
    
    if mod(iteration, 100) == 1
        subplot(3,3,1+floor(iteration/100));
        plot_curve_points(x, y);
        axis([-1 1 -1 1]);
    end
end

%% part 4 - equi affine curvature flow
figure;
sample_points4 = sample_points;
transformation = [sqrt(2) -1 ; 0 1/sqrt(2)];
sample_points5 = sample_points * transformation;
da = norm(transformation(:,1));
db = norm(transformation(:,2));

x4 = sample_points4(:,1);
y4 = sample_points4(:,2);
x5 = sample_points5(:,1);
y5 = sample_points5(:,2);
    
for iteration=1:801
    % calc for regular shape:
    samples = size(sample_points4, 1);
    i = 1:samples;
    iplus1 = mod(i, samples)+1;
    iminus1 = mod(i-2, samples)+1;
    too_close_pts = find(sqrt(sum(abs([x4(i) - x4(iminus1), y4(i) - y4(iminus1)]).^2,2))<0.01);
    sample_points4(too_close_pts,:) = [];
    samples = size(sample_points4, 1);
    i = 1:samples;
    iplus1 = mod(i, samples)+1;
    iminus1 = mod(i-2, samples)+1;
    
    dC_cP = [(x4(iplus1) - x4(iminus1))/(2*dp) (y4(iplus1) - y4(iminus1))/(2*dp)];
    N = dC_cP * [0 1 ; -1 0];
    N = normr(N);
    dC2_C2P = [(x4(iplus1) + x4(iminus1) - 2*x4(i))/(4*dp^2) (y4(iplus1) + y4(iminus1) - 2*y4(i))/(4*dp^2)];
    CpXCpp = [dC_cP(i,:)   dC2_C2P(i,:)];
    k = zeros(samples, 1);
    for j = 1:samples % calculate curvature
       k(j) = (det(reshape(CpXCpp(j,:),2,2)') / norm(dC_cP(j,:))^3);
    end
    sample_points4 = sample_points4 + 0.0005*N.* repmat((abs(k).^(1.0/3)).*sign(k),1,2);
    x4 = sample_points4(:,1);
    y4 = sample_points4(:,2);
    
    % calc for transformed shape:
    i = 1:samples;
    iplus1 = mod(i, samples)+1;
    iminus1 = mod(i-2, samples)+1;
    too_close_pts = find(sqrt(sum(abs([x5(i) - x5(iminus1), y5(i) - y5(iminus1)]).^2,2))<0.01);
    sample_points5(too_close_pts,:) = [];
    samples = size(sample_points5, 1);
    i = 1:samples;
    iplus1 = mod(i, samples)+1;
    iminus1 = mod(i-2, samples)+1;
    
    
    dC_cP = [(x5(iplus1) - x5(iminus1))/(2*da) (y5(iplus1) - y5(iminus1))/(2*db)];
    N = dC_cP * [0 1 ; -1 0];
    N = normr(N);
    dC2_C2P = [(x5(iplus1) + x5(iminus1) - 2*x5(i))/(4*da^2) (y5(iplus1) + y5(iminus1) - 2*y5(i))/(4*db^2)];
    CpXCpp = [dC_cP(i,:)   dC2_C2P(i,:)];
    k = zeros(samples, 1);
    for j = 1:samples % calculate curvature
       k(j) = (det(reshape(CpXCpp(j,:),2,2)') / norm(dC_cP(j,:))^3);
    end
    sample_points5 = sample_points5 + 0.0005*N.* repmat((abs(k).^(1.0/3)).*sign(k),1,2);
    x5 = sample_points5(:,1);
    y5 = sample_points5(:,2);
    
    % plot:
    
    if mod(iteration, 200) == 1
        subplot(3,5,1+floor(iteration/200));
        plot_curve_points(x4, y4);
        axis([-1 1 -1 1]);
        
        subplot(3,5,1+floor(iteration/200)+5);
        plot_curve_points(x5, y5);
        axis([-1 1 -1 1]);
        
        sample_points6 = sample_points4 * transformation;
        x6 = sample_points6(:,1);
        y6 = sample_points6(:,2);
        subplot(3,5,1+floor(iteration/200)+10);
        plot_curve_points(x6, y6);
        axis([-1 1 -1 1]);
    end
end

