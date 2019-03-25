% The code is written by Jerry.
%  Comments and bug reports are welcome.  Email to ckghostwj@126.com
% WORK SETTING:
% This code has been compiled and tested by using MATLAB R2012a
% This code is the dark channel priori based defogging algorithm which uses
% bilateral filtering, joint bilateral filtering and guided filtering for transmission potimization.

%  For more detials, please see our paper:
%  Y. Xu, J. Wen, L. Fei, Z. Zhang,
%  Review of video and image defogging algorithms and related studies on image restoration and enhancement,
%  DOI: 10.1109/ACCESS.2015.2511558. In IEEE ACCESS, 2016.

clear all
clc
addpath([cd '/Images/']);
addpath([cd '/utilizes/']);
img_name = 'sam_4.bmp';

blockSize = 15;              
w0 = 0.6;                    
t0 = 1/255;
I = imread(img_name);

grayI = rgb2gray(I);
[COUNT x] = imhist(grayI);
under_50 = 0;
for i = 0:50
    under_50 = under_50+COUNT(x == i);
end
under_50
total = size(I,1)*size(I,2)*size(I,3);
percent = under_50/total

if(percent>0.02)
     w0 = 0.8;
  else if (percent>0.01)
                    w0 = 0.3;
    else if (percent>0.003)
                    w0 = 0.45;
        else if (percent>0.0001)
                    w0 = 0.55;
             else if (percent>0)
                    w0 = 0.8;
                 else if (percent==0)
                    w0 = 0.7;    
                      end
                end
            end
        end
    end
end
[h,w,s] = size(I);
min_I = zeros(h,w);                   

for i=1:h                 
    for j=1:w
        dark_I(i,j) = min(I(i,j,:));  
    end
end
dark_I = ordfilt2(dark_I,1,ones(blockSize,blockSize) ,'symmetric');         % minimum filtering

% select airlight value manually
wsz = 15;                       % window size
h = figure, imshow(I, []); 
title('manual airlight estimation: left click to pick a most hazy pixel. ')
[x, y] = ginput(1);
A = I(round(y), round(x), :);
A = double(A) -1;
A = min(A, 255);
close(h);
A_max = sum(A(:))/3;

t = 1 - w0*double(dark_I)/A_max;
t = max(t,t0);

% BF_t = bialteral2(t,7,[16,0.5]);        % use bialteral filtering to optimize the transmission

% BF_t = guide_BF(t,I,15 ,[16,0.5]);        % use joint bialteral filtering to optimize the transmission

% use guided filtering to optimize the transmission
r = 32;
eps = 0.0001;                            
s = 4;
BF_t = fastguidedfilter_color(double(I)/255, t, r, eps,s); 

figure;imshow(BF_t);colormap hot; title('transmission image');

I1 = double(I);
J1(:,:,1) = uint8((I1(:,:,1) - (1-BF_t)*A_max)./BF_t);
J1(:,:,2) = uint8((I1(:,:,2) - (1-BF_t)*A_max)./BF_t);
J1(:,:,3) = uint8((I1(:,:,3) - (1-BF_t)*A_max)./BF_t);
figure;imshow(J1);title('defogging result');

