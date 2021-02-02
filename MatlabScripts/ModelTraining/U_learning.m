function [minU,index,ratio_U] = U_learning(predict_GP,GP_var)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Objective:
%         Calculate the U learning function
%   Input:
%         predict_GP: Nominal GP predictions
%         GP_var:  Cariance of GP predictions
%   Output:
%         minU: the current minimum U value
%         index: index corresponding to minimum U value
%         ratio_U: number of U's bigger than 1.65
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2019
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: None
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Reliable calculation of 
% thermoacoustic instability risk using an imperfect surrogate model",
% 2020, ASME Turo Expo, London, England, GT2020-14434
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

U = abs(predict_GP)./sqrt(GP_var);
[minU,index] = min(U);
% For diagnose
partialU = sum(U>1.65);
ratio_U = partialU/size(U,1);

end

