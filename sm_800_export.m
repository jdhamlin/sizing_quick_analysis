%% SpiderMAGIC_export
% Purpose: Extract variables from inverted Spider-MAGIC .txt files
% Author: Justin Hamlin

function [Dp, dNdlog10Dp, scanNo, N, Dg, version, T, RH, V1, ion_ratio, ...
    last_update, numScans, t, wick_sat, mode] = SpiderMAGIC_export(file)

data = importdata(file);
B = dir(file);

% Extract relevant variables
Dp = data.data(1,:);
dNdlog10Dp = data.data(2:end,:);                    % Size distribution
dNdlog10Dp(isnan(dNdlog10Dp)) = 0;                  % Replace NaN with 0
[numScans,~] = size(dNdlog10Dp);                    % Index # of scans & bins
scanNo = linspace(1,numScans,numScans)';
N = str2double(data.textdata(2:end,3));             % Total counts
Dg = str2double(data.textdata(2:end,4));            % Geometric diameter

%%% Datetime format changed with updated SM GUI, legacy code allowed user
%%% input for GUI version. Commented out since legacy GUI has not been in
%%% use for almost a year. 

% fprintf('Options: 20240322, 20240710 \n');
% version = input('Enter Spider GUI Version (YYYYMMDD): \n');
% if version == 20240322
%     t = datetime(data.textdata(2:end,1));              % Date & time
%     filedate = sscanf(B.name(20:27),'%s');
% elseif version == 20240710
%     t = datetime(data.textdata(2:end,1), 'InputFormat', 'uuuu/MM/dd HH:mm:ss');
%     filedate = sscanf(B.name(21:28),'%s');
% end

version = 20240710;
fprintf('GUI Version set as 20240710.\nUpdate SpiderMAGIC_export.m if incorrect \n');
t = datetime(data.textdata(2:end,1), 'InputFormat', 'uuuu/MM/dd HH:mm:ss');
% t = datetime(data.textdata(2:end,1));              % Date & time

T = str2double(data.textdata(2:end,6));            % Temperature
RH = str2double(data.textdata(2:end,8));           % Relative humidity
V1 = str2double(data.textdata(2:end,17));          % Starting voltage
ion_ratio = str2double(data.textdata(2:end,13));   % Ion mobility ratio (Z+/Z-)
wick_sat = str2double(data.textdata(2:end, 27));   % Wick Saturation percentage
for i = 1:size(dNdlog10Dp, 1)
    if all(dNdlog10Dp(i,:) == 0)
        mode(i,1) = NaN; % Sets value to NaN in the event that no mode is observed
    else
        max_dN = max(dNdlog10Dp(i,:));
        idx = dNdlog10Dp(i,:) == max_dN;

        % take the average Dp if there are multiple dN values that are equal
        mode(i,1) = mean(Dp(idx)); 
        % mode(i,1) = Dp(dNdlog10Dp(i,:) == max(dNdlog10Dp(i,:)));
    end
end
last_update = datetime('now');                  % Log last update

return