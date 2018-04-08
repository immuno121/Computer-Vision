function result=gaussian(im,noise1,noise2)

k=[11,15,21,31,41,51,101,131];
s=[2 3 6 10 12 15 20];
min1=10000000;
min2=10000000;

k_gaussian=0;
k_sp=0;
sigma_gaussian=0;
sigma_sp=0;
finalg=zeros(size(im));
finalsp=zeros(size(im));

for i=1:length(k)
    for sigma=1:length(s)
 f=fspecial('gaussian',k(i),k(i)/s(sigma));
 result=imfilter(noise1,f);
 salt=imfilter(noise2,f);
error1 = sum(sum((im - result).^2));
error2 = sum(sum((im - salt).^2));

if(error1<min1)
    min1=error1;
    k_gaussian=k(i);
    sigma_gaussian=s(sigma);
    finalg=result;
end

if(error2<min2)
    min2=error2;
    k_sp=k(i);
   sigma_sp=s(sigma);
   finalsp=salt;
end
%fprintf('filter, Errors: %.2f %.2f %.2f\n',k(i),s(sigma), error1);
    end
end
fprintf('best, Errors: %.2f %.2f %.2f\n',k_gaussian,sigma_gaussian, min1);
fprintf('best, Errors: %.2f %.2f %.2f\n',k_sp,sigma_sp, min2);

figure(2);
subplot(1,3,1); imshow(im); title('Input');
subplot(1,3,2); imshow(finalg); title(sprintf('SE %.2f', min1));
subplot(1,3,3); imshow(finalsp); title(sprintf('SE %.2f', min2));


