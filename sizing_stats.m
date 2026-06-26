%% sizing_stats
% Justin Hamlin
% created: 8/11/2025

%%% produces: 
% 1. mode diameter
% 2. mode number concentrations
% 3. geometric mean diameter
% 4. geometric standard deviation

%%% notes:
% 1. Diameter must be in nm or converted to nm prior to execution

%%% changelog (pre-git):
% 1. 20251006: 
%   1) Incorporated conditional statement to input NaN for
%   supermicron N, if idx_1000 is the final diameter bin.
%   2) Incoprorated error statement to check that diameter bin units are in
%   nm.
% 2. 20251107:
%   1) Updated to identify if D units are in nm and convert to nm if not.

function [mode_D, N_nucleation, N_aitken, N_accumulation, N_submicron, ...
    N_supermicron, N, Dg, sigma_g] = sizing_stats(D, dN)

% check that diameter units are in nm (if not, issue warning and convert)
if D(1) < 1
    warning('Sizing stats converted D units to nm for mode calculations')
    D = D*1000;
else
end

idx_nucleation = D < 20;
idx_aitken = D >= 20   & D < 100;
idx_accumulation = D >= 100  & D < 1000;
idx_submicron = D < 1000;
idx_supermicron = D >= 1000;

% identify number of samples and size bins
[num_samples, num_bins] = size(dN);

% preallocate variables
mode_D = zeros(num_samples, 1);
N_nucleation = zeros(num_samples, 1);
N_aitken = zeros(num_samples, 1);
N_accumulation = zeros(num_samples, 1);
N_submicron = zeros(num_samples, 1);
N_supermicron = zeros(num_samples, 1);
Dg = zeros(num_samples, 1);
sigma_g = zeros(num_samples, 1);

for i = 1:num_samples
    current_dN = dN(i, :);
    N(i, 1) = trapz(log10(D), current_dN);
    % smooth data over time scale
    smoothed_dN = smoothdata(current_dN, 1, 'movmean', 21);

    % smooth data over size scale
    smoothed_dN = smoothdata(smoothed_dN, 2, 'movmean', 4);

    % calculate mode diameter
    [~, iMax] = max(smoothed_dN);
    mode_D(i, 1) = D(iMax);

    % calculate geometric mean diameter, geometric standard deviation
    logDp = log10(D);
    logDg = sum(current_dN .* logDp) / sum(current_dN);
    Dg(i, 1) = 10^logDg;
    logVariance = sum(current_dN .* (logDp - logDg).^2) / sum(current_dN);
    sigma_g(i, 1) = 10^sqrt(logVariance);

    % calculate mode number concentrations
    if ~any(idx_nucleation)
        N_nucleation(i, 1) = NaN;
    end
    if ~any(idx_aitken)
        N_aitken(i, 1) = NaN;
    else
        N_nucleation(i, 1) = ...
            trapz(log10(D(idx_nucleation)), current_dN(idx_nucleation));
        N_aitken(i, 1) = ...
            trapz(log10(D(idx_aitken)), current_dN(idx_aitken));
    end


    N_accumulation(i, 1) = ...
        trapz(log10(D(idx_accumulation)), current_dN(idx_accumulation));

    N_submicron(i, 1) = ...
        trapz(log10(D(idx_submicron)), current_dN(idx_submicron));


    if ~any(idx_supermicron)
        N_supermicron(i, 1) = NaN;
    else
        N_supermicron(i, 1) = ...
            trapz(log10(D(idx_supermicron)), current_dN(idx_supermicron));
    end
end

return