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
colormap(jet)

imagesc(t, Dp, dNdlog10Dp');
hold on

axis('xy')
ylabel('Diameter [nm]', 'FontSize', fs) % set ylabel
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
set(gca, 'YScale', 'log')
ylim([10^1 10^3])
colorbar
set(gca,'ColorScale','log')
title(colorbar, 'dN/dlogD_p [cm^{-3}]', 'FontSize', fs)
clim([1e1 1e4])
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


%% Save Data  
distribution.name = 'SMPS';
distribution.D = Dp; % Units: nm
distribution.dN = dNdlog10Dp;
distribution.N = N;
distribution.Dg = Dg;
distribution.T = T_a;
distribution.RH = RH_a;
distribution.last_update = last_update;
distribution.t = t;

%% Save data files

matDir = uigetdir('C:/Users/justi/OneDrive/Documents/0_UCSD/Research/Data/', ...
    'Select directory to save .mat file');
if matDir ~= 0
    cd(matDir)
    save(sprintf('%s.mat', SMPSDataName), 'distribution')
else
    disp('.mat save cancelled')
    return
end

return