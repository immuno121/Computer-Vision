function output = prepareData(imArray, ambientImage)
% PREPAREDATA prepares the images for photometric stereo
%   OUTPUT = PREPAREDATA(IMARRAY, AMBIENTIMAGE)
%
%   Input:
%       IMARRAY - [h w n] image array
%       AMBIENTIMAGE - [h w] image 
%
%   Output:
%       OUTPUT - [h w n] image, suitably processed
%
% Author: Subhransu Maji
%

% Implement this %
% Step 1. Subtract the ambientImage from each image in imArray
% Step 2. Make sure no pixel is less than zero
% Step 3. Rescale the values in imarray to be between 0 and 1
%for i=1:3
%imArray(:,:,i)=[0 2 3;1 2 3;0 2 3];
%disp(imArray);
%end
%disp(imArray);
%ambientImage=ones(3,3);
%
%if(ambientImage(:,:)==0)
%disp(ambientImage);
%end
temp=imArray;
n=size(imArray,3);
h=size(imArray,1);
w=size(imArray,2);
tzero=zeros(h,w);
%disp(n);
for i=1:n
     imArray(:,:,i)=imArray(:,:,i)-ambientImage(:,:);
     imArray(imArray(:,:)<0)=0;
    %m1=(min(min(imArray(:,:,i))));
     %disp(max(max(imArray(:,:,i))));
 
     
 %imArray(:,:,i)=(imArray(:,:,i)-min(min(imArray(:,:,i))))./(max(max(imArray(:,:,i))))-(min(min(imArray(:,:,i)))); 
 imArray(:,:,i)= imArray(:,:,i)./(max(max(imArray(:,:,i))));
 %disp(max(max(imArray(:,:,i))));
    %m2=(min(min(imArray(:,:,i)))); 
    %if(m1==m2)
     %disp(1);
    % end

end
output=imArray;
