function result=med(im,noise1,noise2)

 
k=[3,5,9,11,15,21,31,41,51];
min1=Inf;
min2=Inf;
finalg=zeros(size(im));
finalsp=zeros(size(im));

k_gaussian=0;
k_sp=0;
for i=1:length(k)
result=medfilt2(noise1,[k(i) k(i)]);
salt=medfilt2(noise2,[k(i) k(i)]);
error1 = sum(sum((im - result).^2));
error2 = sum(sum((im - salt).^2));

if(error1<min1)
    min1=error1;
    k_gaussian=k(i);
    finalg=result;
end

if(error2<min2)
    min2=error2;
    k_sp=k(i);
    finalsp=salt;
end
end
fprintf('best, Errors:  %.2f %.2f\n',k_gaussian, min1);
fprintf('best, Errors:  %.2f %.2f\n',k_sp ,min2);

figure(2);
subplot(1,3,1); imshow(im); title('Input');
subplot(1,3,2); imshow(finalg); title(sprintf('Kernel size %dx%d SE %.2f\n',k_gaussian,k_gaussian ,min1));
subplot(1,3,3); imshow(finalsp); title(sprintf('Kernel size %dx%d SE   %.2f\n',k_sp,k_sp ,min2 ));



 