function features = extractDigitFeatures(x, featureType)
% EXTRACTDIGITFEATURES extracts features from digit images
%   features = extractDigitFeatures(x, featureType) extracts FEATURES from images
%   images X of the provided FEATURETYPE. The images are assumed to the of
%   size [W H 1 N] where the first two dimensions are the width and height.
%   The output is of size [D N] where D is the size of each feature and N
%   is the number of images. 

switch featureType
    case 'pixel'
        features = zeroFeatures(x);
    case 'hog'
        features = zeroFeatures2(x);
    case 'lbp'
        features = zeroFeatures3(x);
end

function features = zeroFeatures(x)
features=reshape(x,[784,2000]);
for i=1:2000
features(:,i)=features(:,i)/norm(features(:,i)+0.00000001);
%features(:,i)=sqrt(features(:,i));
end
%disp(size(x));
end

function features = zeroFeatures2(x)
for i=1:2000
sobel = fspecial('sobel');
gx = imfilter(x(:,:,:,i),sobel);

% invert kernel to detect vertical edges
sobel = sobel';
gy=imfilter(x(:,:,:,i),sobel);
gy=gy';

mag=sqrt(gx.^2+gy.^2);
angles=atan2(gy,gx);

angles=angles.*(angles>=0)+(angles+pi).*(angles<0);
%angles(isnan(angles))=0;
%mag(isnan(mag))=0;

%binSize_x=4;
%binSize_y=4;
binSize=14;
step_x=size(angles,1)/binSize;
step_y=size(angles,1)/binSize;

ori_bins=12;
hist=zeros(binSize*binSize,ori_bins);
count=0;
for n=0:binSize-1
    for m=0:binSize-1
        count=count+1;
        angles_patch=angles((n*step_y)+1:(n+1)*step_y,(m*step_x)+1:(m+1)*step_x); 
        mag_patch=mag((n*step_y)+1:(n+1)*step_y,m*step_x+1:(m+1)*step_x);
        for q=1:step_y
            for p=1:step_x
               ang=angles_patch(q,p);
               bin1=floor(ang/(pi/ori_bins));
               bin2=bin1+1;
               
               one=ang-((pi/ori_bins)*bin1);
               two=((pi/ori_bins)*bin2-ang);
               hist(count,mod(bin1,ori_bins)+1)=((two)/(pi/ori_bins))*mag_patch(q,p);
               hist(count,mod(bin2,ori_bins)+1)=((one)/(pi/ori_bins))*mag_patch(q,p);
            end
         end
      end
                
        %H2=H2/(norm(H2)+0.01);        
        %H((cont-1)*B+1:cont*B,1)=H2;
end
 %disp(size(hist));
 
 [height, width]=size(hist);
%if(i==1)
 %   disp(size(hist));
%end
 hist=reshape(hist,[height*width,1]);
 features(:,i)=hist;
 features(:,i)=sqrt(features(:,i));
 features(:,i)=features(:,i)./norm(features(:,i)+0.0000001);
 %features(:,i)=features(:,i)/sqrt(sum(features(:,i).^2));
end

    end


function features = zeroFeatures3(x)
 
    
    
    bin_arr=[1,2,4;
        8,0,16;
        32,64,128];
     [h ,w]=size(x(:,:,:,1));  
     disp(size(x(:,:,:,1)));
      f=fspecial('log');
     count=zeros(256,2000);  
     for i=1:2000
    
        img=x(:,:,1,i);
        img=imfilter(img,f);
        
        for n=2:1:h-1
        for m=2:1:w-1
           %pixel=x(n,m);
           arr=img(n-1:1:n+1,m-1:1:m+1);
           pixel=arr(2,2);
           arr=arr-pixel;
           %disp(arr);
           arr=(arr>0);
           
           %disp(arr);
           
           %arr=arr(:,1);
           arr=arr.*bin_arr;
           value=sum(sum(arr));
           %disp(value);
           count(value+1,i)=count(value+1,i)+1;
           %features(n-1,m-1,i)=value; 
   
        end
        end
        %count(:,i)=count(:,i)./sqrt(sum(count(:,i).^2));
%disp(count(:,i));
count(:,i)=sqrt(count(:,i));  
count(:,i)=count(:,i)/norm(count(:,i)+0.00000001,2);

        
 % if(i==1)
    %disp(count(:,i));
    %end
     end
     
    features=count;
%features = extractLBPFeatures(x)
end
end