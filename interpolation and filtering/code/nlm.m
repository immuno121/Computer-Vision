function [denoise, error] = nlm(impath, p, w, gamma)

    im = im2double(imread(impath));
    
    fprintf('%s\n', impath);
    tic;

    im = padarray(im, [floor(w/2) floor(w/2)], 0); 
    %padding for the windowing to work
    im = padarray(im, [floor(p/2) floor(p/2)], 0);
    %padding for the patches to work
    
    [imageHeight, imageWidth] = size(im);
    denoise = zeros(size(im));

    p_radius = floor(p/2);
    w_radius = floor(w/2);
    
    for     x=(1 + p_radius + w_radius):(imageHeight - p_radius - w_radius)
        
        for y=(1 + p_radius + w_radius):(imageWidth  - p_radius - w_radius)
            
            patch_X = im(x - p_radius:x + p_radius,...
                            y - p_radius:y + p_radius);

                        
            imValues = zeros(1,w*w);
    
            patches = zeros(p,p,w*w);
            
            idx=1;
            
            for m=x-w_radius:x+w_radius
                for n=y-w_radius:y+w_radius
                    patches(:,:,idx)= im(m - p_radius:m + p_radius,...
                                         n - p_radius:n + p_radius);
                    imValues(1, idx) = im(m,n);
                    idx= idx+1;
                end
            end
            
            difference = bsxfun(@minus, patches, patch_X);
            ssd = sum(sum(difference.^2));
            exponential = exp(-gamma*ssd);
            exponential = reshape(exponential,1, []);

            numerator = sum(exponential.*imValues);

            denominator = sum(exponential);
            denoise(x,y) = numerator/denominator;
        end
    end    
    
    error = sum(sum((denoise-im).^2));
    toc;
end
