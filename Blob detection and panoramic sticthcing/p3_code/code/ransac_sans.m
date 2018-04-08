function [inliers, transf] = ransac(matches, c1, c2, method)
% This code is part of:
%
%   CMPSCI 670: Computer Vision
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji\
 
N = length(matches);
M = length(c2);
maxNoOfInliers = 0;
iter = 0;
maxInliers = [];
c2_val = [c2(:,1:2) ones(M,1)];
while(iter<35)

    while true
        r1 = ceil(1 + (N-1).*rand(1,1));
        if matches(r1)~=0
            break
        end
    end
    while true
        r2 = ceil(1 + (N-1).*rand(1,1));
        if matches(r2)~=0 && r1~=r2
            break
        end
    end
    while true
        r3 = ceil(1 + (N-1).*rand(1,1));
        if matches(r3)~=0 && r3~=r2 && r1~=r2
            break
        end
    end
    A = [c2(matches(r1),1) c2(matches(r1),2) 0 0 1 0; 0 0 c2(matches(r1),1) c2(matches(r1),2) 0 1;c2(matches(r2),1) c2(matches(r2),2) 0 0 1 0;0 0 c2(matches(r2),1) c2(matches(r2),2) 0 1; c2(matches(r3),1) c2(matches(r3),2) 0 0 1 0;0 0 c2(matches(r3),1) c2(matches(r3),2) 0 1];
    B = [c1(r1,1); c1(r1,2);c1(r2,1); c1(r2,2); c1(r3,1); c1(r3,2)];
    X = A\B;
    transf = reshape(X,[2,3])';
    X_new = c2_val*transf;
    no_of_inliers=0;
    inliers = [];
    for i=1:N
        if(matches(i)~=0)
            if ((X_new(matches(i),2) - c1(i,2))^2 + (X_new(matches(i),1) - c1(i,1))^2) < 10
                inliers = [inliers; i];
                no_of_inliers = no_of_inliers+1;
            end
        end
    end
    if maxNoOfInliers < no_of_inliers
        maxNoOfInliers = no_of_inliers;
        maxInliers = inliers;
        maxTransf = reshape(transf,[3,2])';
    end
    iter = iter +1;
end
transf = maxTransf;
no_of_inliers = maxNoOfInliers;
inliers = maxInliers;

