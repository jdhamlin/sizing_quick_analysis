% Sea Spray Aerosol Density Calculator from Relative Humidity 
% Dr. Grant Deane (UCSD/SIO) and Raymond Leibensperger III (UCSD/SIO)
% Written: December 10th, 2021
% Edited and commented: February 2nd, 2022

% Edit line 13 to dictate where the function retrieves the
% SQA_Efflorescence.txt file

function rho = SSA_Density_Calc(RH)

% Load in hydration curves of SSA from Lewis and Schwartz, 2004: fig. 7
% load Deliquescence.txt                                                                            % from dry to humid
addpath('/Users/justi/OneDrive/Documents/0_UCSD/Research/MATLAB/APS/');    % Path to Efflorescnce .txt 
load SQA_Efflorescence.txt                                                                         % from humid to dry

rh = SQA_Efflorescence(end:-1:1,1); 
% read in relative humidity from efflorescence txt file
rad_ratio = SQA_Efflorescence(end:-1:1,2); 
% read in r/r_80 ratio from efflorescence txt file
r_80 = 1; 
% Sample radius at 80% RH, [μm]
rad = rad_ratio*r_80; 
% calculate particle radius as function of RH

v_salt = 4/3*pi*rad(1)^3; 
% calculate volume of salt crystal
v = 4/3*pi*rad.^3; 
% calculate volume of total SSA
v_water = v - v_salt; 
% calculate volume of water

rho_water = 1000; 
% Density of pure water [g/m3]
rho_salt = 1000*2.16;
% 304/236.6; % need actual density of sea salt
rho_vector = (v_water*rho_water + v_salt*rho_salt)./v; 
% create a vector of rho as function of RH
rho = interp1(rh,rho_vector,RH); 
% calculate a density at a specific RH
return
