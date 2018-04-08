function blobs = detectBlobs(im, param)
% This code is part of:
%
%   CMPSCI 670: Computer Vision
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji

% Input:
%   IM - input image
%
% Ouput:
%   BLOBS - n x 4 array with blob in each row in (x, y, radius, score)
%
% Dummy - returns a blob at the center of the image
im=rgb2gray(im);
im=im2double(im);
n=25;
[h, w] = size(im); % h, w => height and width of the state space
scalespace = zeros(h, w, n);
sigma=2;
% generate the Laplacian of Gaussian for the first scale level
filt_size = 2*ceil(3*sigma)+1;  % important: to avoid "shifting" artifacts, make sure the kernel size is odd!
LoG =  sigma^2 * fspecial('log', filt_size, sigma);
inc=1.1
imRes = im;
for i = 1:n
    %fprintf('Sigma %f\n', sigma * k^(i-1));
    imFiltered = imfilter(imRes, LoG, 'same', 'replicate'); % filter the image with LoG
    % no scale normalization is needed:  the filter
    % remains the same size while the image is downsampled 
    % so response of the filter is scale-invariant
    imFiltered = imFiltered .^ 2; % save square of the response for current level
    
    % upsample the LoG response to the original image size
    scalespace(:,:,i) = imresize(imFiltered, size(im), 'bicubic'); % bilinear supersampling will result in a loss of spatial resolution
    if i < n        
        imRes = imresize(im, 1/(inc^i), 'bicubic');
    end
end





ord=zeros(h,w,n);
for i = 1:n
    ord(:,:,i) = ordfilt2(scalespace(:,:,i), 9, ones(3,3));
end

for i = 1:n
        ord(:,:,i) = max(ord(:,:,max(i-1,1)),ord(:,:,i));
        ord(:,:,i) = max(ord(:,:,min(i+1,n)),ord(:,:,i));
end
ord = ord .* (ord == scalespace);

r=[];
c=[];
rad=[];
v=[];
%score=[];
threshold=0.007;
ord(ord<threshold)=0;
%disp(sum(sum(ord>0)));
for i=1:n
    [rows, cols,value] = find(ord(:,:,i));
    numBlobs = length(rows);
    radii =  sigma*inc^(i-1) * sqrt(2); 
    radii = repmat(radii, numBlobs, 1);
    r = [r; rows];
    c = [c; cols];
    rad = [rad; radii];
    v=[v;value];
    
    %score=scalespace(:,:,);
end
blobs=[c,r,rad,v];

disp(size(blobs,1));
