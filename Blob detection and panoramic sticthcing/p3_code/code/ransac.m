function [inliers, transf] = ransac(matches, c1, c2, method)
% This code is part of:
%
%   CMPSCI 670: Computer Vision
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
length(matches)

N = length(matches);
M=size(c2,1);
temp=[];
for i=1:M
temp=[temp;([c2(i,1) c2(i,2)])];
end

adjust=ones(M,1);
temp=[temp adjust];
maxinlier=0;
inliers=[];
for pk=1:35   
rand_arr=[];
r=randi([1,N],1,1);
count=1;

check=[];
while(count<=3)%loop till we find 3 indeices
    
        if(matches(r,1)~=0)% check if a match exists
            
        rand_arr=[rand_arr;r];%store it
        count=count+1;
        end
        r=randi([1,N],1,1);
        if(length(rand_arr)~=0)
        for w=1:length(rand_arr)
            num=rand_arr(w);
    
        while(r==num)% check if 2 or more blobs map to same blob
            r=randi([1,N],1,1);%if yes, select another indice or else it will result in a system 
                           % of linear equations which are not independent.
        end
    
    end
        end
end
A=[];
B=[];

for i=1:length(rand_arr)
index=rand_arr(i);

x1=c1(index,1);
y1=c1(index,2);

A=[A;([x1 y1])];%3X2

x_ans=c2(matches(index),1);
y_ans=c2(matches(index),2);

B=[B;([x_ans,y_ans,1])];%3X3
end


%Ax=b---->(3X3  3X2  =  3X2)
transform=B\A;%3X2
result=temp*transform;

inlier=0;

optimal=[];
for i=1:N

if(matches(i)~=0)    
x1=(c1(i,1));
y1=(c1(i,2));
if(((x1-result(matches(i),1))^2+((y1)-result(matches(i),2))^2)<=20)     
inlier=inlier+1;
optimal=[optimal;i];
end
end
end

%while(matches)

%disp(inlier);
if(inlier>maxinlier)
    inliers=optimal;
    maxinlier=inlier;
    transf=transform';
    disp(transf);
    %disp(inlier)

end
%transf=reshape(transform_inv,[2 3]);%
%transf=pinv(transf);
%transf(1,3)=transf(1,3)*-1;
%transf(2,3)=transf(2,3)*-1;

%inliers=
%transf=([m1 m2 t1;m3 m4 t2]);

end



