function C_gain = contrast_gain(I1,I2,r)
% function£ºcaculate the contrast gain value of images I1 and I2
% Input£º
%      I1 foggy image
%      I2 clear image (enhanced image)
%      r  local window size
% Output
%     C_gain£º value of the contrast gain of images I1 and I2
if size(I1,3)==3
    I1= rgb2gray(I1);
end
if size(I2,3)==3
    I2= rgb2gray(I2);
end
C1 = local_contrast(I1,r);
C2 = local_contrast(I2,r);
C_gain = C2-C1;                 
end