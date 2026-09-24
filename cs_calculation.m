%%% calculate condensation sink 
% CS = cs_calculation(D, dN, D_units)

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

function CS = cs_calculation(D, dN, D_units)

% constants 
lambda = 0.066e-6; % m, gas mean free path at 20 
D_SA = 0.8e-5; % m^2/s, diffusion coefficient of H2SO4

%%% unit conversions
switch lower(D_units)
    case 'nm'
        Dp = D * 1e-9;
    case 'um'
        Dp = D * 1e-6;
    case 'm'
        Dp = D;
    otherwise
        error('D_units must be nm, um, or m')
end

% dN from cm^-3 to m^-3
dN = dN * 1e6;

% calculate size dependent variables

% Knudsen Number
Kn = 2*lambda ./ Dp; % unitless 
Beta_m = (1 + Kn) ./ (1 + 1.677 * Kn + 1.333 * Kn.^2); % unitless

% calculate condensation sink
CS = zeros(size(dN, 1), 1);
for i = 1:size(dN, 1)
    CS(i,1) = 2*pi*D_SA * sum(Beta_m .* Dp .* dN(i,:));
end

return