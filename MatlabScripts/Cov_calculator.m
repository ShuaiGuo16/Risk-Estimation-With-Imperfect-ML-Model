function [covariance] = Cov_calculator(GP_model,samples)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Objective:
%            Generate covariance matrix for samples
%   Input:
%            GP_model - GP model trained by UQLab
%            samples - Monte Carlo samples
%   Output:
%            covariance - the covariance matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Jan. 2020
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: UQLab
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Reliable calculation of 
% thermoacoustic instability risk using an imperfect surrogate model",
% 2020, ASME Turo Expo, London, England, GT2020-14434
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1-SigmaSqr
SigmaSqr = GP_model.Kriging.sigmaSQ;

% 2-fill psi vector
theta = 1./GP_model.Kriging.theta.^2*0.5;
p = 2;
psi = zeros(GP_model.ExpDesign.NSamples,size(samples,1));
for i=1:GP_model.ExpDesign.NSamples
    for j=1:size(samples,1)
        psi(i,j)=exp(-sum(theta.*abs(GP_model.ExpDesign.X(i,:)-samples(j,:)).^p));
    end
end

% fill psi_pred matrix
psi_p=zeros(size(samples,1),size(samples,1));
% Build upper half of correlation matrix
for i=1:size(samples,1)
	for j=i+1:size(samples,1)
		psi_p(i,j)=exp(-sum(theta.*abs(samples(i,:)-samples(j,:)).^p)); % abs added (February 10)
	end
end
psi_p=psi_p+psi_p'+eye(size(samples,1))+eye(size(samples,1)).*1e-10; 

% vector of ones
one=ones(GP_model.ExpDesign.NSamples,1);

% U matrix
[U,~]=chol(GP_model.Internal.Kriging.GP.R);

covariance = SigmaSqr*(psi_p-psi'*(U\(U'\psi))+(psi'*(U\(U'\one))-1)*((one'*(U\(U'\one)))\...
    (psi'*(U\(U'\one))-1)'));

end

