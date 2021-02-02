function [ Metaopts ] = CreateMetaOpts_Local( X, Y, initial)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Specify options for Gaussian Process model training
%            in UQLab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS
%   ===> X: matrix, each row represents a training sample
%   ===> Y: matrix, each row represents the four responses of the 
%                corresponding training sample
%   ===> initial: initial values for optimization (column vector)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUTS
%   ===> Metaopts: Options for Gaussian Process model training
%            in UQLab (for details please see "Kriging UserManual" of
%            UQLab in www.uqlab.com)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Jan. 2020
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Reliable calculation of 
% thermoacoustic instability risk using an imperfect surrogate model",
% 2020, ASME Turo Expo, London, England, GT2020-14434
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Metaopts.Type = 'Metamodel';
Metaopts.MetaType = 'Kriging';
Metaopts.ExpDesign.Sampling = 'user';
Metaopts.ExpDesign.X = X;
Metaopts.ExpDesign.Y = Y;

Metaopts.Scaling = 0;     % impose no scaling
Metaopts.Trend.Type = 'ordinary';   % constant trend
Metaopts.Corr.Type = 'Separable';
Metaopts.Corr.Family = 'Gaussian';
Metaopts.EstimMethod = 'ML';
Metaopts.Optim.Method = 'BFGS';
Metaopts.Optim.InitialValue = initial;
Metaopts.Optim.MaxIter = 100;

end

