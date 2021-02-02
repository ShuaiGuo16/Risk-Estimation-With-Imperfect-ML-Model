clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Generate Fig. 8 in Ref [1]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: None
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Reliable calculation of 
% thermoacoustic instability risk using an imperfect surrogate model",
% 2020, ASME Turo Expo, London, England, GT2020-14434
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('./ModelTraining')
LineColor = {'b','g','m','c','k','y','r'};
uqlab

% Monte Carlo samples to calculate Pf
load './data/MC.mat'
% Here, sample enrichment is already stored in the training.mat file 
% when employing 'GP_training.mat' to train GP model adaptively
load './data/training.mat'

% Create GP model (adaptive method)
sample_number = 193;     % Converged already
[Metaopts_CAV] = CreateMetaOpts_Halton(training_X(1:sample_number,:),training_Y(1:sample_number));
GP_CAV = uq_createModel(Metaopts_CAV);

% Create GP model (space-filling method)
[GP_CAV_Halton,~] = GP_training(193,'Space-filling');

% Calculate the risk factor
figure(1)
hold on

[~,~,RF_hist_CAV,~] = RobustGP_v3(GP_CAV,X);
pts = min(RF_hist_CAV):0.0002:max(RF_hist_CAV);
[f_Pre,xi_Pre] = ksdensity(RF_hist_CAV,pts);
plot(xi_Pre*100,f_Pre,'-','LineWidth',2,'Color',LineColor{5})
miu = mean(RF_hist_CAV)  
sigma = std(RF_hist_CAV)

[~,~,RF_hist_CAV,~] = RobustGP_v3(GP_CAV_Halton,X);
pts = min(RF_hist_CAV):0.0002:max(RF_hist_CAV);
[f_Pre,xi_Pre] = ksdensity(RF_hist_CAV,pts);
plot(xi_Pre*100,f_Pre,'-','LineWidth',2,'Color',LineColor{1})
miu = mean(RF_hist_CAV)  
sigma = std(RF_hist_CAV)

RF_ref = sum(Y(:,4)>0)/size(Y,1);
plot([RF_ref*100 RF_ref*100], [0 400],'r--','LineWidth',1.2)
hold off

xlabel('$P_f (\%)$','Interpreter','latex')
ylabel('PDF')
axis([5 11 0 400])
h = gca;
h.FontSize = 14;
yticks([0 100 200 300 400])