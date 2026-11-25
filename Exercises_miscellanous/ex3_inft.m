clear all
close all
clc

x = [5, 25]; %Degrees of the food
m = [10, 15, 22.1]; %mean values

H = @(p) -sum(p.*log2(p));

p_vals = zeros(size(m));    % P(X=5)
H_vals = zeros(size(m));    % Entropy

for i = 1:length(m)
    p = (25 - m(i)) / (25 - 5);   % P(X=5)
    q = 1 - p;                    % P(X=25)
    
    H_vals(i) = H([p, q]);
    p_vals(i) = p;
    
    fprintf('Mean = %.2f -> P(X=5)=%.3f, P(X=25)=%.3f, H = %.4f', m(i), p, q, H_vals(i))
end

%%
clear all
close all
clc

x = [2 3 4 5]; %length of each song in minutes
avg = mean(x); %arithmetic average
%m = 4.2; %mean value set to be greater than the arithmetic average
m = avg;  %mean value set equal to the average
%m = 2.4; %other two mean values
%m = 4.7;

syms p1 p2 p3 p4 l1 l2 real %variable definition
P = [p1 p2 p3 p4];

H  = -(sum(P .* log(P))) / log(sym(2)); %entropy definition
c1 = sum(P) - 1; %first constraint
c2 = P * x.' - m; %second constraint

%Maximum entropy principle implementation
Delta = H + l1*c1 + l2*c2;

eqs = [
    diff(Delta,p1) == 0
    diff(Delta,p2) == 0
    diff(Delta,p3) == 0
    diff(Delta,p4) == 0
    diff(Delta,l1) == 0
    diff(Delta,l2) == 0
];

S = vpasolve(eqs, [p1 p2 p3 p4 l1 l2]);

Psol = double([S.p1, S.p2, S.p3, S.p4]);

% Plot
xvals = [2 3 4 5];

figure;
bar(xvals, Psol);
xlabel('x (song length in minutes)');
ylabel('P(x)');
title('Probability distribution (m = avg)');
grid on;
ylim([0 1]);    