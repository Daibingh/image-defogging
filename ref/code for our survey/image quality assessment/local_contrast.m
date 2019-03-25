function C_contrast = local_contrast(I,r)
% function: caculate the local contrast of image I
% Input£º
%       I: image
%       r: local window size
% Output
%       C_contrast: local contast
if size(I,3) == 3
    I = rgb2gray(I);
end
[m,n] = size(I);
C = zeros(m,n);
for i = 1:m
    for j = 1:n
        hl = i-r;
        hr = i+r;
        vu = j-r;
        vd = j+r;
        if hl<1
            hl = 1;
        end
        if hr>m
            hr = m;
        end
        if vu<1
            vu = 1;
        end
        if vd >n
            vd = n;
        end
        W  = I(hl:hr,vu:vd);
        mw = mean2(W);
        sw = sum(sum((W-mw).^2))/(2*r+1).^2;
        C(i,j) = sw/(mw+0.0001);
        clear W
    end
end
C_contrast = mean2(C);    
end