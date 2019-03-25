% This is the function to caculate the histogram correlation coefficient(HCC) of image I1 and I2.

function [HCC_value] = color_corrlation(I1,I2)

Ir1 = I1(:,:,1);
Ig1 = I1(:,:,2);
Ib1 = I1(:,:,3);
Ir2 = I2(:,:,1);
Ig2 = I2(:,:,2);
Ib2 = I2(:,:,3);

[count_r1,xr1] = imhist(Ir1);
[count_g1,xg1] = imhist(Ig1);
[count_b1,xb1] = imhist(Ib1);

hist_I1 = [count_r1',count_g1',count_b1'];

[count_r2,xr2] = imhist(Ir2);
[count_g2,xg2] = imhist(Ig2);
[count_b2,xb2] = imhist(Ib2);
hist_I2 = [count_r2',count_g2',count_b2'];

g = corrcoef(hist_I1 ,hist_I2);
HCC_value = g(1,2);
end