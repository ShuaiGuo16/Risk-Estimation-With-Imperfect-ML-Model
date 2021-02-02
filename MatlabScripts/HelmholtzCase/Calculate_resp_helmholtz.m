function [response] = Calculate_resp_helmholtz( X )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Calculate the responses of the training samples using 
%            helmholtz solver
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS
%   ===> X: matrix, each row represents one training sample
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUTS
%   ===> response: vector, growth rate values 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Jan. 2020
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: none
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Reliable calculation of 
% thermoacoustic instability risk using an imperfect surrogate model",
% 2020, ASME Turo Expo, London, England, GT2020-14434
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extract information
sample_number = size(X,1);
response = zeros(sample_number,1);

% de-normalize samples
fgain_std = 1.6*X(:,1)+0.4;
tdelay_std = 3.5e-3*X(:,2)+3e-3;
MagRn_std = 0.5*X(:,3)+0.5;

% Helmholtz solver settings
ArgRs=0; ArgRn=pi; MagRs=0.9; configs = 4; 
s_init = 1i*145*2*pi;
for cal_resp = 1:sample_number
    [~,response(cal_resp)] = ...
        Helmholtz_n_tau('Secant',fgain_std(cal_resp),tdelay_std(cal_resp),...
        MagRs,ArgRs,MagRn_std(cal_resp),ArgRn,170,configs,s_init);
end

end

