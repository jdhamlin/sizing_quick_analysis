function [Dp, dNdlog10Dp, t, N, RH, T, wd, ws, pm1, pm2_5, pm10, co, no, no2, ...
    o3, co2, numScans, last_update, serial_no] = modulair_export(file)

% Bin midpoint diameter 20240718
Dp = [0.405 0.56 0.83 1.15 1.50 2.00 2.65 3.5 4.6 5.85 7.25 9 11 13 15 ...
    17 19 21 23.5 26.5 29.5 32.5 35.5 38.5]; 

dD = [0.11 0.2 0.34 0.3 0.4 0.6 0.7 1 1.2 1.3 1.5 2 2 2 2 2 2 2 3 3 3 3 ...
    3 3];


% multiply by width of bin
% divide by log of bin width

% dlogDp 20240920
dlogDp = [0.118689787 0.156786104 0.180456064 0.113943352 0.116505569 ...
    0.131278915 0.115393419 0.124938737 0.113943352 0.096910013 ...
    0.09017663 0.096910013 0.079181246 0.06694679 0.057991947 ...
    0.051152522 0.045757491 0.041392685 0.055517328 0.049218023 ...
    0.044203662 0.040117223 0.036722807 0.033858267];


data = readtable(file);
serial_no = string(data.sn(1));

% flip data so it reads chronologically
data = flipud(data);
dN = table2array(data(:,7:30));
dNdlog10Dp = dN.*dD./dlogDp;
dN_1 = dN./dlogDp;
% dlogDp = 0.0824;
% dNdlogDp = dN/dlogDp;

% Extract datetime
dateStr = string(data.timestamp_local);
% t = flipud(datetime(dateStr, 'InputFormat', 'uuuu-MM-dd''T''HH:mm:ss''Z'));
t = datetime(dateStr, 'InputFormat', 'uuuu-MM-dd''T''HH:mm:ss''Z');
% t.TimeZone = 'America/Los_Angeles';


% Calculate total number
for i = 1:length(dNdlog10Dp)
    % N(i,1) = flipud(trapz(log10(Dp), dNdlog10Dp(i,:)));
    N(i,1) = trapz(log10(Dp), dNdlog10Dp(i,:));

end


% Extract variables
RH = data.rh;
T = data.temp;
wd = data.wd;
ws = data.ws_scalar;
pm1 = data.pm1;
pm2_5 = data.pm25;
pm10 = data.pm10;
co = data.co;
no = data.no;
no2 = data.no2;
o3 = data.o3;
co2 = data.co2;
numScans = size(data, 1);

% log last update
last_update = datetime('now');  

return