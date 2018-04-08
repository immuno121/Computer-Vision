function output = demosaicImage(im, method)
% DEMOSAICIMAGE computes the color image from mosaiced input
%   OUTPUT = DEMOSAICIMAGE(IM, METHOD) computes a demosaiced OUTPUT from
%   the input IM. The choice of the interpolation METHOD can be 
%   'baseline', 'nn', 'linear', 'adagrad'. 
%
% This code is part of:
%
%   CMPSCI 670: Computer Vision
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%

switch lower(method)
    case 'baseline'
        output = demosaicBaseline(im);
    case 'nn'
        output = demosaicNN(im);         % Implement this
    case 'linear'
        output = demosaicLinear(im);     % Implement this
    case 'adagrad'
        output = demosaicAdagrad(im);    % Implement this
    case 'transform'
        output= demosaicTransform(im);
    case 'transform2'
        output= demosaicTransform2(im);

end

%--------------------------------------------------------------------------
%                          Baseline demosacing algorithm. 
%                          The algorithm replaces missing values with the
%                          mean of each color channel.
%--------------------------------------------------------------------------
function mosim = demosaicBaseline(im)
mosim = repmat(im, [1 1 3]); % Create an image by stacking the input
[M, N] = size(im);

% Red channel (odd rows and columns);
redValues = im(1:2:M, 1:2:N);
meanValue = mean(mean(redValues));
mosim(:,:,1) = meanValue;
mosim(1:2:M, 1:2:N,1) = im(1:2:M, 1:2:N);

% Blue channel (even rows and colums);
B = im(2:2:M, 2:2:N);
meanValue = mean(mean(B));
mosim(:,:,3) = meanValue;
mosim(2:2:M, 2:2:N,3) = im(2:2:M, 2:2:N);

% Green channel (remaining places)
% We will first create a mask for the green pixels (+1 green, -1 not green)
mask = ones(M, N);
mask(1:2:M, 1:2:N) = -1;
mask(2:2:M, 2:2:N) = -1;
G = mosim(mask > 0);
meanValue = mean(G);
% For the green pixels we copy the value
greenChannel = im;
greenChannel(mask < 0) = meanValue;
mosim(:,:,2) = greenChannel;

%--------------------------------------------------------------------------
%                           Nearest neighbour algorithm
%--------------------------------------------------------------------------
function mosim = demosaicNN(im)
M = size(im, 1);
N = size(im, 2);

red_mask = repmat([1 0; 0 0], ceil(M/2), ceil(N/2));
green_mask = repmat([0 1; 1 0], ceil(M/2), ceil(N/2));
blue_mask = repmat([0 0; 0 1], ceil(M/2), ceil(N/2));


  if(mod(M,2)==1)
   red_mask(size(red_mask,1),:)=[];
   blue_mask(size(blue_mask,1),:)=[];
   green_mask(size(green_mask,1),:)=[];
  end
  if(mod(N,2)==1)
   red_mask(:,size(red_mask,2))=[];
   blue_mask(:,size(blue_mask,2))=[];
   green_mask(:,size(green_mask,2))=[];
   end
    R=im.*red_mask;
    G=im.*green_mask;
    B=im.*blue_mask;
mosim = repmat(im, [1 1 3]); 
mosim(1:2:M-1, 1:2:N-1,2) = im(1:2:M-1, 2:2:N);
mosim(2:2:M, 2:2:N,2) = im(2:2:M, 1:2:N-1);
  
% red pixels
mosim(1:2:M-1, 2:2:N,1) = im(1:2:M-1, 1:2:N-1);
mosim(2:2:M, 1:2:N-1,1) = im(1:2:M-1, 1:2:N-1);
mosim(2:2:M, 2:2:N,1) = mosim(2:2:M, 1:2:N-1,1);
 
%blue pixels
mosim(1:2:M-1, 1:2:N-1,3) = im(2:2:M, 2:2:N);
mosim(1:2:M-1, 2:2:N,3) = im(2:2:M, 2:2:N);
mosim(2:2:M, 1:2:N-1,3) = im(2:2:M, 2:2:N);
mosim(M,1:2:N-1,3) = im(M-1, 2:2:N);
mosim(M,N,3) = im(M-1,N-1);
 
    %mosim(:,:,1)=R;
    %mosim(:,:,2)=G;
    %mosim(:,:,3)=B;




%--------------------------------------------------------------------------
%                           Linear interpolation
%--------------------------------------------------------------------------
function mosim = demosaicLinear(im)
M = size(im, 1);
N = size(im, 2);
mosim = repmat(im, [1 1 3]); % Create an image by stacking the input

% Red channel (odd rows and columns);%

red_mask = repmat([1 0; 0 0], ceil(M/2), ceil(N/2));
green_mask = repmat([0 1; 1 0], ceil(M/2), ceil(N/2));
blue_mask = repmat([0 0; 0 1], ceil(M/2), ceil(N/2));

  if(mod(M,2)==1)
   red_mask(size(red_mask,1),:)=[];
   blue_mask(size(blue_mask,1),:)=[];
   green_mask(size(green_mask,1),:)=[];
  end
  if(mod(N,2)==1)
   red_mask(:,size(red_mask,2))=[];
   blue_mask(:,size(blue_mask,2))=[];
   green_mask(:,size(green_mask,2))=[];
   end
    R=im.*red_mask;
    G=im.*green_mask;
    B=im.*blue_mask;
    
% Interpolation for the green at the missing points
    G= G + imfilter(G, [0 1 0; 1 0 1; 0 1 0]/4);
    %disp(G);
    B1 = imfilter(B,[1 0 1; 0 0 0; 1 0 1]/4,'circular');%red pos
    B2 = imfilter(B,[0 1 0; 1 0 1; 0 1 0]/2,'circular');%green pos
    B = B + B1 + B2;
    
% Interpolation for the red at the missing points
% First, calculate the missing red pixels at the blue location
redValues = im(1:2:M, 1:2:N);
meanValue = mean(mean(redValues));

R1 = imfilter(R,[1 0 1; 0 0 0; 1 0 1]/4);
% Second, calculate the missing red pixels at the green locations   
R2 = imfilter(R,[0 1 0; 1 0 1; 0 1 0]/2);
  R = R + R1 + R2;
    

    mosim(:,:,1)=R; mosim(:,:,2)=G; mosim(:,:,3)=B;

%--------------------------------------------------------------------------
%                           Adaptive gradient
%--------------------------------------------------------------------------
function mosim = demosaicAdagrad(im)
M = size(im, 1);
N = size(im, 2);

red_mask = repmat([1 0; 0 0], ceil(M/2), ceil(N/2));
green_mask = repmat([0 1; 1 0], ceil(M/2), ceil(N/2));
blue_mask = repmat([0 0; 0 1], ceil(M/2), ceil(N/2));


  if(mod(M,2)==1)
   red_mask(size(red_mask,1),:)=[];
   blue_mask(size(blue_mask,1),:)=[];
   green_mask(size(green_mask,1),:)=[];
  end
  if(mod(N,2)==1)
   red_mask(:,size(red_mask,2))=[];
   blue_mask(:,size(blue_mask,2))=[];
   green_mask(:,size(green_mask,2))=[];
   end
    R=im.*red_mask;
    G=im.*green_mask;
    B=im.*blue_mask;
    mosim=zeros(M,N,3);
%edge cases    
%G(1,1)=G(1,3);
%G(M,N)=G(M-1,N-1);
hgrad=imfilter(G,[1 0 -1],'circular');
hgrad=abs(hgrad);
vgrad=imfilter(G,[1; 0; -1],'circular');
vgrad=abs(vgrad);
mask1=(hgrad>vgrad);
mask2=(hgrad<vgrad);
mask3=(hgrad==vgrad);
vkernel=imfilter(G,[1;0;1]/2,'circular');
hkernel=imfilter(G,[1 0 1]/2,'circular');
kernel=imfilter(G,[0 1 0;1 0 1;0 1 0]/4,'circular');
G=G+vkernel.*mask1+hkernel.*mask2+mask3.*kernel;


    B1 = imfilter(B,[1 0 1; 0 0 0; 1 0 1]/4,'circular');
    B2 = imfilter(B,[0 1 0; 1 0 1; 0 1 0]/2,'circular');
    B = B + B1 + B2;
    R1 = imfilter(R,[1 0 1; 0 0 0; 1 0 1]/4);
    R2 = imfilter(R,[0 1 0; 1 0 1; 0 1 0]/2);
    R = R + R1 + R2;
    mosim(:,:,1)=R; 
    mosim(:,:,3)=B;
    mosim(:,:,2)=G; 
   


%--------------------------------------------------------------------------------

function mosim = demosaicTransform(im)
M = size(im, 1);
N = size(im, 2);

red_mask = repmat([1 0; 0 0], ceil(M/2), ceil(N/2));
green_mask = repmat([0 1; 1 0], ceil(M/2), ceil(N/2));
blue_mask = repmat([0 0; 0 1], ceil(M/2), ceil(N/2));

  if(mod(M,2)==1)
   red_mask(size(red_mask,1),:)=[];
   blue_mask(size(blue_mask,1),:)=[];
   green_mask(size(green_mask,1),:)=[];
  end
  if(mod(N,2)==1)
   red_mask(:,size(red_mask,2))=[];
   blue_mask(:,size(blue_mask,2))=[];
   green_mask(:,size(green_mask,2))=[];
  end
    R=im.*red_mask;
    G=im.*green_mask;
    B=im.*blue_mask;

    
    
    G=G+imfilter(G,[0 1 0;1 0 1;0 1 0]/4);
    
    l=min(min(G(G~=0)));    
    G(G==0)=l;  
     R=R./G;
        B=B./G;
    R1=imfilter(R,[1 0 1;0 0 0;1 0 1]/4);
    R2=imfilter(R,[0 1 0;1 0 1;0 1 0]/2);
    
    B1=imfilter(B,[1 0 1;0 0 0;1 0 1]/4);
    B2=imfilter(B,[0 1 0;1 0 1;0 1 0]/2);
    
    R=R+R1+R2;
    R=R.*G;
    
    B=B+B1+B2;
    B=B.*G;
   
   
    
    
    mosim(:,:,1)=R;
    mosim(:,:,3)=B;
    mosim(:,:,2)=G;
    
%-----------------------------------------------------------------------------
function mosim = demosaicTransform2(im)
M = size(im, 1);
N = size(im, 2);

red_mask = repmat([1 0; 0 0], ceil(M/2), ceil(N/2));
green_mask = repmat([0 1; 1 0], ceil(M/2), ceil(N/2));
blue_mask = repmat([0 0; 0 1], ceil(M/2), ceil(N/2));

  if(mod(M,2)==1)
   red_mask(size(red_mask,1),:)=[];
   blue_mask(size(blue_mask,1),:)=[];
   green_mask(size(green_mask,1),:)=[];
  end
  if(mod(N,2)==1)
   red_mask(:,size(red_mask,2))=[];
   blue_mask(:,size(blue_mask,2))=[];
   green_mask(:,size(green_mask,2))=[];
  end
    R=im.*red_mask;
    G=im.*green_mask;
    B=im.*blue_mask;

    
    
    G=G+imfilter(G,[0 1 0;1 0 1;0 1 0]/4);
    l=min(min(B(B~=0)));    
    B(B==0)=l;
    
    l=min(min(R(R~=0)));    
    R(R==0)=l;
    
    l=min(min(G(G~=0)));    
    G(G==0)=l;
   
   
    R=(log(R./G));
    B=(log(B./G));
   
    R=R.*red_mask;
    B=B.*blue_mask;
   
    
    R1=imfilter(R,[1 0 1;0 0 0;1 0 1]/4);
    R2=imfilter(R,[0 1 0;1 0 1;0 1 0]/2);
    
    
    R=R+R1+R2;
    
   
    
    B1=imfilter(B,[1 0 1;0 0 0;1 0 1]/4);
    B2=imfilter(B,[0 1 0;1 0 1;0 1 0]/2);
    
    B=B+B1+B2;
    
    R=exp(R).*G;
    B=exp(B).*G;
    
    mosim(:,:,1)=R;
    
    mosim(:,:,3)=B;
    mosim(:,:,2)=G;
    
    

   
    
