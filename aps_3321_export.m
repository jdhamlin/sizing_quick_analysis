%%% aps_3321_export
% Purpose: Extract variables from row exported dW/dlogDp data from TSI
% Model 3321 Aerodynamic Particle Sizer
% Author: Justin Hamlin

function [Dp, dNdlog10Dp, numScans, scanNo, N, Dg, sigma_g, t, last_update] = ...
    aps_3321_export(file)

% open file and scan for row containing Sample #
fid = fopen(file); 
C = textscan(fid, '%s %*[^\n]', 'Delimiter', ',');
fclose(fid);
col1 = string(C{1});
varLine = find(col1 == "Sample #", 1, 'first');

opts = detectImportOptions(file);
opts.VariableNamesLine = varLine;
opts.Delimiter = ',';
opts = setvaropts(opts, "Var2", "InputFormat", "MM/dd/uu");

dataLines = varLine + 1;
opts.DataLines = [dataLines Inf];
opts.VariableNamingRule = 'preserve';
data = readtable(file,opts);

% check variable type before preceding 
varTypes = data.Properties.VariableTypes;
if all(varTypes == "cell")
    varsAreCells = 1;
else
    varsAreCells = 0;
end

% Extract variables
Dp = str2double(string(data.Properties.VariableNames(6:56)));
dNdlog10Dp = table2array(data(1:end,6:56));
[numScans, ~] = size(dNdlog10Dp);
scanNo = data.("Sample #");
N = data.("Total Conc.");
N = str2double(extractBefore(string(N), '('));
Dg = data.("Geo. Mean(µm)");
sigma_g = data.("Geo. Std. Dev.");
date = data.Date;
time = data.("Start Time");

if varsAreCells == 1
    dNdlog10Dp = str2double(string(dNdlog10Dp));
    scanNo = str2double(string(scanNo));
    Dg = str2double(string(Dg));
    sigma_g = str2double(string(sigma_g));
    date = string(date);
    time = string(time);
    dt = string(date + " " + time);
    t = datetime(dt, 'InputFormat', 'MM/dd/yy HH:mm:ss');
else
    t = date + time;
    t = datetime(t, 'Format','MM/dd/yy HH:mm:ss');
end

% log last update
last_update = datetime('now');

end