% This code is part of:
%
%   CMPSCI 670: Computer Vision
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
% Load images
im = im2double(imread('../data/denoising/saturn.png'));
noise1 = im2double(imread('../data/denoising/saturn-noise2g.png'));
noise2 = im2double(imread('../data/denoising/saturn-noise2sp.png'));

% Compute errors
error1 = sum(sum((im - noise1).^2));
error2 = sum(sum((im - noise2).^2));
fprintf('Input, Errors: %.2f %.2f\n', error1, error2)

% Display the images
figure(1);
subplot(1,3,1); imshow(im); title('Input');
subplot(1,3,2); imshow(noise1); title(sprintf('SE %.2f', error1));
subplot(1,3,3); imshow(noise2); title(sprintf('SE %.2f', error2));

%% Denoising algorithm (Gaussian filtering)
%gaussian(im,noise1,noise2);
%gaussian(im,noise2);




%% Denoising algorithm (Median filtering)
%med(im,noise1,noise2);
%med(im,noise);





%% Denoising alogirthm (Non-local means)

img1=NLmeansfilter(noise1,5,2,1);
img2=NLmeansfilter(noise2,4,2,.25);


error1 = sum(sum((im - img1).^2));
error2 = sum(sum((im - img2).^2));
figure(2);
subplot(1,3,1); imshow(im); title('Input');
subplot(1,3,2); imshow(img1); title(sprintf( 'SE %.2f',error1));
subplot(1,3,3); imshow(img2); title(sprintf(' SE %.2f',error2));
fprintf('Input, Errors: %.2f %.2f \n', error1, error2)


