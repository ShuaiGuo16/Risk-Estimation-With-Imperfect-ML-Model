function [GP_CAV,minU,training_X,training_Y] = GP_training(maxIteration,training_method)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Objective:
%         Train a GP model with specified training sample size and training
%         method
%   Input:
%         maxIteration: Maximum number of training samples (for Space-filling)
%                             Maximum number of adaptive iterations (for Adaptive-sampling)
%         training_method: Space-filling/Adaptive-sampling
%   Output:
%         GP_CAV: the trained GP model for CAV mode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2019
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: UQLab
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Reliable calculation of 
% thermoacoustic instability risk using an imperfect surrogate model",
% 2020, ASME Turo Expo, London, England, GT2020-14434
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1-Basic inputs info & initilization
options = optimoptions('fsolve','Display','off');
flame_mean = [2.85,0.7,3,1.8,3.3]/1000; N = 70; delta_t = 2e-4;

% Lower_bound first row, upper_bound second row, all uniform 
uncertainty = 0.1;
parameter_bound = [flame_mean-flame_mean*uncertainty;flame_mean+flame_mean*uncertainty];
parameter_bound(1,3) = 2/1000;   parameter_bound(2,3) = 4.8/1000;    % Correct tau_c bound
parameter_bound = [parameter_bound,[-1;-0.6]];      % Insert R as the last column
minU = [];

switch training_method
    
    case 'Space-filling'
        
        % Initial training
        for ii = 1:6
            Input.Marginals(ii).Type = 'Uniform';
            Input.Marginals(ii).Parameters = [0 1];
        end
        ParaInput = uq_createInput(Input);

        % Add sample all-in-once
        training_X = uq_getSample(maxIteration,'Halton');        
        training_Y = Calculate_resp(training_X,parameter_bound,N,delta_t,options);
        % Train initial GP model (CAV)
        [Metaopts_CAV] = CreateMetaOpts_Halton(training_X,training_Y(:,2));
        GP_CAV = uq_createModel(Metaopts_CAV);
        
    case 'Adaptive-sampling'
        
        % Initial training
        load './data/candidate1.mat'    % Candidate sample pool
        
        initial_sample_number = 60; % 10 times of input parameter number
        for ii = 1:6
            Input.Marginals(ii).Type = 'Uniform';
            Input.Marginals(ii).Parameters = [0 1];
        end
        ParaInput = uq_createInput(Input);
        
        training_X = uq_getSample(initial_sample_number,'Halton');        
        training_Y = Calculate_resp(training_X,parameter_bound,N,delta_t,options);
        % Train initial GP model CAV
        [Metaopts_CAV] = CreateMetaOpts_Halton(training_X,training_Y(:,2));
        GP_CAV = uq_createModel(Metaopts_CAV);
        [predict_CAV,CAV_var] = uq_evalModel(GP_CAV,candidate);
        
        % Adaptive training       
            for iter = 1:maxIteration
                
                [minU_CAV,index_CAV,ratio_U_CAV] = U_learning(predict_CAV,CAV_var);
                minU = [minU;minU_CAV];
                   % Enrich training sample
                    pick_index = index_CAV;
                    training_X = [training_X;candidate(pick_index,:)];
                    new_Y = Calculate_resp(candidate(pick_index,:),parameter_bound,N,delta_t,options);
                    training_Y = [training_Y;new_Y];
                
                % Display results
                Mode = {'CAV'};
                Iteration = [iter];  TotalSample = [size(training_Y,1)];
                ratioU = [ratio_U_CAV]*size(candidate,1);
                T = table(Mode,Iteration,TotalSample,minU_CAV,ratioU)
                
                % Re-train model
                clear GP_CAV
                
                [Metaopts_CAV] = CreateMetaOpts_Halton(training_X,training_Y(:,2));
                GP_CAV = uq_createModel(Metaopts_CAV);
                [predict_CAV,CAV_var] = uq_evalModel(GP_CAV,candidate);
                
            end
            
end
                

end

