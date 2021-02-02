clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Calculate statbility limit for different R_out values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Jan. 2020
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Reliable calculation of 
% thermoacoustic instability risk using an imperfect surrogate model",
% 2020, ASME Turo Expo, London, England, GT2020-14434
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uqlab

%% 1.0-Train a GP model
load './Results/adaptive_training.mat'
Metaopts = CreateMetaOpts_Halton(training_X, training_Y);
GP_CAV = uq_createModel(Metaopts);

%% 1.1-Specify input parameter range
fgain_std = linspace(0.4,2,30);
tdelay_std = linspace(3e-3,6.5e-3,30);
[X,Y] = meshgrid(fgain_std,tdelay_std);

%% 1.2-Loop through all the R-out levels
level_number = 51;
MagRn_std = linspace(0.5,1,level_number);
StabilityMargin = [];

for loop = 1:level_number
    
    % Convert back to normalized values 
    fgain = (fgain_std-0.4)/1.6;
    tdelay = (tdelay_std-3e-3)/3.5e-3;
    MagRn = (MagRn_std(loop)-0.5)/0.5;
    [X_norm, Y_norm] = meshgrid(fgain,tdelay);
    
    % Helmholtz prediction
    response = zeros(30,30);
    for i = 1:30
        for j = 1:30
            sample = [X_norm(i,j),Y_norm(i,j),MagRn];
            response(i,j) = uq_evalModel(GP_CAV,sample);
        end
    end
    
    % Extract the mean data
    [C1,h1] = contour(X,Y,response,'LevelList',0,'LineColor','k','ShowText','on','LineWidth',2);
    C1(1,1) = MagRn_std(loop);
    StabilityMargin = [StabilityMargin,C1];
    disp(loop)
    
end
save './data/StabilityMargin.mat' StabilityMargin 