clear
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Plot 3D stability margin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Jan. 2020
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Reliable calculation of 
% thermoacoustic instability risk using an imperfect surrogate model",
% 2020, ASME Turo Expo, London, England, GT2020-14434
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load './data/StabilityMargin.mat'

figure
hold on

% Figure setting
xlabel('n','FontSize',14)
ylabel('\tau ms','FontSize',14)
zlabel('|R_{out}|','FontSize',14)
set(gca,'FontSize',14)
grid on
box on
ax = gca;
ax.BoxStyle = 'full'
axis([0.4 2 3 6.5 0.5 1])
view(-15,18)


pointer = 1;
for i = 1:50
    % Extract the sample number
    add_number = StabilityMargin(2,pointer);
    % Determine the parameters
    fgain = StabilityMargin(1,pointer+1:add_number+pointer);
    tdelay = 1e3*StabilityMargin(2,pointer+1:add_number+pointer);
    MagRn = StabilityMargin(1,pointer)*ones(1,add_number);
    % Plot the figure
    plot3(fgain,tdelay,MagRn,'k','LineWidth',1.2)
    % Update the pointer
    pointer = pointer + add_number +1;
end


% Plot the training samples
load './data/adaptive_training.mat'
range = [0.4,3e-3,0.5;2,6.5e-3,1]; 
scale_X = Scale(training_X,range);
scatter3(scale_X(1:10,1),scale_X(1:10,2)*1000,scale_X(1:10,3),60,'filled','s')
scatter3(scale_X(31:end,1),scale_X(31:end,2)*1000,scale_X(31:end,3),60,'filled','o')

hold off