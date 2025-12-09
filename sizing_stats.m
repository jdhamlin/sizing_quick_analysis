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
    N_supermicron, Dg, sigma_g] = sizing_stats(D, dN)

% check that diameter units are in nm (if not, issue warning and convert)
if D(1) < 1
    warning('Sizing stats converted D units to nm for mode calculations')
    D = D*1000;
else
end

[~, idx_20] = min(abs(D - 20));
[~, idx_100] = min(abs(D - 100));
[~, idx_1000] = min(abs(D - 1000));


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

% prompt user to calculate mode number or skip
% calculate_mode_N = input('enter 1 to calculate mode number concentration or 0 to skip:\n');
calculate_mode_N = 1;
for i = 1:num_samples
    current_dN = dN(i, :);
    % smoothed_dN = smoothdata(current_dN, 'sgolay', 7);
    smoothed_dN = smoothdata(current_dN, 'movmean', 21);

    % calculate mode diameter
    % idx = current_dN == max(current_dN);
    % mode_D(i, 1) = mean(D(idx));
    [~, iMax] = max(smoothed_dN);
    mode_D(i, 1) = D(iMax);

    % calculate geometric mean diameter, geometric standard deviation
    logDp = log10(D);
    logDg = sum(current_dN .* logDp) / sum(current_dN);
    Dg(i, 1) = 10^logDg;
    logVariance = sum(current_dN .* (logDp - logDg).^2) / sum(current_dN);
    sigma_g(i, 1) = 10^sqrt(logVariance);

    if calculate_mode_N == 1
    % calculate mode number concentrations

        if idx_20 == idx_100
            N_nucleation(i, 1) = NaN;
            N_aitken(i, 1) = NaN;
        else
            N_nucleation(i, 1) = ...
                trapz(log10(D(1:idx_20)), current_dN(1:idx_20));
            N_aitken(i, 1) = ...
                trapz(log10(D(idx_20:idx_100)), current_dN(idx_20:idx_100));
        end


        N_accumulation(i, 1) = ...
            trapz(log10(D(idx_100:idx_1000)), current_dN(idx_100:idx_1000));

        N_submicron(i, 1) = ...
            trapz(log10(D(1:idx_1000)), current_dN(1:idx_1000));


        if idx_1000 == size(D, 2)
            N_supermicron(i, 1) = NaN;
        else
            N_supermicron(i, 1) = ...
                trapz(log10(D(idx_1000:end)), current_dN(idx_1000:end));
        end
    else
    end
end

return