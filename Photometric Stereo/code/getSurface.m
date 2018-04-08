function  heightMap = getSurface(surfaceNormals, method)
%GETSURFACE computes the surface depth from normals
%   HEIGHTMAP = GETSURFACE(SURFACENORMALS, IMAGESIZE, METHOD) computes
%   HEIGHTMAP from the SURFACENORMALS using various METHODs. 
%  
% Input:
%   SURFACENORMALS: height x width x 3 array of unit surface normals
%   METHOD: the intergration method to be used
%
% Output:
%   HEIGHTMAP: height map of object
h=size(surfaceNormals,1);
w=size(surfaceNormals,2);
n=size(surfaceNormals,3);
p=zeros(h,w);
q=zeros(h,w);
depth=zeros(h,w);
for i=1:h
    for j=1:w
        p(i,j)=surfaceNormals(i,j,1)/surfaceNormals(i,j,3);%dz/dx
        q(i,j)=surfaceNormals(i,j,2)/surfaceNormals(i,j,3);%dz/dy
 
       
    end
end    
cs1=zeros(h,w);
cs2=zeros(h,w);
cs1=cumsum(p,2);
cs2=cumsum(q,1);
depth=zeros(h,w);
depth1=zeros(h,w);
depth2=zeros(h,w);
switch method
    case 'column'
           for i=1:h
               for j=1:w
               depth(i,j)=sum(q(1:i, 1)) + sum(p(i,1:j));  
               %depth(i,j)=cs2(i,1)+cs1(i,j);
               end
           end
        %heightMap=depth;
        
        
        
        %%% implement this %%%
    case 'row'
        for i=1:h
             for j=1:w
              %depth(i,j)=sum(q(1:i, j)) + sum(p(1,1:j));  
            
               depth(i,j)=(cs1(1,j))+cs2(i,j);
            end
            
        end
        %heightMap=depth;
        
        %%% implement this %%%
    case 'average'
        
        %method='row';
         for i=1:h
             for j=1:w
               %depth1(i,j)= sum(p(1,1:j))+sum(q(1:i, j));  
            
               depth1(i,j)=cs1(1,j)+cs2(i,j);
            end
            
        end
        
        %method='column';
          for i=1:h
               for j=1:w
               %depth2(i,j)=sum(q(1:i, 1)) + sum(p(i,1:j));  
               depth2(i,j)=cs2(i,1)+cs1(i,j);
               end
           end
        
        depth=(depth1+depth2)/2;
        %%% implement this %%%
    case 'random'
             
        % randomly choose a method
        
       num_paths=7;
       
        for i=1:h %for each pixel
            for j=1:w
                  total_height=0;   
                for k=1:num_paths %choose no of paths from 1
                        
                    path_height=0;
                    prev_i=1;prev_j=1;% start with 1,1 for every path
                    rand_i=1;rand_j=1;
                    
                      while(prev_i<i || prev_j<j) % loop till you reach i,j for each path
                    
                          %sprintf('%f_prev_i', prev_i)
                          %sprintf('%f_prev_j', prev_j)
                          if(prev_i~=i)
                          rand_i=randi([prev_i+1,i]);% for every iteration,choose a pixel between prev_i and i
                   
                          end
                          %disp((rand_i));
                   if(prev_j~=j)
                   rand_j=randi([prev_j+1,j]);
                   end
                   rand_num=randi(3);
             switch rand_num
                 case 1
                       %rand_method='row';
                        %for a=prev_i:rand_i
                          %  for b=prev_j:rand_j
              %depth(i,j)=sum(q(1:i, j)) + sum(p(1,1:j));
             
             temp=sum(p(prev_i,prev_j:rand_j))+sum(q(prev_i:rand_i,rand_j));

              
                 case 2
                       %column
                     %for a=prev_i:rand_i
                       %for b=prev_j:rand_j
               %depth(i,j)=sum(q(1:i, 1)) + sum(p(i,1:j));  
               %temp=cs2(a,prev_j)+cs1(a,b);
              %disp(size(temp));
                       
                     temp=sum(q(prev_i:rand_i,prev_j))+sum(p(rand_i,prev_j:rand_j));
               
                 case 3
                       %rand_method='average';
             temp1=sum(p(prev_i,prev_j:rand_j))+sum(q(prev_i:rand_i,rand_j));
             temp2=sum(q(prev_i:rand_i,prev_j))+sum(p(rand_i,prev_j:rand_j));
               
                       
                       temp=(temp1+temp2)./2;       
             %disp(temp);
             %disp(size(temp));
             end
             
             
             
             
             
             
             
             
             prev_i=rand_i;
             prev_j=rand_j;
             %disp(size(temp));
             %disp(temp);
             path_height=path_height+temp;
                    %disp(size(prev_i));
                    %disp(prev_j);
              
                      end
                       %disp(size(total_height));
                     total_height=total_height+path_height;
                    
                
                     %path_height=0;
                end
                
                %%disp(size(total_height));
                %disp(total_height);
                depth(i,j)=total_height/num_paths;
                  
            
            end
        end
        
        
        
        
        
        
        
        
        
        
        
end
heightMap=depth;

