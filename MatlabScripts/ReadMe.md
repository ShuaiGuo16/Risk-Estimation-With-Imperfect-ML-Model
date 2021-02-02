The source code and data to reproduce the results submitted to:

> S. Guo, C. F. Silva, W. Polifke. Reliable calculation of thermoacoustic instability risk using an imperfect surrogate model. ASME Turo Expo 2020, London, England

The files/folders are organized as follows:

**PDF_converge.m**: to train GP model using either space-filling method or adaptive-sampling method. 

**U_converge.m**: to show the convergence history of the adaptive training process.

**Adaptive_postprocess.m**: to compare the performance between adaptive method and passive method.

**RobustGP_v3.m**: to calculate risk factor PDF by considering GP uncertainty

**Cov_calculator.m**: to draw correlated samples from a trained GP model

**ErrorPf.m**: to visualize the performances of both methods

**ModelTraining**: this folder contains utilities required by GP training methods.

**HelmholtzCase**: this folder contains data/routines to reproduce the results associated with the Helmholtz case.

Pre-install UQLab (www.uqlab.com) is necessary to run the code
