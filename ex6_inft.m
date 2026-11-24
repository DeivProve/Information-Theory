clear all
close all
clc

x1 = ([20,25,35,40,45,50,20,30,60]');
x2 = [0,0,0,1,1,1,2,2,2]';
x3 = ([10,60,30,40,55,70,20,80,60]');
c  = [0,0,0,1,1,1,1,0,1]';

X = double([x1 x2 x3]);
y = double(c(:));


features = 1:3;
tree = buildTree(X, y, features, 0);

% Predict training data
y_pred = zeros(size(y));
for i = 1:length(y)
    y_pred(i) = predictTree(tree, X(i,:));
end
fprintf('\nDecision Tree Structure:\n');
plotTree(tree,0,'');


% Confusion Matrix
confMat = confusionmat(y, y_pred);
disp('Confusion Matrix:');
disp(confMat);


%Input Prediction
fprintf('User Input \n');
x1_in = input('Enter value for x1: ');
x2_in = input('Enter value for x2: ');
x3_in = input('Enter value for x3: ');

v = [x1_in, x2_in, x3_in];
pred_class = predictTree(tree, v);

fprintf('Predicted class for input [%.2f %.2f %.2f] is: %d\n', v, pred_class);

% Test with other samples
newSamples = [25 0 20;
               55 2 70;
               30 1 40;
               50 2 80];

fprintf('\nPredictions for new samples:\n');
for i = 1:size(newSamples,1)
    pred = predictTree(tree, newSamples(i,:));
    fprintf('Input: [%.1f %.1f %.1f] -> Predicted class: %d\n', newSamples(i,:), pred);
end

function H = entropy(y)
    classes = unique(y);
    H = 0;
    for i = 1:length(classes)
        p = sum(y == classes(i)) / length(y);
        H = H - p * log2(p);
    end
end

function [bestThresh, bestIGR, allResults] = bestThreshold(feature, labels)
    feature = feature(:);
    labels = labels(:);

    uniqueVals = unique(feature);
    if numel(uniqueVals) < 2
        bestThresh = uniqueVals(1);
        bestIGR = 0;
        allResults = [];
        return;
    end

    thresholds = (uniqueVals(1:end-1) + uniqueVals(2:end)) / 2;

    baseEntropy = entropy(labels);
    bestIGR = -inf;
    bestThresh = NaN;

    % We record all tested thresholds and their Information Gain Ratios
    allResults = [];

    for t = thresholds'
        leftIdx = feature <= t;
        rightIdx = feature > t;

        if sum(leftIdx)==0 || sum(rightIdx)==0
            continue;
        end

        H_left = entropy(labels(leftIdx));
        H_right = entropy(labels(rightIdx));

        pL = sum(leftIdx)/length(feature);
        pR = sum(rightIdx)/length(feature);

        infoGain = baseEntropy - (pL*H_left + pR*H_right);

        splitInfo = 0;
        if pL > 0, splitInfo = splitInfo - pL*log2(pL); end
        if pR > 0, splitInfo = splitInfo - pR*log2(pR); end

        if splitInfo == 0
            IGR = 0;
        else
            IGR = infoGain / splitInfo;
        end

        % We save this candidate result
        allResults = [allResults; t, IGR];

        if IGR > bestIGR
            bestIGR = IGR;
            bestThresh = t;
        end
    end
end

%Functions definition
function tree = buildTree(X, y, features, depth)
    if length(unique(y)) == 1
        tree.isLeaf = true;
        tree.class = unique(y);
        return;
    end

    if isempty(features)
        tree.isLeaf = true;
        tree.class = mode(y);
        return;
    end

    numFeatures = length(features);
    IGRs = zeros(numFeatures,1);
    thresholds = zeros(numFeatures,1);
    allCandidates = cell(numFeatures,1);

    for i = 1:numFeatures
        [th, igr, results] = bestThreshold(X(:,features(i)), y);
        IGRs(i) = igr;
        thresholds(i) = th;
        allCandidates{i} = results;
    end

    [bestIGR, idx] = max(IGRs);
    bestFeature = features(idx);
    bestThresholdValue = thresholds(idx);

    fprintf('\n==============================================\n');
    fprintf('NODE at depth %d\n', depth);
    fprintf('Chosen feature: x%d\n', bestFeature);
    fprintf('Chosen threshold: %.4f\n', bestThresholdValue);
    fprintf('Information Gain Ratio of all tested features:\n');

    for i = 1:numFeatures
        fprintf('  Feature x%d:\n', features(i));
        fprintf('     Threshold\tIGR\n');
        res = allCandidates{i};
        for r = 1:size(res,1)
            fprintf('     %.4f\t%.4f\n', res(r,1), res(r,2));
        end
        fprintf('  --> Best for x%d: Threshold = %.4f | IGR = %.4f\n', ...
            features(i), thresholds(i), IGRs(i));
    end
    fprintf('=> Selected: x%d (Threshold = %.4f, IGR = %.4f)\n', ...
        bestFeature, bestThresholdValue, bestIGR);
    fprintf('==============================================\n');
  

    leftIdx = X(:,bestFeature) <= bestThresholdValue;
    rightIdx = X(:,bestFeature) > bestThresholdValue;

    if sum(leftIdx)==0 || sum(rightIdx)==0
        tree.isLeaf = true;
        tree.class = mode(y);
        return;
    end

    tree.isLeaf = false;
    tree.feature = bestFeature;
    tree.threshold = bestThresholdValue;
    tree.left = buildTree(X(leftIdx,:), y(leftIdx), features, depth+1);
    tree.right = buildTree(X(rightIdx,:), y(rightIdx), features, depth+1);
end


function y_pred = predictTree(tree, sample)
    if tree.isLeaf
        y_pred = tree.class;
        return;
    end
    if sample(tree.feature) <= tree.threshold
        y_pred = predictTree(tree.left, sample);
    else
        y_pred = predictTree(tree.right, sample);
    end
end

function plotTree(tree, depth, branch)
    if nargin < 3, branch = 'Root'; end
    if tree.isLeaf
        fprintf('%s%s--> Class: %d\n', repmat('   ',1,depth), branch, tree.class);
    else
        fprintf('%s%s--> x%d <= %.2f\n', repmat('   ',1,depth), branch, tree.feature, tree.threshold);
        plotTree(tree.left, depth+1, 'Left');
        plotTree(tree.right, depth+1, 'Right');
    end
end
