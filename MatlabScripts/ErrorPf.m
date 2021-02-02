clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Calculate the Pf calculation error for both sampling methods
%   ===> Plot Pf calculation error against sample number
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
addpath('./ModelTraining')
uqlab
load './data/MC.mat'
load './data/training.mat'  
RF_ref = sum(Y(:,4)>0)/size(Y,1);

% Passive sampling approach (Halton)
HaltonIteration = 60:20:400;
Pf_Halton = zeros(length(HaltonIteration),1);
std_Halton = zeros(length(HaltonIteration),1);
for i = 1:size(Pf_Halton,1)
    % Train GP model
    [GP_CAV,minU] = GP_training(HaltonIteration(i),'Space-filling');
    % Calculate Pf value
    [~,~,RF_hist_CAV,~] = RobustGP_v3(GP_CAV,X);
    Pf_Halton(i) = mean(RF_hist_CAV);
    std_Halton(i) = std(RF_hist_CAV);
end


% Adaptive sampling approach
% Training data is already stored in training_X & training_Y
AIterations = 60:20:180; AIterations = [AIterations,193];
Pf_adaptive = zeros(length(AIterations),1);
std_adaptive = zeros(length(AIterations),1);
for i = 1:size(Pf_adaptive,1)
    % Train GP model
    [Metaopts_CAV] = CreateMetaOpts_Halton(training_X(1:AIterations(i),:),training_Y(1:AIterations(i)));
    GP_CAV = uq_createModel(Metaopts_CAV);
    % Calculate Pf value
    [~,~,RF_hist_CAV,~] = RobustGP_v3(GP_CAV,X);
    Pf_adaptive(i) = mean(RF_hist_CAV);
    std_adaptive(i) = std(RF_hist_CAV);
end


%% Post-processing routine
figure(1)
hold on
% Plot the passive sampling results
patch_X = [HaltonIteration,HaltonIteration(end:-1:1)];
patch_Y = [Pf_Halton+3*std_Halton;Pf_Halton(end:-1:1)-3*std_Halton(end:-1:1)]*100;
patch(patch_X',patch_Y,[0.7 0.7 0.7],'LineStyle','none')
plot(HaltonIteration,Pf_Halton*100,'--k','LineWidth',1.2)
% Plot the adaptive sampling results
errorbar(AIterations,Pf_adaptive*100,3*std_adaptive*100,'bo','LineWidth',1.2,'MarkerFaceColor','b')
% Plot the reference results
Iteration = 0:20:400;
plot(Iteration,RF_ref*ones(length(Iteration),1)*100,':r','LineWidth',1.2)
hold off

axis([0 400 2 12])
xlabel('Training sample number')
ylabel('$P_f (\%)$','Interpreter','latex')
h = gca;
h.FontSize = 14;