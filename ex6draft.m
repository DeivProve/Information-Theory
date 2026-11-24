function ex6draft()
    % === Training Data ===
    label = [1,2,3,4,5,6,7,8,9];
    X = [20 0 10;
         25 0 60;
         35 0 30;
         40 1 40;
         45 1 55;
         50 1 70;
         20 2 20;
         30 2 80;
         60 2 60];
    y = [0;0;0;1;1;1;1;0;1];
    
    % === Build Decision Tree ===
    tree = buildTree(X, y, {'x1','x2','x3'});
    
    % === Show final tree ===
    disp(' ');
    disp('=== Final Decision Tree ===');
    disp(tree);
    
    % === Verify training classification ===
    y_pred = zeros(size(y));
    for i = 1:length(y)
        y_pred(i) = predictTree(tree, X(i,:));
    end
    confusion = confusionmat(y, y_pred);
    disp(' ');
    disp('Confusion Matrix (training data):');
    disp(confusion);
    
    % === Example predictions for unseen samples ===
    disp(' ');
    testX = [22 0 50;
             42 1 60;
             55 1 80;
             25 2 40];
    disp('Example predictions:');
    for i = 1:size(testX,1)
        pred = predictTree(tree, testX(i,:));
        fprintf('Input [%g, %g, %g] -> Predicted class: %d\n', ...
                testX(i,1), testX(i,2), testX(i,3), pred);
    end
    
    % === User input ===
    disp(' ');
    v = input('Enter a vector [x1 x2 x3]: ');
    pred = predictTree(tree, v);
    fprintf('Predicted class for [%g, %g, %g] is %d\n', v(1), v(2), v(3), pred);
    
    % === Plot tree ===
    figure;
    plotTree(tree, 0.5, 1, 1);
    axis off;
end

% ================================
% Recursive Tree Builder
% ================================
function node = buildTree(X, y, featureNames)
    classes = unique(y);
    if numel(classes) == 1
        node.type = 'leaf';
        node.class = classes(1);
        return;
    end
    
    nFeatures = size(X,2);
    bestIGR = -inf;
    bestFeature = 0;
    bestThreshold = 0;
    
    % Try all features and thresholds (exact from matrix)
    for f = 1:nFeatures
        vals = unique(sort(X(:,f)));
        thresholds = (vals(1:end-1) + vals(2:end)) / 2; % exact midpoint
        for t = thresholds'
            igr = infoGainRatio(X, y, f, t);
            if igr > bestIGR
                bestIGR = igr;
                bestFeature = f;
                bestThreshold = t;
            end
        end
    end
    
    % Print node info
    fprintf('\n--- Node Split ---\n');
    for f = 1:nFeatures
        vals = unique(sort(X(:,f)));
        thresholds = (vals(1:end-1) + vals(2:end)) / 2;
        fprintf('Feature %s:\n', featureNames{f});
        for t = thresholds'
            igr = infoGainRatio(X, y, f, t);
            fprintf('  Threshold %.3f -> IGR = %.4f\n', t, igr);
        end
    end
    fprintf('Chosen feature: %s, threshold: %.3f\n', ...
            featureNames{bestFeature}, bestThreshold);
    
    % Split data
    leftIdx  = X(:,bestFeature) <= bestThreshold;
    rightIdx = X(:,bestFeature) >  bestThreshold;
    
    % Recursive construction
    node.type = 'node';
    node.feature = featureNames{bestFeature};
    node.threshold = bestThreshold;
    node.left = buildTree(X(leftIdx,:), y(leftIdx), featureNames);
    node.right = buildTree(X(rightIdx,:), y(rightIdx), featureNames);
end

% ================================
% Information Gain Ratio
% ================================
function igr = infoGainRatio(X, y, featureIndex, threshold)
    H = entropyCalc(y);
    leftIdx = X(:,featureIndex) <= threshold;
    rightIdx = X(:,featureIndex) > threshold;
    yL = y(leftIdx); yR = y(rightIdx);
    
    if isempty(yL) || isempty(yR)
        igr = 0;
        return;
    end
    
    H_after = (numel(yL)/numel(y))*entropyCalc(yL) + ...
              (numel(yR)/numel(y))*entropyCalc(yR);
    gain = H - H_after;
    
    % Split info
    pL = numel(yL)/numel(y);
    pR = numel(yR)/numel(y);
    splitInfo = - (pL*log2(pL) + pR*log2(pR));
    igr = gain / splitInfo;
end

function H = entropyCalc(y)
    vals = unique(y);
    H = 0;
    for i = 1:length(vals)
        p = sum(y==vals(i)) / length(y);
        H = H - p*log2(p);
    end
end

% ================================
% Prediction
% ================================
function cls = predictTree(tree, x)
    if strcmp(tree.type,'leaf')
        cls = tree.class;
    else
        f = str2double(tree.feature(2)); % assumes names x1,x2,x3
        if x(f) <= tree.threshold
            cls = predictTree(tree.left, x);
        else
            cls = predictTree(tree.right, x);
        end
    end
end

% ================================
% Simple Tree Plot
% ================================
function decision_tree_IGR()
    % === Training Data ===
    label = [1,2,3,4,5,6,7,8,9];
    X = [20 0 10;
         25 0 60;
         35 0 30;
         40 1 40;
         45 1 55;
         50 1 70;
         20 2 20;
         30 2 80;
         60 2 60];
    y = [0;0;0;1;1;1;1;0;1];
    
    % === Build Decision Tree ===
    tree = buildTree(X, y, {'x1','x2','x3'});
    
    % === Show final tree ===
    disp(' ');
    disp('=== Final Decision Tree ===');
    disp(tree);
    
    % === Verify training classification ===
    y_pred = zeros(size(y));
    for i = 1:length(y)
        y_pred(i) = predictTree(tree, X(i,:));
    end
    confusion = confusionmat(y, y_pred);
    disp(' ');
    disp('Confusion Matrix (training data):');
    disp(confusion);
    
    % === Example predictions for unseen samples ===
    disp(' ');
    testX = [22 0 50;
             42 1 60;
             55 1 80;
             25 2 40];
    disp('Example predictions:');
    for i = 1:size(testX,1)
        pred = predictTree(tree, testX(i,:));
        fprintf('Input [%d, %d, %d] -> Predicted class: %d\n', ...
                testX(i,1), testX(i,2), testX(i,3), pred);
    end
    
    % === User input ===
    disp(' ');
    v = input('Enter a vector [x1 x2 x3]: ');
    pred = predictTree(tree, v);
    fprintf('Predicted class for [%d, %d, %d] is %d\n', v(1), v(2), v(3), pred);
    
    % === Plot tree ===
    figure;
    plotTree(tree, 0.5, 1, 1);
    axis off;
end

% ================================
% Recursive Tree Builder
% ================================
function node = buildTree(X, y, featureNames)
    classes = unique(y);
    if numel(classes) == 1
        node.type = 'leaf';
        node.class = classes(1);
        return;
    end
    
    nFeatures = size(X,2);
    bestIGR = -inf;
    bestFeature = 0;
    bestThreshold = 0;
    
    % Try all integer thresholds from matrix
    for f = 1:nFeatures
        thresholds = unique(sort(X(:,f))); % use actual matrix values only
        for t = thresholds'
            igr = infoGainRatio(X, y, f, t);
            if igr > bestIGR
                bestIGR = igr;
                bestFeature = f;
                bestThreshold = t;
            end
        end
    end
    
    % Print node info
    fprintf('\n--- Node Split ---\n');
    for f = 1:nFeatures
        thresholds = unique(sort(X(:,f)));
        fprintf('Feature %s:\n', featureNames{f});
        for t = thresholds'
            igr = infoGainRatio(X, y, f, t);
            fprintf('  Threshold %d -> IGR = %.4f\n', t, igr);
        end
    end
    fprintf('Chosen feature: %s, threshold: %d\n', ...
            featureNames{bestFeature}, bestThreshold);
    
    % Split data
    leftIdx  = X(:,bestFeature) <= bestThreshold;
    rightIdx = X(:,bestFeature) >  bestThreshold;
    
    % Recursive construction
    node.type = 'node';
    node.feature = featureNames{bestFeature};
    node.threshold = bestThreshold;
    node.left = buildTree(X(leftIdx,:), y(leftIdx), featureNames);
    node.right = buildTree(X(rightIdx,:), y(rightIdx), featureNames);
end

% ================================
% Information Gain Ratio
% ================================
function igr = infoGainRatio(X, y, featureIndex, threshold)
    H = entropyCalc(y);
    leftIdx = X(:,featureIndex) <= threshold;
    rightIdx = X(:,featureIndex) > threshold;
    yL = y(leftIdx); yR = y(rightIdx);
    
    if isempty(yL) || isempty(yR)
        igr = 0;
        return;
    end
    
    H_after = (numel(yL)/numel(y))*entropyCalc(yL) + ...
              (numel(yR)/numel(y))*entropyCalc(yR);
    gain = H - H_after;
    
    % Split info
    pL = numel(yL)/numel(y);
    pR = numel(yR)/numel(y);
    splitInfo = - (pL*log2(pL) + pR*log2(pR));
    igr = gain / splitInfo;
end

function H = entropyCalc(y)
    vals = unique(y);
    H = 0;
    for i = 1:length(vals)
        p = sum(y==vals(i)) / length(y);
        H = H - p*log2(p);
    end
end

% ================================
% Prediction
% ================================
function cls = predictTree(tree, x)
    if strcmp(tree.type,'leaf')
        cls = tree.class;
    else
        f = str2double(tree.feature(2)); % assumes x1,x2,x3 naming
        if x(f) <= tree.threshold
            cls = predictTree(tree.left, x);
        else
            cls = predictTree(tree.right, x);
        end
    end
end

% ================================
% Simple Tree Plot
% ================================
function plotTree(node, x, y, level)
    if strcmp(node.type,'leaf')
        text(x, y, sprintf('Class=%d', node.class), ...
             'HorizontalAlignment','center', 'BackgroundColor',[.9 .9 1]);
    else
        text(x, y, sprintf('%s <= %d ?', node.feature, node.threshold), ...
             'HorizontalAlignment','center', 'BackgroundColor',[.8 1 .8]);
        dx = 0.4 / level;
        line([x x-dx],[y-0.1 y-0.3],'Color','k');
        plotTree(node.left, x-dx, y-0.4, level+1);
        line([x x+dx],[y-0.1 y-0.3],'Color','k');
        plotTree(node.right, x+dx, y-0.4, level+1);
    end
end




