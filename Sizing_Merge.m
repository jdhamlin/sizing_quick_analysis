%% Merge sub- and super-micron Data
% Raymond Leibensperger III (UCSD/SIO)
% Based on code from Dr. Grant B. Deane (UCSD/SIO)
% Updated by Justin Hamlin
% April 28, 2025

function [D_p, dNdlogD_p] = Sizing_Merge(D_m, dNdlogD_m, D_a, dNdlogD_a)
% D_m is an array of the mobility diameter (nm) given by the Scanning Mobility Particle
% Sizer (SMPS)
% dNdlogD_m is an array of the number concentration (# cm^{-3}) given by
% the SMPS
% D_a is an array of the mobility diameter (μm) given by the
% Aerodynamic Particle Sizer (APS), after  a correction based on density as
% a function of relative humidity.
% dNdlogD_a is an array of the number concentration (# cm^{-3}) given by
% the APS

%% Constants
um_nm = 1e3; % Convert micrometers to nanometers
nInterp = 12; % The number of interpolation points
ScalingPower = 2; % 1 = unbiased scaling, 2 = preferential SMPS scaling, 0.5 = preferential APS scaling

%%
% comment out following line if both diameters are in micrometers
% D_a = D_a*um_nm; % Convert aerodynamic diameter into nanometers
InitialIndex = find(D_m > D_a(1),1,"first"); 
% Locate the first SMPS diameter within the overlap region
FinalIndex = find(D_a < D_m(end),1,"last");
% Locate the last APS diameter within the overlap region
D_Interp = logspace(log10(D_a(1)), log10(D_m(end)), nInterp); 
% Create a new array of diameters for the overlapping region
dNdlogD_m_Interp = interp1(D_m,dNdlogD_m,D_Interp,'linear','extrap');
% Create new array of SMPS number concentration (# cm^{-3}) in overlap
% region
dNdlogD_a_Interp = interp1(D_a,dNdlogD_a,D_Interp,'linear','extrap');
% Create new array of APS number concentration (# cm^{-3}) in overlap
% region. Linear extrapolation resolves issues with 'NaN' values being
% deposited into the interpolated dNdlogD_a.
Alpha = (D_Interp - D_Interp(1))/(D_Interp(end)-D_Interp(1));
% Create variable that scales from 0 at the beginning of the overlap region
% to 1 at the end of the overlap region
Alpha = Alpha.^ScalingPower;
% Weight Alpha as desired
dNdlogD_Interp = Alpha.*dNdlogD_a_Interp + (1 - Alpha).*dNdlogD_m_Interp;
% Create new number concentration in overlap region
D_p = [D_m(1:InitialIndex-1),D_Interp,D_a(FinalIndex+1:end)];
% Create new array of physical diameter (nm) spanning both intial
% distributions
dNdlogD_p = [dNdlogD_m(1:InitialIndex-1),dNdlogD_Interp,dNdlogD_a(FinalIndex+1:end)];
% Create new array of number concentration (# cm^{-3}) spanning both
% initial distributions
return
