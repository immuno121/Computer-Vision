%% Denoising alogrithm (Non-local means)


clc;    
% grab window from image. grab patch from image.


images= {'../data/denoising/saturn-noise1g.png', ...
         '../data/denoising/saturn-noise2g.png', ...
         '../data/denoising/saturn-noise1sp.png', ...
         '../data/denoising/saturn-noise2sp.png'};
windows = [9, 11, 15, 17, 19, 21];
leastError = Inf;
bestP=0;
bestGamma=0;
bestW=0;
bestImage = 0;


for i=1:length(windows)
    w = windows(i);
    for p=5:2:w-2 %patch sizes
    gammas = [5,10, 25,50];
        for g=1:length(gammas)
            [denoise1, error1] = nlm(images{1},p,w,gammas(g));
            if error1<leastError
                leastError = error1;
                bestGamma = gammas(g);
                bestP = p;
                bestImage = denoise1;
                bestWindow = w;
            end
        end
    end
end

fprintf('SE %.2f, Gamma %.2f, Window %d P %d\n', leastError, bestGamma,bestWindow, bestP);

% SE 0.16, Gamma 50.00, P 7 w = 9 1g
