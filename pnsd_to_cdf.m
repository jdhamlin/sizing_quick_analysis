%%% Convert Number Size Distribution to Cumulative Distribution Function

function CDF = pnsd_to_cdf(Dp, dN)

% determine normalization factor
dlogDp = diff(log10(Dp));

% trim PNSD data
dN = dN(1:end-1);

% remove dlogDp normalization
N = dN .* dlogDp;

% compute CDF
CDF = cumsum(N) ./ sum(N);

end