clear all
close all
clc

mushroom = {'A';'B';'C';'D';'E';'F';'G';'H';'I';'J'};
capshape = categorical({'x';'x';'f';'x';'x';'x';'b';'s';'x';'s'});
capsurface = categorical({'s';'s';'f';'y';'s';'y';'s';'f';'y';'f'});
color = categorical({'n';'y';'g';'w';'g';'y';'w';'g';'w';'n'});
poisonous = [true; false; false; true; false; false; false; false; true; true];

T = table(mushroom,capshape,capsurface,color,poisonous);

features = {capshape, capsurface, color};
feature_names = {'capshape','capsurface','color'};

%Entropy of the target variable "poisonous" 
p1 = sum(poisonous)/length(poisonous);  % probability of poisonous = true
p0 = 1 - p1;                            % probability of poisonous = false

if p1 == 0 || p1 == 1
    Hx = 0;  % entropy is zero 
else
    Hx = -p1*log2(p1) - p0*log2(p0);  
end
fprintf('Entropy of poisonous: %.4f bit\n\n', Hx);

%We compute conditional entropy and Gain Ratio
for f = 1:3
    col = features{f};      % feature column
    c = categories(col);    % list of unique categories in this feature
    Hxf = 0; % conditional entropy H(X|F)
    Hf = 0;  % entropy of the feature 
    
    % Loop through each category of the feature
    for i = 1:length(c)
        bool = (col == c{i});            
        Pf = sum(bool)/length(col);      
        Px1 = sum(poisonous(bool))/sum(bool); 
        Px0 = 1 - Px1;                    
        
        if Px1 == 0 || Px1 == 1
            Hx_f = 0; 
        else
            Hx_f = -Px1*log2(Px1) - Px0*log2(Px0);
        end
        Hxf = Hxf + Pf * Hx_f; 
        
        % Entropy of the feature H(F)
        if Pf == 0 || Pf == 1
            Hf_f = 0; 
        else
            Hf_f = -Pf*log2(Pf);
        end
        Hf = Hf + Hf_f;
    end
    
    % Gain Ratio = Information Gain / Feature Entropy
    GainRatio = (Hx - Hxf)/Hf;
    
    
    fprintf('Feature: %s | H(X|F)=%.4f | H(F)=%.4f | Gain Ratio=%.4f\n', feature_names{f}, Hxf, Hf, GainRatio);
end