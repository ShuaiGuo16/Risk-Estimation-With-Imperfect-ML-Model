clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Calculate the Pf calculation error for both sampling methods
%        (Helmholtz case)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Jan. 2020
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: None
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Reliable calculation of 
% thermoacoustic instability risk using an imperfect surrogate model",
% 2020, ASME Turo Expo, London, England, GT2020-14434
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialization
uqlab
addpath('./SolverFunctions/')
load './data/MC.mat'

% the enriched training samples have already saved from 
% the last run of adaptive training routine
load './data/adaptive_training.mat'  
RF_ref = sum(Y(:,2)>0)/size(Y,1);

% Passive sampling approach (Halton)
maxIteration = 30:5:50; maxIteration = [maxIteration,53];
Pf_Halton = zeros(length(maxIteration),1);
std_Halton = zeros(length(maxIteration),1);
for i = 1:size(Pf_Halton,1)
    % Train GP model
    [GP_CAV,minU] = GP_training_Helmholtz(maxIteration(i),'Space-filling');
    % Calculate Pf value
    [~,~,RF_hist_CAV,~] = RobustGP_v3(GP_CAV,X);
    Pf_Halton(i) = mean(RF_hist_CAV);
    std_Halton(i) = std(RF_hist_CAV);
    i
end
save './data/Pf_Halton.mat' Pf_Halton
save './data/std_Halton.mat' std_Halton

% Adaptive sampling approach
GP_Iterations = 30:5:50; GP_Iterations = [GP_Iterations,53];
Pf_adaptive = zeros(length(GP_Iterations),1);
std_adaptive = zeros(length(GP_Iterations),1);
for i = 1:size(Pf_adaptive,1)
    % Train GP model
    [Metaopts_CAV] = CreateMetaOpts_Halton(training_X(1:GP_Iterations(i),:),training_Y(1:GP_Iterations(i)));
    GP_CAV = uq_createModel(Metaopts_CAV);
    % Calculate Pf value
    [~,~,RF_hist_CAV,~] = RobustGP_v3(GP_CAV,X);
    Pf_adaptive(i) = mean(RF_hist_CAV);
    std_adaptive(i) = std(RF_hist_CAV);
    i
end
save './data/Pf_adaptive.mat' Pf_adaptive
save './data/std_adaptive.mat' std_adaptive
