clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Using different methods to train GP model & calculate
%        the PDF of Pf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPLEMENTATION
%   ===> Set maxIteration=102, GP_training method='Space-filling'
%            to generate Fig. 4 in Ref [1].
%   ===> Set maxIteration=[100 200 400], GP_training method='Space-filling'
%            to generate Fig. 5 in Ref [1].
%   ===> Set GP_training method='Adaptive-sampling' to adaptively train
%            GP model, remember to save training_X & training_Y when
%            calling GP_training function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: UQLab
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Reliable calculation of 
% thermoacoustic instability risk using an imperfect surrogate model",
% 2020, ASME Turo Expo, London, England, GT2020-14434
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('./ModelTraining')
LineColor = {'b','g','m','c','k','y','r'};

% Initilization
uqlab
load './data/MC.mat'     % Same MC samples as reference results
sample_number = size(X,1);
maxIteration = 193;

figure(1)
hold on

for i = 1:size(maxIteration,1)
    [GP_CAV,minU,~,~] = GP_training(maxIteration(i),'Space-filling');
    [~,~,RF_hist_CAV,~] = RobustGP_v3(GP_CAV,X);
    % Output statistics of risk factor variation
    miu = mean(RF_hist_CAV)  
    sigma = std(RF_hist_CAV) 
    pts = min(RF_hist_CAV):0.0002:max(RF_hist_CAV);
    [f_Pre,xi_Pre] = ksdensity(RF_hist_CAV,pts);
    plot(xi_Pre*100,f_Pre,'-','LineWidth',2,'Color',LineColor{i})
end

RF_ref = sum(Y(:,4)>0)/size(Y,1);
plot([RF_ref*100 RF_ref*100], [0 400],'r--','LineWidth',1.2)

hold off
xlabel('$P_f (\%)$','Interpreter','latex')
ylabel('PDF')
axis([5 11 0 400])
yticks([0 100 200 300 400 ])
h = gca;
h.FontSize = 14;


