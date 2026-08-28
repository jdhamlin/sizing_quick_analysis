%%% lognormal size distribution fit
% lognorm3_fit
function [Dp_fit, dN_fit, N, Dg, sigma_g, pFit] = lognorm_fit(Dp, dN)

% Remove invalid values
valid = isfinite(Dp) & isfinite(dN) & Dp > 0 & dN > 0;

Dp = Dp(valid);
dN = dN(valid);

% Sort by diameter
[Dp, idx] = sort(Dp);
dN = dN(idx);

%%% Three-mode lognormal model
% p = [N1 Dg1 sigma1 N2 Dg2 sigma2 N3 Dg3 sigma3]

lognorm3 = @(p,Dp) ...
    (p(1) ./ (sqrt(2*pi)*log(p(3)))) .* ...
    exp(-(log(Dp)-log(p(2))).^2 ./ ...
    (2*log(p(3)).^2)) + ...
    (p(4) ./ (sqrt(2*pi)*log(p(6)))) .* ...
    exp(-(log(Dp)-log(p(5))).^2 ./ ...
    (2*log(p(6)).^2)) + ...
    (p(7) ./ (sqrt(2*pi)*log(p(9)))) .* ...
    exp(-(log(Dp)-log(p(8))).^2 ./ ...
    (2*log(p(9)).^2));

%%% Initial guesses
% These should roughly correspond to:
% nucleation, Aitken, accumulation
N_total = trapz(log(Dp), dN);

N1 = 0.2*N_total;
N2 = 0.4*N_total;
N3 = 0.4*N_total;

Dg1 = 15;
Dg2 = 50;
Dg3 = 150;

sigma1 = 1.5;
sigma2 = 1.7;
sigma3 = 1.8;

p0 = [N1 Dg1 sigma1 ...
      N2 Dg2 sigma2 ...
      N3 Dg3 sigma3];

%%% Bounds

lb = [ ...
    0, min(Dp), 1.05, ...
    0, min(Dp), 1.05, ...
    0, min(Dp), 1.05];

ub = [ ...
    Inf, max(Dp), 3.0, ...
    Inf, max(Dp), 3.0, ...
    Inf, max(Dp), 3.0];

%%% Objective in log space
eps_val = 1e-12;

obj = @(p,Dp) ...
    log(dN + eps_val) - ...
    log(lognorm3(p,Dp) + eps_val);

%%% Fit
opts = optimoptions('lsqcurvefit', ...
    'Display','off', ...
    'MaxFunctionEvaluations',5000, ...
    'MaxIterations',2000);

[pFit,~,~,exitflag] = lsqcurvefit( ...
    obj, p0, Dp, zeros(size(dN)), lb, ub, opts);

%%% Extract parameters
N = [pFit(1), pFit(4), pFit(7)];

Dg = [pFit(2), pFit(5), pFit(8)];

sigma_g = [pFit(3), pFit(6), pFit(9)];

%%% Fitted distribution
Dp_fit = logspace( ...
    log10(min(Dp)), ...
    log10(max(Dp)), ...
    500);

dN_fit = lognorm3(pFit,Dp_fit);

end
