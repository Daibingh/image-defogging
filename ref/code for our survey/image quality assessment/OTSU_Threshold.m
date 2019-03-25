function k = OTSU_Threshold(I)
L = 256;
[h,w,c] = size(I); 
if c==3
    I = rgb2gray(I);        
end
a = zeros(1,255);
for n = 0:L-1
    A = find(I==n);
    a(n+1) = length(A); 
end
p = a/(h*w);     

p1(1) = p(1);
m(1) = 0;
for k = 1:L-1        
    p1(k+1) = p1(k)+p(k+1);
    m(k+1)  = m(k)+k*p(k+1); 
end
mG = m(L);   

detaB_2 = ((mG.*p1 - m).^2)./(p1+0.0000001)./(1-p1+0.000001);  

detaB_2_k = max(detaB_2); 
b = 0;
for i = 1:L
    if detaB_2(i) == detaB_2_k     
        b = b+1;      
        kg(b) = i-1;  
    end
end
k = sum(kg)/b;
end
