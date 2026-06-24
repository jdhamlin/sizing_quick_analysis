%%% lognormal size distribution fit

function [Dp_fit, dN_fit, N, Dg, sigma_g] = lognorm_fit(Dp, dN)

% remove zeros and NaNs
valid = dN > 0 & ~isnan(dN);
Dp = Dp(valid);
dN = dN(valid);

% lognormal model
lognorm = @(p, Dp) ...
    (p(1) ./ (sqrt(2*pi) * log(p(3)))) .* ...
    exp(-(log(Dp) - log(p(2))).^2 ./ (2*log(p(3)).^2));

% improved initial guesses
N0 = max(dN);
Dg0 = Dp(dN == max(dN));
sigma_g0 = 2.0;

p0 = [N0, Dg0, sigma_g0];

% bounds
lb = [0, min(Dp)*0.5, 1.05];
ub = [Inf, max(Dp)*2, 5.0];

% epsilon to avoid log(0)
eps_val = 1e-12;

% objective in log-space
obj = @(p, Dp) log(dN + eps_val) - log(lognorm(p, Dp) + eps_val);

opts = optimoptions('lsqcurvefit','Display','off');

[pFit, ~] = lsqcurvefit(obj, p0, Dp, zeros(size(dN)), lb, ub, opts);

% output
N = pFit(1);
Dg = pFit(2);
sigma_g = pFit(3);

Dp_fit = logspace(log10(min(Dp)), log10(max(Dp)), 500);
dN_fit = lognorm(pFit, Dp_fit);

end
