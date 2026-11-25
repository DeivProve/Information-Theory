clear all
close all
clc

v1 = [1.50, 4.20, 6.00];  %values of the first bet, where the first entry is victory of the first football team
% second one is draw and the third one is the victory of the second team
vp1 = 100./v1; %percentage of the first betting values 
p1 = vp1/sum(vp1); %probability of the first values

v2 = [1.85, 3.55, 4.10]; %values of the second bet
vp2 = 100./v2; %percentage of the second betting values
p2 = vp2/sum(vp2); %probability of the second values

H = @(p) -sum(p.*log2(p)); %entropy function
H1 = H(p1) %entropy of the first bet
H2 = H(p2) %entropy of the second bet
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
v3 = [4.00, 1.22]; %betting values of a tennis match where the first value is the fictory of the first athlete, the second value of the second
vp3 = 100./v3;
p3 = vp3/sum(vp3);
H3 = H(p3)
