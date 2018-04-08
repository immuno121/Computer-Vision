function [albedoImage, surfaceNormals] = photometricStereo(imArray, lightDirs)
% PHOTOMETRICSTEREO compute intrinsic image decomposition from images
%   [ALBEDOIMAGE, SURFACENORMALS] = PHOTOMETRICSTEREO(IMARRAY, LIGHTDIRS)
%   comptutes the ALBEDOIMAGE and SURFACENORMALS from an array of images
%   with their lighting directions. The surface is assumed to be perfectly
%   lambertian so that the measured intensity is proportional to the albedo
%   times the dot product between the surface normal and lighting
%   direction. The lights are assumed to be of unit intensity.
%
%   Input:
%       IMARRAY - [h w n] array of images, i.e., n images of size [h w]
%       LIGHTDIRS - [n 3] array of unit normals for the light directions
%
%   Output:
%        ALBEDOIMAGE - [h w] image specifying albedos
%        SURFACENORMALS - [h w 3] array of unit normals for each pixel
%
% Author: Subhransu Maji
%
% Acknowledgement: Based on a similar homework by Lana Lazebnik
%pixel=(64*64,n);




%%% implement this %% 
h=size(imArray,1);
w=size(imArray,2);
n=size(imArray,3);
%pixel=[h*w;n];
pixel=reshape(imArray,h*w,n);

%{
for i=1:h
    for j=1:w
        k=i*j;
        pixel(k,:)=imArray(i,j,:);
        
        
    end
end
%}
pixel=pixel';%pixel=n*p

g=lightDirs\pixel;%g=3*p
%if((lightDirs*g)==pixel)
%disp(7);
%end
%t=lightDirs*g;
%disp(t(:,1)==pixel(:,1));
%disp(pixel(:,1));
%disp(size(t));
%disp('---------------------------------------------------------');
%disp(t(:,1));
g=g';%p*3
%disp(g);
g=reshape(g,h,w,3);
albedoImagetemp=zeros(h,w);
surfaceNormalstemp=zeros(h,w,3);
for i=1:h%h
    for j=1:w%w
        sv=g(i,j,:).*g(i,j,:);
        %disp(i);disp(j);
       % disp(sv);
        dp=sum(sv(1,1,:));
        %disp(size(sum));
        %disp(size(dp));
       albedoImagetemp(i,j)=sqrt(dp);
       surfaceNormalstemp(i,j,:)=g(i,j,:)./albedoImagetemp(i,j);
      
    end
end

albedoImage=albedoImagetemp;
surfaceNormals=surfaceNormalstemp;
%disp(det(surfaceNormals));





