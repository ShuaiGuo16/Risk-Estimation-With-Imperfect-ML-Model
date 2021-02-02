function [GP_CAV,minU,training_X,training_Y] = GP_training_Helmholtz(maxIteration,training_method)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Objective:
%         Train a GP model with specified training sample size and training
%         method
%   Input:
%         maxIteration: Maximum number of training samples (for Space-filling)
%                       Maximum number of adaptive iterations (for Adaptive-sampling)
%         training_method: Space-filling/Adaptive-sampling
%   Output:
%         GP_CAV: the trained GP model for the first cavity mode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Jan. 2020
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: UQLab
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Reliable calculation of 
% thermoacoustic instability risk using an imperfect surrogate model",
% 2020, ASME Turo Expo, London, England, GT2020-14434
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1-Basic inputs info & initilization
minU = [];

switch training_method
    
    case 'Space-filling'
        
        % Initial training
        for ii = 1:3
            Input.Marginals(ii).Type = 'Uniform';
            Input.Marginals(ii).Parameters = [0 1];
        end
        ParaInput = uq_createInput(Input);

        % Add sample all-in-once
        training_X = uq_getSample(maxIteration,'Halton');        
        training_Y = Calculate_resp_helmholtz(training_X);
        % Train initial GP model 
        [Metaopts_CAV] = CreateMetaOpts_Halton(training_X,training_Y);
        GP_CAV = uq_createModel(Metaopts_CAV);
        
    case 'Adaptive-sampling'
        
        % Initial training
        load './data/candidate_Helm.mat'    % Candidate sample pool
        
        initial_sample_number = 30; 
        for ii = 1:3
            Input.Marginals(ii).Type = 'Uniform';
            Input.Marginals(ii).Parameters = [0 1];
        end
        ParaInput = uq_createInput(Input);
        
        training_X = uq_getSample(initial_sample_number,'Halton');        
        training_Y = Calculate_resp_helmholtz(training_X);
        % Train initial GP model CAV
        [Metaopts_CAV] = CreateMetaOpts_Halton(training_X,training_Y);
        GP_CAV = uq_createModel(Metaopts_CAV);
        [pred,var] = uq_evalModel(GP_CAV,candidate);
        
        % Adaptive training       
            for iter = 1:maxIteration
                
                [minU_CAV,pick_index,ratio_U_CAV] = U_learning(pred,var);
                minU = [minU;minU_CAV];
                   % Enrich training sample
                    training_X = [training_X;candidate(pick_index,:)];
                    new_Y = Calculate_resp_helmholtz(candidate(pick_index,:));
                    training_Y = [training_Y;new_Y];
                
                % Display results
                Mode = {'CAV'};
                Iteration = [iter];  TotalSample = [size(training_Y,1)];
                ratioU = [ratio_U_CAV]*size(candidate,1);
                T = table(Mode,Iteration,TotalSample,minU_CAV,ratioU)
                
                % Re-train model
                gref_ini = GP_CAV.Kriging.theta';
                clear GP_CAV
                
                % Use the previously trained GP model for initialization
                [Metaopts_CAV] = CreateMetaOpts_Local(training_X,training_Y,gref_ini);
                GP_CAV = uq_createModel(Metaopts_CAV);
                [pred,var] = uq_evalModel(GP_CAV,candidate);
                
            end
            
end


                

end

