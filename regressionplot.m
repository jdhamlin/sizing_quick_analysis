%% regression function
function regressionplot(ax, x, y, varName, alpha, ms, lw, fs, mType, mColor)

% Fit linear model
mdl = fitlm(x, y);

% Plot regression
h = plot(ax, mdl);
h(1).Color = 'k';

if mType == "default"
    h(1).Marker = 'o';
else
    h(1).Marker = mType;
end

if mColor == "default"
    h(1).MarkerFaceColor = '#bababa';
else
    h(1).MarkerFaceColor = mColor;
end
h(1).MarkerSize = ms;
h(2).Color = 'b';
h(2).LineWidth = lw;

% reorder so data is plotted first
uistack(h(1), 'top')

% % remove confidence bounds
delete(h(3))

% Match axis limits
all_vals = [x; y];
lims = [0.8*min(all_vals), 1.2*max(all_vals)];
dataRange = range(lims);

xlim(ax, lims); 
ylim(ax, lims);

% 1:1 reference line
plot(ax, lims, lims, 'k--', 'LineWidth', lw-1, 'DisplayName', '1:1');

% Stats
slope = mdl.Coefficients{"x1","Estimate"};
slope_p = mdl.Coefficients{"x1","pValue"};
intercept = mdl.Coefficients{"(Intercept)","Estimate"};
intercept_p = mdl.Coefficients{"(Intercept)","pValue"};
RMSE = mdl.RMSE;
[r, r_p] = corr(x, y);

% Strings with conditional p formatting
r_str = sprintf('r = %.2f%s', r, ternary(r_p<alpha,'*',sprintf('')));
rmse_str = sprintf('RMSE = %.2f', RMSE);
if intercept > 1
    sign = "+";
elseif intercept < 1
    sign = "-";
end

slope_str = sprintf('%.2f%s', slope, ternary(slope_p<alpha,'*',sprintf('')));
intercept_str = sprintf('%.2f%s', abs(intercept), ternary(intercept_p<alpha,'*',sprintf('')));
eq_str = sprintf('y = %s x %s %s', slope_str, sign, intercept_str);

xpos = lims(1) + 0.15*dataRange;
ypos = lims(2) - 0.07*dataRange;
yoff = 0.08*dataRange;

text(ax, xpos, ypos, r_str, 'FontSize', fs-2, 'FontWeight','normal');
text(ax, xpos, ypos - yoff, eq_str, 'FontSize', fs-2, 'FontWeight', 'normal');
text(ax, xpos, ypos - 2*yoff, rmse_str, 'FontSize', fs-2, 'FontWeight', 'normal');


% Clean variable name
cleanVar = strrep(varName,'_',' ');

% Labels
title(ax, '');

xlabel(ax, sprintf('SMPS-APS: %s', cleanVar));
ylabel(ax, sprintf('SM-OPS: %s', cleanVar));

leg = legend(ax); 
leg.Location = 'southeast';
leg.AutoUpdate = 'off';

% Axis formatting
axis(ax,'square');
ax.Box = 'off'; 
ax.TickDir = 'out';
ax.TickLength = [0.02 0.025]; 
ax.FontSize = fs;
ax.YTick = ax.XTick;
xline(ax.XLim(2))
yline(ax.YLim(2))
end

function out = ternary(cond,a,b), if cond, out=a; else, out=b; end, end