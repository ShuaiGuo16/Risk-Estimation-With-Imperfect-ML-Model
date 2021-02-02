clear
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Generate Fig. 7 in Ref [1]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Reliable calculation of 
% thermoacoustic instability risk using an imperfect surrogate model",
% 2020, ASME Turo Expo, London, England, GT2020-14434
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load './data/minU.mat'

figure(1)
hold on
plot([60 200],[1.65,1.65],'r--','LineWidth',1.2)
plot(60:60+length(minU)-1,minU,'k','LineWidth',1.2)
plot(60+length(minU)-1,minU(end),'ob','MarkerSize',8,'MarkerFaceColor','b')
plot([60+length(minU)-1,60+length(minU)-1],[minU(end),0],'b--','LineWidth',1.2)
hold off

xlabel('Training sample number')
ylabel('U')
axis([60 200 0 2])
h = gca;
h.FontSize = 14;