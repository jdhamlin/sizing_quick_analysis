% clear, clc, close all
% cd C:/Users/justi/OneDrive/Documents/0_UCSD/Research/Data/2026/experiments/mart_surfactants/sizing/
% cpcFiles = dir('cpc*.csv');
% 
% file = cpcFiles(1).name;

function [t, N] = cpc_3787_export(file)

fid = fopen(file);
lines = {};

tline = fgetl(fid);
while ischar(tline)
    lines{end+1,1} = tline;   % preserve empty lines as ""
    tline = fgetl(fid);
end
fclose(fid);

% Extract first column (before first comma)
col1 = strings(numel(lines),1);
for i = 1:numel(lines)
    parts = strsplit(lines{i}, ',');
    col1(i) = string(parts{1});   % empty line → ""
end

% Now find the first "Time"
varLine = find(col1 == "Time", 1, 'first');
dateLine = find(col1 == "Start Date", 1, 'first');

% Get the full line from the file
rawLine = lines{dateLine};

% Split by comma
parts = strsplit(rawLine, ',');

% Extract second column (date string)
dateStr = strtrim(parts{2});

% Convert to datetime (optional)
dateVal = datetime(dateStr, 'InputFormat','MM/dd/yyyy');   % adjust format if needed
if year(dateVal) < 2000
    dateVal = dateVal + years(2000);
end

opts = detectImportOptions(file);
opts.VariableNamesLine = varLine;

% opts = setvaropts(opts, "Var2", "InputFormat", "dd/MM/uuuu HH:mm:ss");
opts.DataLines = [varLine+1 Inf];
opts.VariableNamingRule = 'preserve';
A = readtable(file, opts);
A.Time = dateVal + A.Time;

% extract variables 
t = A.Time;
N = A.("Conc (#/cm³)");

end