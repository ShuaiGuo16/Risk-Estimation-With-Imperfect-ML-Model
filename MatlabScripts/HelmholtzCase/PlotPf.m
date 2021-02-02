clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Plot the Pf error for both sampling methods
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Jan. 2020
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: None
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Reliable calculation of 
% thermoacoustic instability risk using an imperfect surrogate model",
% 2020, ASME Turo Expo, London, England, GT2020-14434
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load data
load './data/MC.mat'
load './data/Pf_Halton.mat' 
load './data/std_Halton.mat'
load './data/Pf_adaptive.mat' 
load './data/std_adaptive.mat'

% Reference results
RF_ref = sum(Y(:,2)>0)/size(Y,1);

% Training sample number
Iteration = 30:5:50; Iteration = [Iteration,53];

figure(1)
hold on
% Plot the passive sampling results
patch_X = [Iteration,Iteration(end:-1:1)];
patch_Y = [Pf_Halton+3*std_Halton;Pf_Halton(end:-1:1)-3*std_Halton(end:-1:1)]*100;
patch(patch_X',patch_Y,[0.7 0.7 0.7],'LineStyle','none')
plot(Iteration,Pf_Halton*100,'--k','LineWidth',1.2)
% Plot the adaptive sampling results
errorbar(Iteration,Pf_adaptive*100,3*std_adaptive*100,'bo','LineWidth',1.2,'MarkerFaceColor','b')
% Plot the reference results
plot(Iteration,RF_ref*ones(length(Iteration),1)*100,':r','LineWidth',1.2)
hold off

axis([30 55 41 43])
yticks([41 41.5 42 42.5 43])
xlabel('Training sample number')
ylabel('$P_f (\%)$','Interpreter','latex')
h = gca;
h.FontSize = 14;