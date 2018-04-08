function [output]=NLmeansfilter(input,win_size,patch_rad,h)
 % Size opatch_rad the image
 [m n]=size(input);
 
 
 % Memory for the output
 output=zeros(m,n);

 % Replicate the boundaries of the input image
 input2 = padarray(input,[patch_rad patch_rad],'symmetric');
 
 % Used kernel
 kernel = make_kernel(patch_rad);
 kernel = kernel / sum(sum(kernel));
 
 h=h*h;
 
 for i=1:m
 for j=1:n
                 
         i1 = i+ patch_rad;
         j1 = j+ patch_rad;
                
         W1= input2(i1-patch_rad:i1+patch_rad , j1-patch_rad:j1+patch_rad);
         
         wmax=0; 
         average=0;
         sweight=0;
         
         rmin = max(i1-win_size,patch_rad+1);
         rmax = min(i1+win_size,m+patch_rad);
         smin = max(j1-win_size,patch_rad+1);
         smax = min(j1+win_size,n+patch_rad);
         
         for r=rmin:1:rmax
         for s=smin:1:smax
                                               
                if(r==i1 && s==j1) continue; end;
                                
                W2= input2(r-patch_rad:r+patch_rad , s-patch_rad:s+patch_rad);                
                 
                d = sum(sum(kernel.*(W1-W2).*(W1-W2)));
                                               
                w=exp(-d/h);                 
                                 
                if w>wmax                
                    wmax=w;                   
                end
                
                sweight = sweight + w;
                average = average + w*input2(r,s);                                  
         end 
         end
             
        average = average + wmax*input2(i1,j1);
        sweight = sweight + wmax;
                   
        if sweight > 0
            output(i,j) = average / sweight;
        else
            output(i,j) = input(i,j);
        end                
 end
 end
 
function [kernel] = make_kernel(f)              
 
kernel=zeros(2*f+1,2*f+1);   
for d=1:f    
  value= 1 / (2*d+1)^2 ;    
  for i=-d:d
  for j=-d:d
    kernel(f+1-i,f+1-j)= kernel(f+1-i,f+1-j) + value ;
  end
  end
end
kernel = kernel ./ f;
