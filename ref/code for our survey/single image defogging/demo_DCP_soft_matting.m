%  CORRESPONDENCE INFORMATION
%  Comments and bug reports are welcome.  Email to ckghostwj@126.com

%  WORK SETTING:
%  This code has been compiled and tested by using MATLAB R2012a

%  This demo is the dark channel prior based defogging algorithm
%  which use the soft matting method to optimize the transmission. More
%  details is presented in the following reference:
%  K. He, J. Sun, and X. Tang, 
%  "Single image haze removal using dark channel prior," 
%  IEEE Trans. Pattern Anal. Mach. Intell., vol. 33, no. 12,pp. 2341-2353, Dec. 2011.
clear all
clc
addpath([cd '/Images/']);
img_name = 'fog1.jpg';
I = double(imread(img_name))/255;
[h,w,c] = size(I);                  
win_size = 15;
img_size = w*h;
dehaze   = zeros(img_size*c,1);
dehaze   = reshape(dehaze,h,w,c);

win_dark = ones(img_size ,1);
win_dark = reshape(win_dark,h,w);

 for j = 1+win_size:w-win_size
    for i = win_size+1:h-win_size
        m_pos_min = min(I(i,j,:)); 
        for n = j-win_size:j+win_size
            for m = i-win_size:i+win_size
                if(win_dark(m,n) > m_pos_min)
                    win_dark(m,n) = m_pos_min;
                end
            end
        end      
    end
 end
 
win_dark = 1-win_dark;
win_b = zeros(img_size,1);
 
for ci = 1:h
    for cj = 1:w
        if (rem(ci-8,15) < 1)                          
            if (rem(cj-8,15) < 1)                      
                win_b(ci*w+cj) = win_dark(ci*w+cj);   
            end
        end      
    end
end
 
neb_size = 9;
win_size = 1;
epsilon = 0.0000001;

indsM = reshape([1:img_size],h,w);

tlen = img_size*neb_size^2;    
row_inds = zeros(tlen ,1);
col_inds = zeros(tlen,1);
vals = zeros(tlen,1);
len=0;
for j = 1+win_size:w-win_size
    for i = win_size+1:h-win_size
        if(rem(ci-8,15) < 1)
            if(rem(cj-8,15) < 1)
                continue;
            end
        end
      win_inds = indsM(i-win_size:i+win_size,j-win_size:j+win_size);
      win_inds = win_inds(:);
      winI = I(i-win_size:i+win_size,j-win_size:j+win_size,:);
      winI = reshape(winI,neb_size,c);                                            
      win_mu  = mean(winI,1)';                                                     
      win_var = inv(winI'*winI/neb_size-win_mu*win_mu' +epsilon/neb_size*eye(c)); 
      winI    = winI-repmat(win_mu',neb_size,1);
      tvals   = (1+winI*win_var*winI')/neb_size;                                   
      row_inds(1+len:neb_size^2+len) = reshape(repmat(win_inds,1,neb_size),...
                                             neb_size^2,1);
      col_inds(1+len:neb_size^2+len) = reshape(repmat(win_inds',neb_size,1),...
                                             neb_size^2,1);
      vals(1+len:neb_size^2+len) = tvals(:);
      len = len+neb_size^2;
    end
end 

vals     = vals(1:len);
row_inds = row_inds(1:len);
col_inds = col_inds(1:len);

A = sparse(row_inds,col_inds,vals,img_size,img_size);

sumA = sum(A,2);
A = spdiags(sumA(:),0,img_size,img_size)-A;

D = spdiags(win_b(:),0,img_size,img_size);
lambda = 1;
x = (A+lambda*D)\(lambda*win_b(:).*win_b(:));
alpha = max(min(reshape(x,h,w),1),0);

A=160/255;      % air light
      
for i=1:c
    dehaze(:,:,i)=(I(:,:,i)-A)./alpha+A;
end
t=toc
figure;subplot(121);imshow(I);title('original image');
subplot(122);imshow(dehaze);title('result');

