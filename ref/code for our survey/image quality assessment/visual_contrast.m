function vc = visual_contrast(I)
% function: caculate the visual contrast of image I 
% detail discription of the visual contrast measure algorithm refers to the paper:
% D. J. Jobson, Z.-u. Rahman, G. A. Woodell, and G. D. Hines, 
% "A comparison of visual statistics for the image enhancement of FORESITE aerial images with those of major image classes," 
% in Proc. SPIE 6246,April 2006, vol. 6246, pp. 624601-1.

[h,w,c]=size(I);
if c ~=1
    I = rgb2gray(I);
end

r = round(0.05*min(h,w));   
num_Sub_region = 0;         
for i = 1:r:(h-r+1)
    for j = 1:r:(w-r+1)
        if (i+r-1)>h
            Rh = h;
        else
            Rh = i+r-1;
        end
        if (j+r-1)>w
            Rw = w;
        else
            Rw = j+r-1;
        end
        Sub_region = I(i:Rh,j:Rw);
        num_Sub_region = num_Sub_region+1;
        deta(num_Sub_region) = (std2(Sub_region))^2;   
    end
end
deta = round(deta);                                    
k = OTSU_Threshold(deta);                               % caculate the best threshold by OTSU algorithm   

Rv = 0;
for i = 1:num_Sub_region
    if deta(i) >= k
        Rv = Rv+1;
    end
end
vc = 100 * Rv/num_Sub_region;
end



    
