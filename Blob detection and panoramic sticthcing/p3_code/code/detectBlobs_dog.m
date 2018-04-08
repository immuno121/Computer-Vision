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

[h,w]=size(im);

n=25;
scalespace = zeros(h,w,n);
i=2;
k=1;
inc=1.1;
scale=zeros(n);
%score=zeros(n);

while(k<=n)
filt_size=2*ceil(3*i)+1;


    g1 = fspecial('gaussian', filt_size, 1.1*i);
    g2 = fspecial('gaussian', filt_size, i);
    dog = g1 - g2;
    f = conv2(double(im),dog,'same');
    scalespace(:,:,k) = f;
    scale(k)=i;
    i=i*inc;
    k=k+1;
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
threshold=0.0024;
ord(ord<threshold)=0;
%disp(sum(sum(ord>0)));
for i=1:n
    [rows, cols,value] = find(ord(:,:,i));
    numBlobs = length(rows);
    radii =  scale(i) * sqrt(2); 
    radii = repmat(radii, numBlobs, 1);
    r = [r; rows];
    c = [c; cols];
    rad = [rad; radii];
    v=[v;value];
    
    %score=scalespace(:,:,);
end
blobs=[c,r,rad,v];

disp(size(blobs,1));
