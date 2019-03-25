%  CORRESPONDENCE INFORMATION

%  Comments and bug reports are welcome.  Email to ckghostwj@126.com

%  WORK SETTING:
%  This code has been compiled and tested by using MATLAB R2012a

%  For more detials, please see our paper:
%  Y. Xu, J. Wen, L. Fei, Z. Zhang,
%  Review of video and image defogging algorithms and related studies on image restoration and enhancement,
%  DOI: 10.1109/ACCESS.2015.2511558. In IEEE ACCESS, 2016.
%---------------------------------------------------------------------------------------------------------

%  Parts of code refer to the paper:
%  N. Hauti¨¦re, J.-P. Tarel, D. Aubert, and E. Dumont, 
%  "Blind contrast enhancement assessment by gradient ratioing at visible edges," 
%  Image Anal. & Stereology J., vol. 27, no. 2, pp. 87-95, Jun. 2008.
%  Z. Wang, A. C. Bovik, H. R. Sheikh, and E. P. Simoncelli, "Image
%  quality assessment: From error visibility to structural similarity,"
%  IEEE Transactios on Image Processing, vol. 13, no. 4, pp. 600-612,


%  This main function is used to caculate the objective quality of the defogging image, 
%  and can be utilized as a objective evaluation criterion for different defogging algorithms.

clear all
clc
addpath([cd '/Image/']);                        
Fog_image   = imread('forest-orig.png');          % read original foggy image
Clear_image = imread('forest-He.png');      % read clear image (enhanced image)

% Blind assessment and image visibility measurement (IVM)
[Blind_e,Blind_r,Blind_deta,IVM_r] = blind_assessment(Fog_image,Clear_image);
QA.e = Blind_e; QA.r = Blind_r; QA.deta = Blind_deta;
QA.IVM = IVM_r;

% Histogram correlation coefficient (HCC)
[HCC_value] = color_corrlation(Fog_image,Clear_image);
QA.HCC = HCC_value;

% image structural similarity (SSIM)
if size(Fog_image,3) == 3
    Fog_image = rgb2gray(Fog_image);
end
if size(Clear_image,3) == 3
    Clear_image = rgb2gray(Clear_image);
end
[mssim, ~] = ssim(Fog_image, Clear_image);
QA.SSIM = mssim;

% Contrast gain
r = 2;
C_gain = contrast_gain(Fog_image,Clear_image,r);
QA.Cg = C_gain;

%% Visual contrast measure (VCM)
vc = visual_contrast(Clear_image);
QA.VCM = vc;

%% Universal quality index (UQI)
block_size = 5;
[UQI_quality, quality_map] = img_qi(Fog_image, Clear_image, block_size);
QA.UQI = UQI_quality;






