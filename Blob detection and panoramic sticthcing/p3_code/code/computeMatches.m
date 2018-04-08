function m = computeMatches(f1,f2)



[n ,d]=size(f1);
[m ,d]=size(f2);
%disp(n);
%disp(m);
%disp(n);
%disp(m);
%disp(d);
arr1=[];
%arr2=zeros(m);

for i=1:n
  ssd=0;
  min1=intmax;
  min2=intmax;
  indice1=0;
    for j=1:m
    
        ssd=sum(sum((f1(i,:)-f2(j,:)).^2));
        
        if(ssd<min1)    
            min1=ssd;
            indice1=j;
            if(min2==intmax)
                min2=min1;
            end
            
        
        elseif(ssd<min2)
            min2=ssd;
            
        end
        
    end
    
    if(min1/min2<0.8)
     arr1=[arr1;indice1];
     
    else
     arr1=[arr1;0];
    end
end

m=arr1;


