%  CORRESPONDENCE INFORMATION

%  This code is used to calculate the blind assessment indicates and image
%  visibility.

%  Comments and bug reports are welcome.  Email to ckghostwj@126.com


%  Parts of code refer to the paper:
%  "Blind Contrast Restoration Assessment by Gradient Ratioing at Visible Edges",
%  by N. Hautiere, J.-P. Tarel, D. Aubert and E. Dumont,
%  in proceedings of International Congress for Stereology (ICS'07), 
%  Saint Etienne, France, August 30-September 7, 2007.
%  http://perso.lcpc.fr/tarel.jean-philippe/publis/ics07.html


function [Blind_e,Blind_r,Blind_deta,IVM_r] = blind_assessment(I1,R1)

if size(I1,3) == 3
    I1 = double(rgb2gray(I1));
else
    I1 = double(I1);
end
if size(R1,3) == 3
    R1 = double(rgb2gray(R1));
else
    R1 = double(R1);
end

[nl,nc] = size(I1);

%%----------------------- Sobel Gradient ---------------------------%%
Sy   = double([1 2 1;0 0 0;-1 -2 -1]);
GIy  = imfilter(I1,Sy,'symmetric');
GRy1 = imfilter(R1,Sy,'symmetric');

Sx   = double([1 0 -1; 2 0 -2; 1 0 -1]);
GIx  = imfilter(I1,Sx,'symmetric');
GRx1 = imfilter(R1,Sx,'symmetric');

GI  = sqrt((GIx.^2)+(GIy.^2));
GR1 = sqrt((GRx1.^2)+(GRy1.^2));

minGI = min(GI(:));
maxGI = max(GI(:));

%%------------------ Contrast Computation at 5% --------------------%%
[Ci Crri Ci_i Crri_i] = functionContrastAt5PerCent(I1);   
[C1 Crr1 C1_1 Crr1_1] = functionContrastAt5PerCent(R1);

%%-------------------- Visible Gradients Ratio ---------------------%%
Cratio1 = zeros(nl,nc);
Cratio1(Crr1>0) = GR1(Crr1>0)./GI(Crr1>0);

%%--------------------- Descriptor computation ---------------------%%
% Rate of new visible edges e
whitePixels1 = sum(C1(:));
whitePixelsi = sum(Ci(:));
Blind_e = 100*(whitePixels1-whitePixelsi)/size(I1,1)/size(I1,2);

% Number of saturated pixels after restoration
Blind_deta = sum(R1(:)==255 |R1(:)==0);
Blind_deta = Blind_deta/(nl*nc);

% Restoration quality (geometric mean ratios of visibility level)
XX = log(Cratio1);
Blind_r = exp((1/(whitePixels1))*nansum(XX(isfinite(XX))));

% Caculate the image visibility measurement (IVM)
nr_all = sum(C1_1(:));
IVM_r  = whitePixels1/nr_all*log(sum(sum(C1_1.*Crr1_1)));   % IVM of the clear image

