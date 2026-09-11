%% Sizing Quick Analysis - Spider-MAGIC
% Purpose: Quickly process data file from the Spider-MAGIC from SOARS data. 
% Based on SQA created by RJLIII. It will generate 4 figures for quick analysis
% of size distributions. It will then save the distribution into a .mat
% file.

function SQA_sm_800(SMFileName, SpiderDataName)
% SMFileName: .txt file of inverted data
% SpiderDataName: File name you want to save the distributions under for
% further analysis

%% Unit Conversions
nanometer_meter = 1e-9; %nm to m
milliliter_cubicmeter = 1e-6; %cm^{3} to m^{3}
micron_meter = 1e-6; %μm to m

%% Spider-MAGIC Data Import
% Save variables
% [Dp, dNdlog10Dp, scanNo, N, Dg, version, T, RH, V1, ion_ratio, ...
%     last_update, numScans, t, wick_sat] = sm_800_export(SMFileName);

[Dp, dNdlog10Dp, ~, N, Dg, ~, T, RH, V1, ion_ratio, ...
    last_update, numScans, t, wick_sat] = sm_800_export(SMFileName);

%% Figure standardization
CM = turbo(numScans);
fs = 12; % set font size
lw = 1.5; % set line width
ms = 2; % set marker size

%% Plot Variables of Interest

%%% Figure 2: Concentration contour plot
figure(2), clf
fig = tiledlayout(2,1);
fig.TileSpacing = 'tight';

% Enter figure data
nexttile(1)
colormap(turbo)

imagesc(t, Dp, dNdlog10Dp');
hold on

axis('xy')
ylabel('Diameter [nm]', 'FontSize', fs) % set ylabel
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
set(gca, 'YScale', 'log')
ylim([0 500])
c = colorbar;
c.Location = 'eastoutside';
c.TickDirection = 'out';
set(gca,'ColorScale','linear')
title(c, 'dN/dlogD_p [cm^{-3}]', 'FontSize', fs-2)
clim([0 max(N)])
xlim([min(t) max(t)])


nexttile(2)
plot(t, N, Marker='o', ...
    MarkerEdgeColor='#404040', MarkerFaceColor='#404040', ...
    MarkerSize=ms, Color='#404040', LineWidth=lw, LineStyle='none')
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
xlim([min(t) max(t)])
ylim([0 max(N)])
ylabel('N [cm^{-3}]', 'FontSize', fs) % set ylabel
set(gca, 'YScale', 'linear')

set(gcf, 'Units', 'normalized', 'Position', [0.1 0.1 0.5 0.8], 'Color', 'w')
%%
%%% Figure 3: Scan Polarity Comparison
pu = V1 < 10 & V1 > 0;
pd = V1 > 4000;
ni = V1 > -10 & V1 < 0;
nd = V1 < -4000;

figure(3), clf
hold on
plot(t(pu), N(pu), Marker='^',...
    MarkerEdgeColor='#404040', MarkerFaceColor='#404040', ...
    MarkerSize=ms, Color='#404040', LineWidth=lw, LineStyle='none', ...
    DisplayName='HV+ Up')
plot(t(pd), N(pd), Marker='v', ...
    MarkerEdgeColor='#404040', MarkerFaceColor='#404040', ...
    MarkerSize=ms, Color='#404040', LineWidth=lw, LineStyle='none', ...
    DisplayName='HV+ Down')
plot(t(ni), N(ni),Marker='^', ...
    MarkerEdgeColor='#ca0020', MarkerFaceColor='#ca0020', ...
    MarkerSize=ms, Color='#ca0020', LineWidth=lw, LineStyle='none', ...
    DisplayName='HV- Up')
plot(t(nd), N(nd), Marker='v', ...
    MarkerEdgeColor='#ca0020', MarkerFaceColor='#ca0020', ...
    MarkerSize=ms, Color='#ca0020', LineWidth=lw, LineStyle='none', ...
    DisplayName='HV- Down')
xlim([min(t) max(t)])
ylim([0 max(N)])

leg = legend;
leg.Location = 'best';
leg.AutoUpdate = 'off';

set(gca, 'YScale', 'log', 'TickDir','out')
title('Total Number by Scan Polarity and Ramp Direction', 'FontSize', fs)
ylabel('N [cm^{-3}]', 'FontSize', fs) % set ylabel
set(gcf, 'Units', 'normalized', 'Position', [0.1 0.1 0.5 0.5], 'Color', 'w')
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
xline(max(t))
yline(max(N))

%% Figure 4: Colormap by Scan Polarity and Direction of Voltage Ramp
figure(4), clf
fig = tiledlayout(4,1);
fig.TileSpacing = 'tight';
nexttile(1)
colormap(turbo)

imagesc(t(pu(1:end-1,:)), Dp, dNdlog10Dp(pu(1:end-1,:),:)');
hold on

axis('xy')
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
set(gca, 'YScale', 'log')
ylim([0 500])
colorbar
set(gca,'ColorScale','linear')
title('Positive, Increasing', 'FontSize', fs)

nexttile(2)
colormap(turbo)

imagesc(t(pd(1:end-1,:)), Dp, dNdlog10Dp(pd(1:end-1,:),:)');
hold on

axis('xy')
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
set(gca, 'YScale', 'log')
ylim([0 500])
colorbar
set(gca,'ColorScale','linear')
title('Positive, Decreasing', 'FontSize', fs)

nexttile(3)
colormap(turbo)

imagesc(t(ni(1:end-1,:)), Dp, dNdlog10Dp(ni(1:end-1,:),:)');
hold on

axis('xy')
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
set(gca, 'YScale', 'log')
ylim([0 500])
colorbar
set(gca,'ColorScale','linear')
title('Negative, Increasing', 'FontSize', fs)

nexttile(4)
colormap(turbo)

imagesc(t(nd(1:end-1)), Dp, dNdlog10Dp(nd(1:end-1,:),:)');
hold on

axis('xy')
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
set(gca, 'YScale', 'log')
ylim([0 500])
colorbar
set(gca,'ColorScale','linear')
title('Negative, Decreasing', 'FontSize', fs)
ylabel(fig, 'Diameter [nm]', 'FontSize', fs) % set ylabel

set(gcf, 'Units', 'normalized', 'Position', [0.1 0.1 0.5 0.8], 'Color', 'w')

for i = 1:4
    nexttile(i)
    set(gca,'FontSize',fs) % set figure color to white
    clim([0 max(N)])
    if i == 1
    title(colorbar, 'dN/dlogD_p [cm^{-3}]', 'FontSize', fs-2)
    end
    if i ~= 4
        set(gca, 'XTickLabel', ' ')
        ylabel(' ')
    end
    xlim([min(t) max(t)])
end

%% Figure 5: Mode and Total Concentration
figure(5), clf
colororder({'#67001f','#053061'})

% Enter figure data
yyaxis left
plot(t, N, marker='o', LineWidth=lw, MarkerSize=ms)
ylabel('N [cm^{-3}]', 'FontSize', fs) % set xlabel
ylim([0 1.2*max(N)])

yyaxis right
plot(t, Dg, marker='o', LineWidth=lw, MarkerSize=ms)
ylabel('Mean D_g [nm]', 'FontSize', fs) % set xlabel
ylim([0 500])
set(gca, 'YScale', 'log')

set(gcf, 'Units', 'normalized', 'Position', [0.1 0.1 0.5 0.8], 'Color', 'w')
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
xlim('tight')
title('Spider-MAGIC: Total Number and Mean Geometric Diameter', 'FontSize', fs)

%% Figure 6: RH and T
figure(6), clf
colororder({'#67001f','#053061'})

% Enter figure data
yyaxis left
plot(t, RH, marker='o', LineWidth=lw, MarkerSize=ms)
ylabel('Relative Humidity [%]', 'FontSize', fs) % set xlabel
ylim([0 60])

yyaxis right
plot(t, T, marker='o', LineWidth=lw, MarkerSize=ms)
ylabel(['Temperature [' char(176) 'C]'], 'FontSize', fs) % set xlabel
ylim([0 40])

set(gcf, 'Units', 'normalized', 'Position', [0.1 0.1 0.5 0.8], 'Color', 'w')
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
xlim('tight')
title('Spider-MAGIC: Temperature and Relative Humidity', 'FontSize', fs)

%% Figure 7: Concentration contour plot - X axis: scan number
figure(7), clf
fig = tiledlayout(2,1);
fig.TileSpacing = 'tight';

% Enter figure data
nexttile(1)
colormap(turbo)

imagesc(1:length(N), Dp, dNdlog10Dp');
hold on

axis('xy')
ylabel('Diameter [nm]', 'FontSize', fs) % set ylabel
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
set(gca, 'YScale', 'log')
ylim([0 500])
colorbar
set(gca,'ColorScale','linear')
title(colorbar, 'dN/dlogD_p [cm^{-3}]', 'FontSize', fs-2)

nexttile(2)
plot(1:length(N), N, Marker='o', ...
    MarkerEdgeColor='#404040', MarkerFaceColor='#404040', ...
    MarkerSize=ms, Color='#404040', LineWidth=lw, LineStyle='none')
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
xlim('tight')
ylim([0 1.2*max(N)])
ylabel('N [cm^{-3}]', 'FontSize', fs) % set ylabel
set(gca, 'YScale', 'log')
xlabel(fig, 'Scan Number', 'FontSize', fs) % set ylabel

set(gcf, 'Units', 'normalized', 'Position', [0.1 0.1 0.5 0.8], 'Color', 'w')

%% Save Data  
distribution.name = 'Spider-MAGIC';
distribution.D = Dp; % Units: nm
distribution.dN = dNdlog10Dp;
distribution.N = N;
distribution.Dg = Dg;
distribution.T = T;
distribution.RH = RH;
distribution.V1 = V1;
distribution.ion_ratio = ion_ratio;
distribution.last_update = last_update;
distribution.t = t;
distribution.wick_sat = wick_sat;

%% Save data files

matDir = uigetdir('C:/Users/justi/OneDrive/Documents/0_UCSD/Research/Data/', ...
    'Select directory to save .mat file');
if matDir ~= 0
    cd(matDir)
    save(sprintf('%s.mat', SpiderDataName), 'distribution')
else
    disp('.mat save cancelled')
    return
end

return