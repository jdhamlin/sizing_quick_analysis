%%% SQA_modulair_2
% Purpose: Quickly process data file from the modulair. Based on SQA created by
% RJLIII. It will generate figures to quickly visualize a single data file.
% Author: Justin Hamlin
% Date: 20240906

function SQA_modulair(modulairFileName, modulairDataName)
%% modulair Data Import
% Row exported dW/dlogDp

[Dp, dNdlog10Dp, t, N, RH, T, wd, ws, pm1, pm2_5, pm10, co, no, no2, ...
    o3, co2, numScans, last_update, serial_no] = modulair_export(modulairFileName);
dN = dNdlog10Dp;
%% Figure standardization
CM = turbo(numScans);
fs = 13; % set font size
lw = 1.5; % set line width
ms = 2; % set marker size

% %% Average Data and Calculate Volume and SA Distributions
% 
% interval = minutes(30);
% fprintf('Averaging window set to %s \n', char(interval));
% 
% start_time = t(1);
% stop_time = t(end);
% time_frame = start_time:interval:stop_time;
% 
% for i = 1:length(time_frame)-1
%     idx(:,i) = t >= time_frame(i) & t <= time_frame(i+1);
%     t_avg{:,i} = t(idx(:,i));
%     t_first(i) = t_avg{:,i}(1);
%     N_avg(i) = mean(N(idx(:,i)));
%     dN_avg(i,:) = mean(dN(idx(:,i),:));
%     T_avg(i) = mean(T(idx(:,i)));
%     RH_avg(i) = mean(RH(idx(:,i)));
%     co_avg(i) = mean(co(idx(:,i)));
%     co2_avg(i) = mean(co2(idx(:,i)));
%     no_avg(i) = mean(no(idx(:,i)));
%     no2_avg(i) = mean(no2(idx(:,i)));
%     o3_avg(i) = mean(o3(idx(:,i)));
%     pm1_avg(i) = mean(pm1(idx(:,i)));
%     pm10_avg(i) = mean(pm10(idx(:,i)));
%     pm2_5_avg(i) = mean(pm2_5(idx(:,i)));
%     wd_avg(i) = mean(wd(idx(:,i)));
%     ws_avg(i) = mean(ws(idx(:,i)));
% end
% 
% % Calculate Surface Area and Volume Concentrations
% dSA_avg = ...
%     4*pi*((Dp/2)).^2.*dN_avg;
% for l = 1:size(dSA_avg,1)
%     SA(l) = trapz(log10(Dp), dSA_avg(l,:));
% end
% 
% dV_avg = ...
%     4/3*pi*((Dp/2)).^3.*dN_avg;
% for m = 1:size(dV_avg,1)
%     V(m) = trapz(log10(Dp), dV_avg(m,:));
% end

% %% Plot Variables of Interest
% 
% %%% Figure 1: Number Concentration
% % Enter figure data
% figure(1), clf
% hold on
% for i = 1:length(dN)
%     semilogx(Dp, dN(i,:), 'color', CM(i,:))
% end
% 
% title('Number Size Distributions', 'FontSize', fs)
% xlabel('Optical Diameter [\mum]', 'FontSize', fs) % set xlabel
% ylabel('dN/dlogD_p [cm^{-3}]', 'FontSize', fs) % set ylabel
% set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
% set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
% set(gca, 'XScale', 'log')
% xlim([min(Dp) max(Dp)])
% box on
% 
% % set colorbar properties
% c = colorbar;
% cLimits = clim;
% validTimes = t(~isnat(t));
% uniqueDays = unique(dateshift(validTimes, 'start', 'day'));
% cTicks = linspace(cLimits(1), cLimits(2), length(uniqueDays));
% c.Ticks = cTicks;
% c.TickDirection = 'out';
% c.TickLabels = cellstr(datestr(uniqueDays, 'dd-mmm-yyyy'));
% c.Location = 'eastoutside';
% colormap(CM)

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
ylabel('Optical Diameter [\mum]', 'FontSize', fs) % set ylabel
set(gca, 'YScale', 'log')
ylim([min(Dp) max(Dp)])
c = colorbar;
c.Location = 'northoutside';
c.TickDirection = 'out';

ax = gca;
ax.ColorScale = 'linear';
ax.FontSize = fs;
ax.TickDir = 'out';

c.Title.String = 'dN/dlogD_p [cm^{-3}]';
c.FontSize = fs;
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

%% Figure 3: Mode and Total Concentration
%%% Add once Dg Calculation is correct

% %% Figure 4: RH and T
% figure(4), clf
% fig4 = tiledlayout(2,1);
% fig4.TileSpacing = 'tight';
% fig4.Title.String = {sprintf('%s Averaging Window', char(interval))};
% 
% nexttile(1)
% plot(t_first, RH_avg, Marker='none', ...
%     LineWidth=lw, LineStyle='-', Color='k')
% ylim([0 1.2*max(RH_avg)])
% ylabel('Relative Humidity [%]')
% 
% nexttile(2)
% plot(t_first, T_avg, Marker='none', ...
%     LineWidth=lw, LineStyle='-', Color='k')
% ylim([0 1.2*max(T_avg)])
% ylabel(['Temperature [' char(176) 'C]'])
% 
% for i = 1:2
%     nexttile(i)
%     ax = gca;
%     ax.TickDir = 'out';
%     ax.Box = 'on';
%     ax.XLim = [min(t_first) max(t_first)];
%     ax.FontSize = fs;
%     if i < 2
%         ax.XTickLabel = [];
%     end
%     grid on
% end
% 
% set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
% 
% %% Figure 5: Gas Concentrations
% figure(5), clf
% fig5 = tiledlayout(5,1);
% fig5.Title.String = {sprintf('%s Averaging Window', char(interval))};
% fig5.TileSpacing = 'tight';
% 
% nexttile(1)
% plot(t_first, co_avg, marker='none', ...
%     LineWidth=lw, LineStyle='-', Color='k')
% ylim([0 1.2*max(co_avg)])
% ylabel('CO [ppb]')
% 
% nexttile(2)
% plot(t_first, co2_avg, marker='none', ...
%     LineWidth=lw, LineStyle='-', Color='k')
% ylim([0 1.2*max(co2_avg)])
% ylabel('CO_2 [ppm]')
% 
% nexttile(3)
% plot(t_first, no_avg, marker='none', ...
%     LineWidth=lw, LineStyle='-', Color='k')
% ylim([0 1.2*max(no_avg)])
% ylabel('NO [ppb]')
% 
% nexttile(4)
% plot(t_first, no2_avg, marker='none', ...
%     LineWidth=lw, LineStyle='-', Color='k')
% ylim([0 1.2*max(no2_avg)])
% ylabel('NO_2 [ppb]')
% 
% nexttile(5)
% plot(t_first, o3_avg, marker='none', ...
%     LineWidth=lw, LineStyle='-', Color='k')
% ylim([0 1.2*max(o3_avg)])
% ylabel('O_3 [ppb]')
% 
% for i = 1:5
%     nexttile(i)
%     ax = gca;
%     ax.TickDir = 'out';
%     ax.Box = 'on';
%     ax.XLim = [min(t_first) max(t_first)];
%     ax.FontSize = fs;
%     if i == 1
%         ax.XAxisLocation = 'top';
%     elseif i < 5
%         ax.XTickLabel = [];
%     end
%     grid on
% end
% 
% set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
% 
% %% Figure 6: PM Concentrations
% figure(6), clf
% fig6 = tiledlayout(3,1);
% fig6.Title.String = {sprintf('%s Averaging Window', char(interval))};
% fig6.TileSpacing = 'tight';
% 
% nexttile(1)
% plot(t_first, pm1_avg, marker='none', ...
%     LineWidth=lw, LineStyle='-', Color='k')
% ylim([0 1.2*max(pm1_avg)])
% ylabel('PM_1 [\mug m^{-3}]')
% 
% nexttile(2)
% plot(t_first, pm2_5_avg, marker='none', ...
%     LineWidth=lw, LineStyle='-', Color='k')
% ylim([0 1.2*max(pm2_5_avg)])
% ylabel('PM_{2.5} [\mug m^{-3}]')
% 
% nexttile(3)
% plot(t_first, pm10_avg, marker='none', ...
%     LineWidth=lw, LineStyle='-', Color='k')
% ylim([0 1.2*max(pm10_avg)])
% ylabel('PM_{10} [\mug m^{-3}]')
% 
% for i = 1:3
%     nexttile(i)
%     ax = gca;
%     ax.TickDir = 'out';
%     ax.Box = 'on';
%     ax.XLim = [min(t_first) max(t_first)];
%     ax.FontSize = fs;
%     if i == 1
%         ax.XAxisLocation = 'top';
%     elseif i < 3
%         ax.XTickLabel = [];
%     end
%     grid on
% end
% 
% set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
% 
% %% Figure 7: Wind Speed and Direction 
% 
% figure(7), clf
% fig7 = tiledlayout(2,1);
% fig7.Title.String = {sprintf('%s Averaging Window', char(interval))};
% fig7.TileSpacing = 'tight';
% 
% nexttile(1)
% plot(t_first, ws_avg, marker='none', ...
%     LineWidth=lw, LineStyle='-', Color='k')
% ylim([0 1.2*max(ws_avg)])
% ylabel('Wind Speed [mph]')
% 
% nexttile(2)
% plot(t_first, wd_avg, marker='none', ...
%     LineWidth=lw, LineStyle='-', Color='k')
% ylim([0 360])
% ylabel('Wind Direction [deg]')
% 
% for i = 1:2
%     nexttile(i)
%     ax = gca;
%     ax.TickDir = 'out';
%     ax.Box = 'on';
%     ax.XLim = [min(t_first) max(t_first)];
%     ax.FontSize = fs;
%     if i < 2
%         ax.XTickLabel = [];
%     end
%     grid on
% end
% 
% set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
% 
% %% Figure 8: Number Size Distributions
% % Redefine colormap for subsequent figures
% CM = turbo(length(dN_avg));
% 
% figure(8), clf
% hold on
% for i = 1:size(dN_avg,1)
%     semilogx(Dp, dN_avg(i,:), 'color', CM(i,:))
% end
% 
% title({sprintf('%s Mean Number Size Distributions', char(interval))})
% xlabel('Diameter [nm]', 'FontSize', fs) % set xlabel
% ylabel('Mean dN/dlogD_p [cm^{-3}]', 'FontSize', fs) % set ylabel
% set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
% set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
% set(gca, 'XScale', 'log')
% xlim([min(Dp) max(Dp)])
% box on
% 
% % set colorbar properties
% c = colorbar;
% cLimits = clim;
% validTimes = t(~isnat(t));
% uniqueDays = unique(dateshift(validTimes, 'start', 'day'));
% cTicks = linspace(cLimits(1), cLimits(2), length(uniqueDays));
% c.Ticks = cTicks;
% c.TickDirection = 'out';
% c.TickLabels = cellstr(datestr(uniqueDays, 'dd-mmm-yyyy'));
% c.Location = 'eastoutside';
% colormap(CM)
% 
% %% Figure 9: Concentration contour plot
% figure(9), clf
% fig9 = tiledlayout(2,1);
% fig9.TileSpacing = 'tight';
% fig9.Title.String = ' ';
% 
% % Enter figure data
% nexttile(1)
% colormap(turbo)
% 
% imagesc(t_first, Dp, dN_avg');
% hold on
% 
% axis('xy')
% ylabel('Optical Diameter [\mum]', 'FontSize', fs) % set ylabel
% set(gca, 'YScale', 'log')
% ylim([min(Dp) max(Dp)])
% c = colorbar;
% c.Location = 'northoutside';
% c.TickDirection = 'out';
% 
% ax = gca;
% ax.ColorScale = 'linear';
% ax.FontSize = fs;
% ax.TickDir = 'out';
% 
% c.Title.String = 'dN/dlogD_p [cm^{-3}]';
% c.Title.FontSize = fs;
% ax.CLim = [0 max(N_avg)*1.2];
% xlim('tight')
% 
% nexttile(2)
% plot(t_first, N_avg, Marker='none', ...
%     MarkerEdgeColor='#1a1a1a', MarkerFaceColor='#1a1a1a', ...
%     MarkerSize=ms, Color='#1a1a1a', LineWidth=lw, LineStyle='-')
% set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
% % xlim([x1 x2])
% xlim('tight')
% ylim([0 max(N_avg)*1.2])
% ylabel('N [cm^{-3}]', 'FontSize', fs) % set ylabel
% set(gca, 'YScale', 'linear')
% 
% 
% annotation('textbox', ...
%     'String', {sprintf('%s Averaging Window', char(interval))}, ...
%     'BackgroundColor', 'none', 'Position', [0.135 0.33 0.1 0.1], ...
%     'FontSize', fs, 'HorizontalAlignment', 'left', ...
%     'EdgeColor', 'none')
% 
% set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
% 
% %% Figure 10: SA Size Distributions
% figure(10), clf
% hold on
% for i = 1:size(dSA_avg,1)
%     semilogx(Dp, dSA_avg(i,:), 'color', CM(i,:))
% end
% 
% title({sprintf('%s Mean Surface Area Size Distributions', char(interval))})
% xlabel('Diameter [\mum]', 'FontSize', fs) % set xlabel
% ylabel('Mean dSA/dlogD_p [\mum^{2} cm^{-3}]', 'FontSize', fs) % set ylabel
% set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
% set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
% set(gca, 'XScale', 'log')
% xlim([min(Dp) max(Dp)])
% box on
% 
% % set colorbar properties
% c = colorbar;
% cLimits = clim;
% validTimes = t(~isnat(t));
% uniqueDays = unique(dateshift(validTimes, 'start', 'day'));
% cTicks = linspace(cLimits(1), cLimits(2), length(uniqueDays));
% c.Ticks = cTicks;
% c.TickDirection = 'out';
% c.TickLabels = cellstr(datestr(uniqueDays, 'dd-mmm-yyyy'));
% c.Location = 'eastoutside';
% colormap(CM)
% 
% %% Figure 11: SA Size Distributions
% figure(11), clf
% hold on
% for i = 1:size(dV_avg,1)
%     semilogx(Dp, dV_avg(i,:), 'color', CM(i,:))
% end
% 
% title({sprintf('%s Mean Volume Size Distributions', char(interval))})
% xlabel('Diameter [\mum]', 'FontSize', fs) % set xlabel
% ylabel('Mean dV/dlogD_p [\mum^{3} cm^{-3}]', 'FontSize', fs) % set ylabel
% set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
% set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
% set(gca, 'XScale', 'log')
% xlim([min(Dp) max(Dp)])
% box on
% 
% % set colorbar properties
% c = colorbar;
% cLimits = clim;
% validTimes = t(~isnat(t));
% uniqueDays = unique(dateshift(validTimes, 'start', 'day'));
% cTicks = linspace(cLimits(1), cLimits(2), length(uniqueDays));
% c.Ticks = cTicks;
% c.TickDirection = 'out';
% c.TickLabels = cellstr(datestr(uniqueDays, 'dd-mmm-yyyy'));
% c.Location = 'eastoutside';
% colormap(CM)
% 
% %% Figure 12: Concentration contour plot
% figure(12), clf
% fig = tiledlayout(2,1);
% fig.TileSpacing = 'tight';
% fig.Title.String = ' ';
% 
% % Enter figure data
% nexttile(1)
% colormap(turbo)
% 
% imagesc(t_first, Dp, dSA_avg');
% hold on
% 
% axis('xy')
% ylabel('Optical Diameter [\mum]', 'FontSize', fs) % set ylabel
% set(gca, 'YScale', 'log')
% ylim([min(Dp) max(Dp)])
% c = colorbar;
% c.Location = 'northoutside';
% c.TickDirection = 'out';
% 
% ax = gca;
% ax.ColorScale = 'linear';
% ax.FontSize = fs;
% ax.TickDir = 'out';
% 
% c.Title.String = 'dSA/dlogD_p [\mum^2 cm^{-3}]';
% c.Title.FontSize = fs;
% ax.CLim = [0 max(SA)*1.2];
% xlim('tight')
% 
% nexttile(2)
% plot(t_first, SA, Marker='none', ...
%     MarkerEdgeColor='#1a1a1a', MarkerFaceColor='#1a1a1a', ...
%     MarkerSize=ms, Color='#1a1a1a', LineWidth=lw, LineStyle='-')
% set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
% xlim('tight')
% ylim([0 max(SA)*1.2])
% ylabel('SA [\mum^2 cm^{-3}]', 'FontSize', fs) % set ylabel
% set(gca, 'YScale', 'linear')
% 
% annotation('textbox', ...
%     'String', {sprintf('%s Averaging Window', char(interval))}, ...
%     'BackgroundColor', 'none', 'Position', [0.135 0.33 0.1 0.1], ...
%     'FontSize', fs, 'HorizontalAlignment', 'left', ...
%     'EdgeColor', 'none')
% 
% set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
% 
% %% Figure 13: Concentration contour plot
% figure(13), clf
% fig = tiledlayout(2,1);
% fig.TileSpacing = 'tight';
% fig.Title.String = ' ';
% 
% % Enter figure data
% nexttile(1)
% colormap(turbo)
% 
% imagesc(t_first, Dp, dV_avg');
% hold on
% 
% axis('xy')
% ylabel('Optical Diameter [\mum]', 'FontSize', fs) % set ylabel
% set(gca, 'YScale', 'log')
% ylim([min(Dp) max(Dp)])
% c = colorbar;
% c.Location = 'northoutside';
% c.TickDirection = 'out';
% 
% ax = gca;
% ax.ColorScale = 'linear';
% ax.FontSize = fs;
% ax.TickDir = 'out';
% 
% c.Title.String = 'dV/dlogD_p [\mum^3 cm^{-3}]';
% c.Title.FontSize = fs;
% 
% ax.CLim = [0 max(V)*1.2];
% xlim('tight')
% 
% nexttile(2)
% plot(t_first, V, Marker='none', ...
%     MarkerEdgeColor='#1a1a1a', MarkerFaceColor='#1a1a1a', ...
%     MarkerSize=ms, Color='#1a1a1a', LineWidth=lw, LineStyle='-')
% set(gca,'FontSize',fs,'TickDir','out') % set figure color to white, tick dir out
% xlim('tight')
% ylim([0 max(V)*1.2])
% ylabel('V [\mum^3 cm^{-3}]', 'FontSize', fs) % set ylabel
% set(gca, 'YScale', 'linear')
% 
% annotation('textbox', ...
%     'String', {sprintf('%s Averaging Window', char(interval))}, ...
%     'BackgroundColor', 'none', 'Position', [0.135 0.33 0.1 0.1], ...
%     'FontSize', fs, 'HorizontalAlignment', 'left', ...
%     'EdgeColor', 'none')
% 
% set(gcf,'Position',[50 50 1000 800],'Color','w') % set standard figure size
% 
% %% ws, wd
% % plot basic windrose of datafile
% % function path: C:/users/justi/AppData/Roaming/MathWorks/'MATLAB
% % Add-Ons'/Collections/'Wind Rose'
% 
% 
% % WindRose(wd, ws, 'nSpeeds', 5, 'LabLegend', 'Wind Speed [mph]')


%% Save Data  
distribution(1).name = 'MODULAIR';
distribution(1).serial_no = serial_no;
distribution(1).D = Dp; % Units: nm
distribution(1).dN = dN;
distribution(1).N = N;
distribution(1).T = T;
distribution(1).RH = RH;
distribution(1).last_update = last_update;
distribution(1).t = t;
distribution(1).pm1 = pm1;
distribution(1).pm2_5 = pm2_5;
distribution(1).pm10 = pm10;
distribution(1).co = co;
distribution(1).no = no;
distribution(1).no2 = no2;
distribution(1).co2 = co2;
distribution(1).o3 = o3;
distribution(1).ws = ws;
distribution(1).wd = wd;

% % Averaged data
% distribution(1).average_window = interval;
% distribution(1).dSA_avg = dSA_avg;
% distribution(1).SA = SA;
% distribution(1).dV_avg = dV_avg;
% distribution(1).V = V;
% distribution(1).t_first = t_first;
% distribution(1).N_avg = N_avg;
% distribution(1).dN_avg = dN_avg;
% distribution(1).T_avg = T_avg;
% distribution(1).RH_avg = RH_avg;
% distribution(1).pm1_avg = pm1_avg;
% distribution(1).pm2_5_avg = pm2_5_avg;
% distribution(1).pm10_avg = pm10_avg;
% distribution(1).co_avg = co_avg;
% distribution(1).no_avg = no_avg;
% distribution(1).no2_avg = no2_avg;
% distribution(1).co2_avg = co2_avg;
% distribution(1).o3_avg = o3_avg;
% distribution(1).ws_avg = ws_avg;
% distribution(1).wd_avg = wd_avg;

%% Save data files
cd C:/Users/justi/OneDrive/Documents/0_UCSD/Research/Data/2025/2025_modulair_mat/
% save(sprintf('%s.mat', modulairDataName), 'distribution')

end