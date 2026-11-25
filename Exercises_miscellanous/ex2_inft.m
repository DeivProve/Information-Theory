clear all
close all
clc

txt = erasePunctuation(lower(fileread("C:\Users\davep\OneDrive\Desktop\divine_comedy.txt"))); %https://wyomingcatholic.edu/wp-content/uploads/dante-01-inferno.pdf
accents = ['à','è','é','ì','ò','ù'];
nonaccents = ['a','e','e','i','o','u'];
for i = 1:length(accents)
    txt = strrep(txt, accents(i), nonaccents(i)); %We delete the accents
end

alphabet = ' abcdefghijklmnopqrstuvwxyz'; %we create the alphabet withe the 26 english letters adding the blank space

%We count the frequency of each character 
freqcount = zeros(size(alphabet));
for i = 1:length(alphabet)
    freqcount(i) = sum(txt == alphabet(i));
end


sumchar = sum(freqcount);
probchar = freqcount ./ sumchar;
H = @(p) -nansum(p.*log2(p)); %entropy function
H1 = H(probchar)

labels = cellstr(alphabet');
figure;
bar(freqcount);               
set(gca, 'XTick', 1:27);      
set(gca, 'XTickLabel', labels);
xlabel('Characters');
ylabel('Frequency');
title("Characters' distribution");
grid on;

%%
arr = char(txt);
pairs = {};  % empty array
for i = 1:length(arr)-1
    pairs{end+1} = [arr(i) arr(i+1)];  % chains together two consecutive characters
end

%Counts the unique pairs
uniqPairs = unique(pairs);  
countPairs = zeros(size(uniqPairs));

for j = 1:length(uniqPairs)
    countPairs(j) = sum(strcmp(pairs, uniqPairs{j})); %This MATLAB function compares two strings s1 and s2 and returns 1 if the two are identical and 0 otherwise
end

totalPairs = sum(countPairs);
probPairs = countPairs / totalPairs;

H = @(p) -sum(p .* log2(p));
H_pairs = H(probPairs)

C1 = cellfun(@(x) x(1), uniqPairs, 'UniformOutput', false);
C2 = cellfun(@(x) x(2), uniqPairs, 'UniformOutput', false);

allChars = unique([C1, C2]);

P_matrix = zeros(length(allChars), length(allChars));

map = containers.Map(allChars, 1:length(allChars));

for k = 1:length(uniqPairs)
    row_idx = map(C1{k});
    col_idx = map(C2{k});
    P_matrix(row_idx, col_idx) = probPairs(k);
end




%Plot
figure('Position', [100, 100, 1000, 700])


imagesc(P_matrix);  

colormap(sky);      
colorbar;

title('Probability of Symbol Pairs');
xlabel('Second character');
ylabel('First character');

tick_locations = 1:length(allChars);

set(gca, 'XTick', tick_locations, 'XTickLabel', allChars);

set(gca, 'YTick', tick_locations, 'YTickLabel', flip(allChars));

axis equal tight;
