%%% SQA_aps_3330_row
% Purpose: Quickly process data file from the APS. Based on SQA created by
% RJLIII. It will generate figures to quickly visualize a single data file.
% Author: Justin Hamlin
% Date: 20240906

function SQA_aps_3321(APSFileName, APSDataName)
%% APS Data Import
% Row exported dW/dlogDp

[Dp, dN, numScans, scanNo, N, Dg, sigma_g, t, last_update] = ...
    aps_3321_export(APSFileName);

%% Figure standardization
CM = turbo(numScans);
fs = 12; % set font size
lw = 1.5; % set line width
ms = 2; % set marker size

%% Figure 2: Concentration contour plot
figure(2), clf
fig = tiledlayout(2,1);
fig.TileSpacing = 'tight';
fig.Title.String = ' ';

% Enter figure data
nexttile(1)
colormap(turbo)

imagesc(t, Dp, dN');
hold on

axis('xy')
ylabel('Aerodynamic Diameter [\mum]', 'FontSize', fs) % set ylabel
set(gca, 'YScale', 'log')
ylim([min(Dp) max(Dp)])
c = colorbar;
c.Location = 'northoutside';
c.TickDirection = 'out';

ax = gca;
ax.ColorScale = 'linear';
ax.FontSize = fs;
ax.TickDir = 'out';

c.Title.String = 'dN/dlogD_a [cm^{-3}]';
c.Title.FontSize = fs;

ax.CLim = [0 1.2*max(N)];
xlim('tight')

nexttile(2)
plot(t, N, Marker='none', ...
    MarkerEdgeColor='#1a1a1a', MarkerFaceColor='#1a1a1a', ...
    MarkerSize=ms, Color='#1a1a1a', LineWidth=lw, LineStyle='-')
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
% xlim([x1 x2])
xlim('tight')
ylim([0 max(N)*1.2])
ylabel('N [cm^{-3}]', 'FontSize', fs) % set ylabel
set(gca, 'YScale', 'linear')

set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size

%% Figure 5: Mode and Total Concentration
figure(5), clf
colororder({'#67001f','#053061'})
% Enter figure data
yyaxis left
plot(t, N, marker='none', LineWidth=lw, MarkerSize=ms)
ylabel('N [cm^{-3}]', 'FontSize', fs) % set xlabel
ylim([0 200])

yyaxis right
plot(t, Dg, marker='none', LineWidth=lw, MarkerSize=ms)
ylabel('Mean D_g [nm]', 'FontSize', fs) % set xlabel
ylim([min(Dp) max(Dp)])
set(gca, 'YScale', 'log')

set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
xlim('tight')
title('APS: Total Number and Mean Geometric Diameter', 'FontSize', fs)


%% Figure 7: Concentration contour plot
figure(7), clf
fig = tiledlayout(2,1);
fig.TileSpacing = 'tight';

% Enter figure data
nexttile(1)
colormap(turbo)

imagesc(1:length(N), Dp, dN');
hold on

axis('xy')
ylabel('Aerodynamic Diameter [\mum]', 'FontSize', fs) % set ylabel
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
distribution.name = 'APS';
distribution.D = Dp; % Units: um
distribution.dN = dN;
distribution.N = N;
distribution.Dg = Dg;
distribution.sigma_g = sigma_g;
distribution.last_update = last_update;
distribution.t = t;


%% Save data files
matDir = uigetdir('C:/Users/justi/OneDrive/Documents/0_UCSD/Research/Data/', ...
    'Select directory to save .mat file');
if matDir == 0
    disp('.mat save cancelled')
    return
end
save(sprintf('%s.mat', APSDataName), 'distribution')
end