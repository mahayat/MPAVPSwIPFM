function [SDRR, SDSD, SD1, SD2] = poincare(tk)
% Based On: 
% Do Existing Measures of Poincaré Plot Geometry Reflect 
% Nonlinear Features of Heart Rate Variability?
RRn = diff(tk);
SDRR = std(RRn);

del_RRn = diff(RRn);
SDSD = std(del_RRn);

SD1 = sqrt(0.5*SDSD^2);
SD2 = sqrt(2*SDRR^2-0.5*SDSD^2);
end