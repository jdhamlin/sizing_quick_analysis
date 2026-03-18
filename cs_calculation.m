%%% calculate condensation sink 

%%% references:
% 1. Wu et al., 2021
% 2. Kulmala et al., 2012

%%% notes:
% 1. unit conversions assume input units for D are nm and dN are cm^-3

%%% changelog (pre-git)
% 1. 20251006: 
%   1) Updated Kn calculation to fix unit conversion error
% 2. 20251107:
%   1) Updated to identify if D units are in nm and convert to nm if not.

function [CS] = cs_calculation(D, dN)

% constants 
lambda = 0.66e-6; % m; gas mean free path
D_SA = 0.8e-5; % diffusion coefficient of H2SO4

%%% unit conversions
% if units are in m, convert to nm
if max(D) < 1e-6
    D = D * 1e9;

    % if units in um, convert to nm
elseif max(D) < 1
    D = D * 1e3;
end

% D from nm to m
Dp = D * (10^-9);

% dN from cm^-3 to m^-3
dN = dN * 10^6;

% calculate size dependent variables

% Knudsen Number
Kn = 2*lambda ./ Dp; % unitless; 
Beta_m_numerator = 1 + Kn;
Beta_m_denominator = 1 + (1.677 * Kn) + (1.33 * Kn.^2);
Beta_m = Beta_m_numerator ./ Beta_m_denominator; % unitless; 

% calculate condensation sink
for i = 1:size(dN, 1)
    CS(i,:) = 2*pi*D_SA*sum(Beta_m .* Dp .* dN(i,:));
end

return