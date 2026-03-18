%%% smps_3938_export
% Purpose: Extract variables from Scanning Mobility Particle Sizer (SMPS)
% exported data from AIM Version 11.3.0. 
% Author: Justin Hamlin
% Date: 20240908

%%% Notes:
    % T_a will only report values when data is collected with TSI RHT probe
        % connected to the SMPS
    % RH_a will only report values when data is collected with TSI RHT probe
        % connected to the SMPS

function [Dp, dNdlog10Dp, numScans, scanNo, N, Dg, RH_a, T_a, T_sh, t, ...
    last_update] = smps_3938_export(file)


% open file and find location of variable names line
fid = fopen(file);
C = textscan(fid, '%s %*[^\n]', 'Delimiter', ',');
fclose(fid);
col1 = string(C{1});
varLine = find(col1 == "Scan Number", 1, 'first');

opts = detectImportOptions(file);
opts.VariableNamesLine = varLine;

opts = setvaropts(opts, "Var2", "InputFormat", "dd/MM/uuuu HH:mm:ss");
opts.DataLines = [varLine+1 Inf];
opts.VariableNamingRule = 'preserve';
A = readtable(file, opts);


    
% Extract variables
Dp = A.Properties.VariableNames(39:end);
Dp = str2double(string(Dp));
dNdlog10Dp = table2array(A(1:end, 39:end));
[numScans, ~] = size(dNdlog10Dp);
scanNo = table2array(A(1:end,1));
N = table2array(A(1:end, 36));
Dg = table2array(A(1:end, 33));
T_sh = table2array(A(1:end, 13));
t = table2array(A(1:end, 2));
RH_a = table2array(A(1:end, 37));
T_a = table2array(A(1:end, 38));

% conditional loop to input NaN if no RHT was logged
if string(A{1, 37}) == "N/A" && string(A{1, 38}) == "N/A"
    for i = 1:numScans
        RH_a{i,1} = NaN;
        T_a{i,1} = NaN;
    end
else
    RH_a = table2array(A(1:end, 37));
    T_a = table2array(A(1:end, 38));
end


% log last update
last_update = datetime('now');

end