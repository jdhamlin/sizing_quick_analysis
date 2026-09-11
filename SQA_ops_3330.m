%%% SQA_ops_3330_row
% Purpose: Quickly process data file from the OPS. Based on SQA created by
% RJLIII. It will generate figures to quickly visualize a single data file.
% MUST BE EXPORTED IN ROW FORMAT
% Author: Justin Hamlin
% Date: 20240906

function SQA_ops_3330(OPSFileName, OPSDataName)
%% OPS Data Import
% Row exported dW/dlogDp

[Dp, dNdlog10Dp, numScans, scanNo, N, Dg, T, t, last_update] = ...
    ops_3330_export(OPSFileName);

%% Figure standardization
CM = turbo(numScans);
fs = 12; % set font size
lw = 1.5; % set line width
ms = 2; % set marker size

%% Figure 2: Concentration contour plot
figure(2), clf
fig = tiledlayout(2,1);
fig.TileSpacing = 'tight';

% Enter figure data
nexttile(1)
colormap(turbo)

imagesc(t, Dp, dNdlog10Dp');
hold on

axis('xy')
ylabel('Optical Diameter [\mum]', 'FontSize', fs) % set ylabel
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
set(gca, 'YScale', 'log')
colorbar
set(gca,'ColorScale','linear')
title(colorbar, 'dN/dlogD_p [cm^{-3}]', 'FontSize', fs)
clim([0 max(N)])
ylim([min(Dp) max(Dp)])

nexttile(2)
plot(t, N, Marker='o', ...
    MarkerEdgeColor='#404040', MarkerFaceColor='#404040', ...
    MarkerSize=ms, Color='#404040', LineWidth=lw, LineStyle='none')
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
xlim('tight')
ylim([0 max(N)])
ylabel('N [cm^{-3}]', 'FontSize', fs) % set ylabel
set(gca, 'YScale', 'log')

set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size

%% Figure 5: Mode and Total Concentration
figure(5), clf
colororder({'#67001f','#053061'})
% Enter figure data
yyaxis left
plot(t, N, marker='o', LineWidth=lw, MarkerSize=ms)
ylabel('N [cm^{-3}]', 'FontSize', fs) % set xlabel
ylim([0 max(N)])

yyaxis right
plot(t, Dg, marker='o', LineWidth=lw, MarkerSize=ms)
ylabel('Mean D_g [nm]', 'FontSize', fs) % set xlabel
ylim([min(Dp) max(Dp)])
set(gca, 'YScale', 'log')

set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
xlim('tight')
title('OPS: Total Number and Mean Geometric Diameter', 'FontSize', fs)

%% Figure 6: Mode and Total Concentration
figure(6), clf
% Enter figure data

plot(t, T, marker='o', LineWidth=lw, MarkerSize=ms, Color='k')
ylabel(['Temperature [' char(176) 'C]'], 'FontSize', fs) % set xlabel
ylim([0 50])

set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
xlim('tight')
title('OPS: Temperature', 'FontSize', fs)

%%% Figure 7: Concentration contour plot
figure(7), clf
fig = tiledlayout(2,1);
fig.TileSpacing = 'tight';

% Enter figure data
nexttile(1)
colormap(turbo)

imagesc(1:length(N), Dp, dNdlog10Dp');
hold on

axis('xy')
ylabel('Optical Diameter [\mum]', 'FontSize', fs) % set ylabel
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
set(gca, 'YScale', 'log')
colorbar
set(gca,'ColorScale','linear')
title(colorbar, 'dN/dlogD_p [cm^{-3}]', 'FontSize', fs)
clim([0 max(N)])
ylim([min(Dp) max(Dp)])

nexttile(2)
plot(1:length(N), N, Marker='o', ...
    MarkerEdgeColor='#404040', MarkerFaceColor='#404040', ...
    MarkerSize=ms, Color='#404040', LineWidth=lw, LineStyle='none')
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
xlim('tight')
ylim([0 max(N)])
ylabel('N [cm^{-3}]', 'FontSize', fs) % set ylabel
set(gca, 'YScale', 'log')

set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size


%% Save Data
distribution.name = 'OPS';
distribution.D = Dp; % Units: um
distribution.dN = dNdlog10Dp;
distribution.N = N;
distribution.Dg = Dg;
distribution.T = T;
distribution.last_update = last_update;
distribution.t = t;

%% Save data files
matDir = uigetdir('C:/Users/justi/OneDrive/Documents/0_UCSD/Research/Data/', ...
    'Select directory to save .mat file');
if matDir ~= 0
    cd(matDir)
    save(sprintf('%s.mat', OPSDataName), 'distribution')
else
    disp('.mat save cancelled')
    return
end

end