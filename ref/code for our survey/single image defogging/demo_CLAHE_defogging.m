%  CORRESPONDENCE INFORMATION
%  WORK SETTING:
%  This code has been compiled and tested by using MATLAB R2012a

%  This demo is used to enhance the foggy image by CLAHE algorithm, 
clc
clear all
addpath([cd '/Images/']);  
I = imread('fog1.jpg');         
alpha = 0.02;
tic
J(:,:,1) = adapthisteq(I(:,:,1),'ClipLimit',alpha);
J(:,:,2) = adapthisteq(I(:,:,2),'ClipLimit',alpha);
J(:,:,3) = adapthisteq(I(:,:,3),'ClipLimit',alpha);
t = toc
figure;subplot(121);imshow(I);title('Foggy image');
subplot(122);imshow(J);title('CLAHE');
