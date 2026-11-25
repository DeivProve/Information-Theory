close all
clear all
clc

%%
% Case 1 I(X;Y) = H(X)
%Probability of a PC of being Windows being anything than an Apple and being iOS being a Mac
Pxy1 = [0.8 0;   
       0 0.2]

Px1 = sum(Pxy1,2);
Py1 = sum(Pxy1,1);

Hx1 = -nansum(Px1.*log2(Px1));
Hy1 = -nansum(Py1.*log2(Py1));

Hxy1 = -nansum(Pxy1(:).*log2(Pxy1(:)));

Ixy1 = Hx1 + Hy1 - Hxy1;

Hx_given_Y1 = Hxy1 - Hy1

%%
%Case 2 I(X;Y) < H(X)
%Probability of a the events 'it rains' and 'I have an umbrella'

Pxy2 = [0.45 0.15;   
       0.05 0.35]

Px2 = sum(Pxy2,2);
Py2 = sum(Pxy2,1);

Hx2 = -nansum(Px2.*log2(Px2));
Hy2 = -nansum(Py2.*log2(Py2));

Hxy2 = -nansum(Pxy2(:).*log2(Pxy2(:)));

Ixy2 = Hx2 + Hy2 - Hxy2;

Hx_given_Y2 = Hxy2 - Hy2

%% 
%Case 3 
%Probability of a ticket of being 1st or 2nd class and the probability if
%the day of the purchase is in the week or in the weekend
Px3 = [0.3 0.7];
Py3 = [5/7 2/7];

Pxy3 = Px3'*Py3
Hx3 = -nansum(Px3.*log2(Px3));
Hy3 = -nansum(Py3.*log2(Py3));

Hxy3 = -nansum(Pxy3(:).*log2(Pxy3(:)));

Ixy3 = Hx3 + Hy3 - Hxy3;

Hx_given_Y3 = Hxy3 - Hy3