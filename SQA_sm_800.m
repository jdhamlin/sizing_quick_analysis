%% Sizing Quick Analysis - Spider-MAGIC
% Purpose: Quickly process data file from the Spider-MAGIC from SOARS data. 
% Based on SQA created by RJLIII. It will generate 4 figures for quick analysis
% of size distributions. It will then save the distribution into a .mat
% file.

function SQA_SpiderMAGIC_SOARS(SMFileName, SpiderDataName)
% SMFileName: .txt file of inverted data
% SpiderDataName: File name you want to save the distributions under for
% further analysis

%% Unit Conversions
nanometer_meter = 1e-9; %nm to m
milliliter_cubicmeter = 1e-6; %cm^{3} to m^{3}
micron_meter = 1e-6; %μm to m

%% Spider-MAGIC Data Import
% Save variables

[Dp, dNdlog10Dp, scanNo, N, Dg, version, T, RH, V1, ion_ratio, ...
    last_update, numScans, t] = SpiderMAGIC_export(SMFileName);

%% Figure stadardization
CM = turbo(numScans);
fs = 13; % set font size
lw = 1.5; % set line width
ms = 2; % set marker size
%% Plot Variables of Interest

%%% Figure 1: Number Concentration
% Enter figure data
figure(1), clf
hold on
for i = 1:numScans
    semilogx(Dp, dNdlog10Dp(i,:), 'color', CM(i,:))
end

title('Number Concentrations', 'FontSize', fs)
xlabel('Diameter [nm]', 'FontSize', fs) % set xlabel
ylabel('dN/dlogDp [cm^{-3}]', 'FontSize', fs) % set ylabel
set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
set(gca, 'XScale', 'log')
xlim([0 500])
%%
% x1 = datetime(2024,09,17,18,00,00);
% x2 = datetime(2024,09,18,09,00,00);
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
% ylim([10^1 10^3])
ylim([0 500])
c = colorbar;
c.Location = 'eastoutside';
c.TickDirection = 'out';
% c.Position = [0.92 0.55 0.01 0.37];
set(gca,'ColorScale','linear')
title(c, 'dN/dlogD_p [cm^{-3}]', 'FontSize', fs-2)
clim([0 max(N)])
% xlim([x1 x2])
xlim('tight')

nexttile(2)
plot(t, N, Marker='o', ...
    MarkerEdgeColor='#404040', MarkerFaceColor='#404040', ...
    MarkerSize=ms, Color='#404040', LineWidth=lw, LineStyle='none')
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
% xlim([x1 x2])
xlim('tight')
ylim([0 max(N)])
ylabel('N [cm^{-3}]', 'FontSize', fs) % set ylabel
set(gca, 'YScale', 'linear')

set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
%%
%%% Figure 3: Scan Polarity Comparison
pu = V1 < 10 & V1 > 0;
pd = V1 > 4000;
ni = V1 > -10 & V1 < 0;
nd = V1 < -4000;

% Set standard x and y limits
ymin = 0;
ymax = 5000;
xmin = min(t);
xmax = max(t);

figure(3), clf


plot(t(pu), N(pu), Marker='^',...
    MarkerEdgeColor='#404040', MarkerFaceColor='#404040', ...
    MarkerSize=ms, Color='#404040', LineWidth=lw, LineStyle='none')
hold on
plot(t(pd), N(pd), Marker='v', ...
    MarkerEdgeColor='#404040', MarkerFaceColor='#404040', ...
    MarkerSize=ms, Color='#404040', LineWidth=lw, LineStyle='none')
plot(t(ni), N(ni),Marker='^', ...
    MarkerEdgeColor='#ca0020', MarkerFaceColor='#ca0020', ...
    MarkerSize=ms, Color='#ca0020', LineWidth=lw, LineStyle='none')
plot(t(nd), N(nd), Marker='v', ...
    MarkerEdgeColor='#ca0020', MarkerFaceColor='#ca0020', ...
    MarkerSize=ms, Color='#ca0020', LineWidth=lw, LineStyle='none')
xlim('tight')
ylim([0 max(N)])
set(gca, 'YScale', 'log', 'TickDir','out')
title('Total Number by Scan Polarity and Ramp Direction', 'FontSize', fs)
ylabel('N [cm^{-3}]', 'FontSize', fs) % set ylabel
set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out


%%% Figure 4: Colormap by Scan Polarity and Direction of Voltage Ramp
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

set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size

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
end

%%% Figure 5: Mode and Total Concentration
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
ylim([0 500])
set(gca, 'YScale', 'log')

set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
xlim('tight')
title('Spider-MAGIC: Total Number and Mean Geometric Diameter', 'FontSize', fs)

%%% Figure 6: RH and T
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

set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
xlim('tight')
title('Spider-MAGIC: Temperature and Relative Humidity', 'FontSize', fs)

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
ylabel('N [cm^{-3}]', 'FontSize', fs) % set ylabel
set(gca, 'YScale', 'log')
xlabel(fig, 'Scan Number', 'FontSize', fs) % set ylabel

set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size

%% Average Data and Calculate New Variables

% Get New Inputs to correct data
fprintf('Number of Spider-MAGIC scans: %d\n', numScans)

% Set bounds to calculate average PNSD
SM_start = input('Enter the initial SM scan of interest: ');
SM_stop = input('Enter the final SM scan of interest: ');

% Create start and stop scan variable to save for reference
AvgPeriod = [SM_start SM_stop];

RH_avg = mean(RH(SM_start:SM_stop));
T_avg = mean(T(SM_start:SM_stop));

mean_dNdlogDp_SM = mean(dNdlog10Dp(SM_start:SM_stop,:));
mean_dNdlogDp_SM(isnan(mean_dNdlogDp_SM)) = 0;

% Calculate Surface Area and Volume Concentrations
mean_dSAdlogDp_SM = ...
    4*pi*((Dp/2)*nanometer_meter/micron_meter).^2.*mean_dNdlogDp_SM;
mean_dVdlogDp_SM = ...
    4/3*pi*((Dp/2)*nanometer_meter/micron_meter).^3.*mean_dNdlogDp_SM;
dN_norm = mean_dNdlogDp_SM/trapz(log10(Dp), mean_dNdlogDp_SM);
dSA_norm = mean_dSAdlogDp_SM/trapz(log10(Dp), mean_dSAdlogDp_SM);
dV_norm = mean_dVdlogDp_SM/trapz(log10(Dp), mean_dVdlogDp_SM);

%% Replot Variables of Interest

%%% Figure 7 Update
% Add red vertical line indicating scan period averaged over
figure(7)
nexttile(1)
xline(SM_start,Color='r',LineWidth=lw)
xline(SM_stop,Color='r',LineWidth=lw)

nexttile(2)
xline(SM_start,Color='r',LineWidth=lw)
xline(SM_stop,Color='r',LineWidth=lw)

%%% Figure 8: Mean Number Concentration
% Enter figure data
figure(8), clf
hold on
plot(Dp, mean_dNdlogDp_SM, Color='k', LineWidth=lw, Marker='o', ...
    MarkerSize=ms)

title('Average Particle Number Size Distribution', 'FontSize', fs)
xlabel('Diameter [nm]', 'FontSize', fs) % set xlabel
ylabel('dN/dlogDp [cm^{-3}]', 'FontSize', fs) % set ylabel
set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
set(gca, 'XScale', 'log')
xlim([0 500])

%%% Figure 9: N, SA, and M distributions
figure(9), clf
hold on
semilogx(Dp, dN_norm, Color='k', ...
    LineWidth=lw, Marker='o', MarkerSize=ms)

semilogx(Dp, dSA_norm, Color='r', ...
    LineWidth=lw, Marker='o', MarkerSize=ms)
semilogx(Dp, dV_norm, Color='b', ...
    LineWidth=lw, Marker='o', MarkerSize=ms)


title('Normalized Distribution Moments', 'FontSize', fs)
xlabel('Diameter [nm]', 'FontSize', fs) % set xlabel
ylabel('Normalized Distribution Moments', 'FontSize', fs) % set ylabel
set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
set(gca, 'XScale', 'log')
xlim([0 500])
legend('1^{st} Moment [Number Density]', '2^{nd} Moment [Surface Area Density]', ...
    '3^{rd} Moment [Volume Density]', 'Location', 'southoutside', ...
    'Orientation', 'horizontal', 'FontSize', fs)
legend boxoff

%% Save Data  
distribution(1).name = 'Spider-MAGIC';
distribution(1).D = Dp; % Units: nm
distribution(1).dN = dNdlog10Dp;
distribution(1).N = N;
distribution(1).Dg = Dg;
distribution(1).T = T;
distribution(1).RH = RH;
distribution(1).V1 = V1;
distribution(1).ion_ratio = ion_ratio;
distribution(1).last_update = last_update;
distribution(1).t = t;
% Averaged data
distribution(1).AvgPeriod = AvgPeriod;
distribution(1).RH_avg = RH_avg;
distribution(1).T_avg = T_avg;
distribution(1).mean_dNdlogDp = mean_dNdlogDp_SM;
distribution(1).mean_dSAdlogDp = mean_dSAdlogDp_SM;
distribution(1).mean_dVdlogDp = mean_dVdlogDp_SM;

%% Save data files
cd C:\Users\justi\OneDrive\Documents\0_UCSD\Research\Data\2025\2025_SpiderMAGIC_mat\SQA\
save(sprintf('%s.mat', SpiderDataName), 'distribution')

return