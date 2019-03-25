function retimg = bialteral2(img ,N ,sigma)
%% pre-computer domain filtering
sigma_d = sigma(1);    
sigma_r = sigma(2);    
[X,Y]   = meshgrid(-N:N,-N:N);        % generate two matrix 
D = exp(-(X.^2+Y.^2)/(2*sigma_d^2));% domain weights with Euclidean distance 
%% rang filtering in v layer
dim = size(img);            % dim=[height,length,3]
B   = zeros(dim);             % create an image B with the same size and dimension with the zero value.
for i = 1:dim(1)
    for j = 1:dim(2)
        iMin = max(i-N,1);            
        iMax = min(i+N,dim(1));       
        jMin = max(j-N,1);            
        jMax = min(j+N,dim(2));      
        L = img(iMin:iMax,jMin:jMax); % extract the local region 
        
        d = L-img(i,j);     % the dissimilarity between the surroud and center 
        R = exp(-(d.^2)/(2*sigma_r^2));     % range filter weights  
                
        F = R.*D((iMin:iMax)-i+N+1,(jMin:jMax)-j+N+1);  % its row is from iMin-i+N+1 to iMax-i+N+1,and so as line 

        norm_F = sum(F(:));
        B(i,j) = sum(sum(F.*L))/norm_F;  
        
        retimg(i,j) = B(i,j); 
    end
end