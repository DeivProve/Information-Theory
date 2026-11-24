clear all
close all
clc

txt = erasePunctuation(lower(fileread("C:\Users\davep\OneDrive\Desktop\divine_comedy.txt")));
arr = char(txt);

accents = ['à','è','é','ì','ò','ù'];
nonaccents = ['a','e','e','i','o','u'];
for i = 1:length(accents)
    txt = strrep(txt,accents(i), nonaccents(i));
end

arr = char(txt);

freqchar = unique(arr);
freqcount=zeros(size(freqchar));

for i = 1:length(freqchar)
    freqcount(i)=sum(arr == freqchar(i));
end

sumchar = sum(freqcount);
probchar = freqcount./sumchar;
H = @(p) -sum(p.*log2(p));
H1 = H(probchar)


pairs = {};  % empty array
for i = 1:length(arr)-1
    pairs{end+1} = [arr(i) arr(i+1)];  % chains together two consecutive characters
end

%COunts the unique pairs
uniqPairs = unique(pairs);  
countPairs = zeros(size(uniqPairs));

for j = 1:length(uniqPairs)
    countPairs(j) = sum(strcmp(pairs, uniqPairs{j})); %This MATLAB function compares two strings s1 and s2 and returns 1 if the two are identical and 0 otherwise
end

totalPairs = sum(countPairs);
probPairs = countPairs / totalPairs;

H = @(p) -sum(p .* log2(p));
H_pairs = H(probPairs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

