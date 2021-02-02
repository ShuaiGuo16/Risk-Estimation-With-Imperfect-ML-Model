function [RF_mean,RF_quantile,RF_hist,RV_num] = RobustGP_v3(GP_UQLab,samples)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Objective:
%            Calculate risk factor by considering GP uncertainty
%   Input:
%             GP_UQLab - GP model
%             samples - Monte Carlo samples
%   Output:
%              RF_mean - the mean value of RF
%              RF_quantile - the upper 2.5% quantile of RF distribution
%              RF_hist - full distribution of RF
%              RV_num  - random numbers (for diagnose)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Jan. 2020
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: None
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Reliable calculation of 
% thermoacoustic instability risk using an imperfect surrogate model",
% 2020, ASME Turo Expo, London, England, GT2020-14434
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sample_number = 20000;    % Monte Carlo for Risk Factor
alpha = 0.975;

% 1-Calculate all samples
[predict_GP,GP_var] = uq_evalModel(GP_UQLab,samples);

% Classification: Group1 (no need to change); Group2 (change) 
U = abs(predict_GP)./sqrt(GP_var);
Group1_num = sum(U>=3);   

% All Group 2
if Group1_num == 0     
    Group2_mean = uq_evalModel(GP_UQLab, samples(U<3,:));
    Group2_cov = Cov_calculator(GP_UQLab,samples(U<3,:));
    Group2_cov = (Group2_cov+Group2_cov')/2;
    % Propagate uncertainty to Risk Factor
    Group2_samples = mvnrnd(Group2_mean',Group2_cov,sample_number);
    RF = sum(Group2_samples>0,2)/size(samples,1);  
    
% All Group 1
elseif Group1_num == size(U,1)    % All Group 1
    Group1_mean = predict_GP(U>=3);
    RF = sum(Group1_mean>0)/size(samples,1);
    RF = RF*ones(sample_number,1);      % Maintain vector
    
% Mix Group 1 & 2
else                                  
    Group1_mean = predict_GP(U>=3);
    % Obtain the covariance of group 2
    Group2_mean = uq_evalModel(GP_UQLab, samples(U<3,:));
    Group2_cov = Cov_calculator(GP_UQLab,samples(U<3,:));
    Group2_cov = (Group2_cov+Group2_cov')/2;
    % Propagate uncertainty to Risk Factor
    Group2_samples = mvnrnd(Group2_mean',Group2_cov,sample_number);
    RF = (sum(Group1_mean>0)+sum(Group2_samples>0,2))/size(samples,1);
end

% Extract statistics
RF_mean = mean(RF);
RF_hist = RF;

RF_order = sort(RF);
RF_quantile = RF_order(floor(sample_number*alpha));

RV_num = size(samples(U<3,:),1);

end

