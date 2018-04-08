% Evaluation code for image stitching
% Your goal is to implement image stitching with RANSAC 
%
% This code is part of:
%
%   CMPSCI 670: Computer Vision
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji

imageName = 'einstein.jpg';
numBlobsToDraw = 1000;
imName = imageName(1:end-4);

dataDir = fullfile('..','..','p3_data','data','blobs');
im = imread(fullfile(dataDir, imageName));


%% Implement the code to detect blobs here
blobs = detectBlobs_dog(im);

%% Draw blobs on the image
drawBlobs(im, blobs, numBlobsToDraw);
title('Blob detection');