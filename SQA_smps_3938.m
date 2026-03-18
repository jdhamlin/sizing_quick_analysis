%% Sizing Quick Analysis - SMPS
% Purpose: Quickly process data file from the SMPS. Based on SQA
% created by RJLIII. It will generate 4 figures to look at quick analysis
% of size distributions. It will then save the distribution into a .mat
% file.

%%% NOTE: CHECK END OF SCRIPT FOR CORRECT FILE PATHS IF YOU ARE SAVING DATA 

function SQA_smps_3938(SMPSFileName, SMPSDataName)
% SMPSFileName: .txt file of inverted data
% SMPSDataName: File name you want to save the distributions under for
% further analysis

%% Unit Conversions
nanometer_meter = 1e-9; %nm to m
milliliter_cubicmeter = 1e-6; %cm^{3} to m^{3}
micron_meter = 1e-6; %μm to m

%% SMPS Data Import
% Save variables

[Dp, dNdlog10Dp, numScans, scanNo, N, Dg, RH_a, T_a, T_sh, t, ...
    last_update] = smps_3938_export(SMPSFileName);

%% Figure stadardization
CM = turbo(numScans);
fs = 13; % set font size
lw = 1.5; % set line width
ms = 2; % set marker size
%% Plot Variables of Interest

% %%% Figure 1: Number Concentration
% % Enter figure data
% figure(1), clf
% hold on
% for i = 1:numScans
%     semilogx(Dp, dNdlog10Dp(i,:), 'color', CM(i,:))
% end
% 
% title('Number Concentrations', 'FontSize', fs)
% xlabel('Diameter [nm]', 'FontSize', fs) % set xlabel
% ylabel('dN/dlogDp [cm^{-3}]', 'FontSize', fs) % set ylabel
% set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
% set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
% set(gca, 'XScale', 'log')
% xlim([10^1 10^3])
%%
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
ylim([10^1 10^3])
colorbar
set(gca,'ColorScale','linear')
title(colorbar, 'dN/dlogD_p [cm^{-3}]', 'FontSize', fs)
clim([0 1.2*max(N)])
xlim('tight')

nexttile(2)
plot(t, N, Marker='none', ...
    MarkerEdgeColor='#404040', MarkerFaceColor='#404040', ...
    MarkerSize=ms, Color='#404040', LineWidth=lw, LineStyle='-')
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
xlim('tight')
ylim([0 1.2*max(N)])
ylabel('N [cm^{-3}]', 'FontSize', fs) % set ylabel
set(gca, 'YScale', 'linear')

set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size

%% Figure 5: Mode and Total Concentration
figure(5), clf
colororder({'#67001f','#053061'})
% Enter figure data
yyaxis left
plot(t, N, Marker='none', LineWidth=lw, MarkerSize=ms)
ylabel('N [cm^{-3}]', 'FontSize', fs) % set xlabel
ylim([0 max(N)])

yyaxis right
plot(t, Dg, Marker='none', LineWidth=lw, MarkerSize=ms)
ylabel('Mean D_g [nm]', 'FontSize', fs) % set xlabel
ylim([10^1 10^3])
set(gca, 'YScale', 'log')

set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
xlim('tight')
title('SMPS: Total Number and Mean Geometric Diameter', 'FontSize', fs)

%%% Figure 6: Temperature and Relative Humidity
figure(6), clf
colororder({'#67001f','#053061'})
% Enter figure data
yyaxis left
plot(t, RH_a, Marker='none', LineWidth=lw, MarkerSize=ms)
ylabel('Relative Humidity [%]', 'FontSize', fs) % set xlabel
ylim([0 60])

yyaxis right
plot(t, T_a, Marker='none', LineWidth=lw, MarkerSize=ms)
ylabel(['Temperature [' char(176) 'C]'], 'FontSize', fs) % set xlabel
ylim([0 40])

set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
xlim('tight')
title('SMPS: Temperature and Relative Humidity', 'FontSize', fs)

%%% Figure 7: Concentration contour plot - X axis: scan number
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
ylim([10^1 10^3])
colorbar
set(gca,'ColorScale','linear')
title(colorbar, 'dN/dlogD_p [cm^{-3}]', 'FontSize', fs)

nexttile(2)
plot(1:length(N), N, Marker='none', ...
    MarkerEdgeColor='#404040', MarkerFaceColor='#404040', ...
    MarkerSize=ms, Color='#404040', LineWidth=lw, LineStyle='-')
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
xlim('tight')
ylabel('N [cm^{-3}]', 'FontSize', fs) % set ylabel
set(gca, 'YScale', 'log')
xlabel(fig, 'Scan Number', 'FontSize', fs) % set ylabel

set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size

%% Average Data and Calculate New Variables

% Get New Inputs to correct data
fprintf('Number of SMPS scans: %d\n', numScans)

% Set bounds to calculate average PNSD
SMPS_start = input('Enter the initial SMPS scan of interest: ');
SMPS_stop = input('Enter the final SMPS scan of interest: ');

% Create start and stop scan variable to save for reference
AvgPeriod = [SMPS_start SMPS_stop];

% RH_avg = mean(RH_a(SMPS_start:SMPS_stop));
% T_avg = mean(T_a(SMPS_start:SMPS_stop));

mean_dNdlogDp_SMPS = mean(dNdlog10Dp(SMPS_start:SMPS_stop,:));
mean_dNdlogDp_SMPS(isnan(mean_dNdlogDp_SMPS)) = 0;

% Calculate Surface Area and Volume Concentrations
mean_dSAdlogDp_SMPS = ...
    4*pi*((Dp/2)*nanometer_meter/micron_meter).^2.*mean_dNdlogDp_SMPS;
mean_dVdlogDp_SMPS = ...
    4/3*pi*((Dp/2)*nanometer_meter/micron_meter).^3.*mean_dNdlogDp_SMPS;
dN_norm = mean_dNdlogDp_SMPS/trapz(log10(Dp), mean_dNdlogDp_SMPS);
dSA_norm = mean_dSAdlogDp_SMPS/trapz(log10(Dp), mean_dSAdlogDp_SMPS);
dV_norm = mean_dVdlogDp_SMPS/trapz(log10(Dp), mean_dVdlogDp_SMPS);

%% Replot Variables of Interest

%%% Figure 7 Update
% Add red vertical line indicating scan period averaged over
figure(7)
nexttile(1)
xline(SMPS_start,Color='r',LineWidth=lw)
xline(SMPS_stop,Color='r',LineWidth=lw)

nexttile(2)
xline(SMPS_start,Color='r',LineWidth=lw)
xline(SMPS_stop,Color='r',LineWidth=lw)

%%% Figure 8: Mean Number Concentration
% Enter figure data
figure(8), clf
hold on
plot(Dp, mean_dNdlogDp_SMPS, Color='k', LineWidth=lw, Marker='none', ...
    MarkerSize=ms)

title('Average Particle Number Size Distribution', 'FontSize', fs)
xlabel('Diameter [nm]', 'FontSize', fs) % set xlabel
ylabel('dN/dlogDp [cm^{-3}]', 'FontSize', fs) % set ylabel
set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
set(gca, 'XScale', 'log')
xlim([10^1 10^3])

%%% Figure 9: N, SA, and M distributions
figure(9), clf
hold on
semilogx(Dp, dN_norm, Color='k', ...
    LineWidth=lw, Marker='none', MarkerSize=ms)

semilogx(Dp, dSA_norm, Color='r', ...
    LineWidth=lw, Marker='none', MarkerSize=ms)
semilogx(Dp, dV_norm, Color='b', ...
    LineWidth=lw, Marker='none', MarkerSize=ms)


title('Normalized Distribution Moments', 'FontSize', fs)
xlabel('Diameter [nm]', 'FontSize', fs) % set xlabel
ylabel('Normalized Distribution Moments', 'FontSize', fs) % set ylabel
set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
set(gca, 'XScale', 'log')
xlim([10 1000])
legend('1^{st} Moment [Number Density]', '2^{nd} Moment [Surface Area Density]', ...
    '3^{rd} Moment [Volume Density]', 'Location', 'southoutside', ...
    'Orientation', 'horizontal', 'FontSize', fs)
legend boxoff

%% Save Data  
distribution(1).name = 'SMPS';
distribution(1).D = Dp; % Units: nm
distribution(1).dN = dNdlog10Dp;
distribution(1).N = N;
distribution(1).Dg = Dg;
distribution(1).T = T_a;
distribution(1).RH = RH_a;
distribution(1).last_update = last_update;
distribution(1).t = t;

% % Averaged data
distribution(1).AvgPeriod = AvgPeriod;
distribution(1).RH_avg = RH_avg;
distribution(1).T_avg = T_avg;
distribution(1).mean_dNdlogDp = mean_dNdlogDp_SMPS;
distribution(1).mean_dSAdlogDp = mean_dSAdlogDp_SMPS;
distribution(1).mean_dVdlogDp = mean_dVdlogDp_SMPS;


% cd C:/Users/justi/OneDrive/Documents/0_UCSD/Research/Data/2026/experiments/mart_surfactants/sizing/processed/
cd C:/Users/justi/OneDrive/Documents/0_UCSD/Research/Data/2025/2025_smps_mat/
save(sprintf('%s.mat', SMPSDataName), 'distribution')

return