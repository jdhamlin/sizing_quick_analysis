%% sm_800_export.m
% Purpose: Extract variables from inverted Spider-MAGIC .txt files
% Author: Justin Hamlin

function [Dp, dNdlog10Dp, scanNo, N, Dg, version, T, RH, V1, ion_ratio, ...
    last_update, numScans, t, wick_sat] = sm_800_export(file)

data = importdata(file);
B = dir(file);

% Extract relevant variables
Dp = data.data(1,:);
dNdlog10Dp = data.data(2:end,:);                    % Size distribution
dNdlog10Dp(isnan(dNdlog10Dp)) = 0;                  % Replace NaN with 0
[numScans,~] = size(dNdlog10Dp);                    % Index # of scans & bins
scanNo = linspace(1,numScans,numScans)';
N = str2double(data.textdata(2:end,3));             % Total concentration
Dg = str2double(data.textdata(2:end,4));            % Geometric diameter

version = 20240710;
fprintf('GUI Version set as 20240710.\nUpdate sm_800_export.m if incorrect \n');
t = datetime(data.textdata(2:end,1), 'InputFormat', 'uuuu/MM/dd HH:mm:ss');

T = str2double(data.textdata(2:end,6));            % Qsh Temperature
RH = str2double(data.textdata(2:end,8));           % Qsh Relative humidity
V1 = str2double(data.textdata(2:end,17));          % Starting voltage
ion_ratio = str2double(data.textdata(2:end,13));   % Ion mobility ratio (Z+/Z-)
wick_sat = str2double(data.textdata(2:end, 27));   % Wick Saturation percentage
last_update = datetime('now');                     % Log last update

return