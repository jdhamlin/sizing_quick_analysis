# sizing\_quick\_analysis

scripts to quickly process and visualize data from aerosol sizing instruments

# MATLAB Scripts

*MATLAB version R2023b Update 10 (23.2.0.2859533)*

1. "cs\_calculation.m" - Calculate the condensation sink given aerosol size distribution measurements (D and dN)
2. "sizing\_stats.m" - Calculate key parameters of the size distribution given size distribution measurements (D and dN). Outputs include: 1) mode\_D, 2) N\_nucleation, 3) N\_aitken, 4) N\_accumulation, 5) N\_submicron, 6) N\_supermicron, 7) Dg, 8) sigma\_g
3. "Sizing\_Merge.m" - Merge size distribution data from an electrical mobility spectrometer with an optical particle counter or aerodynamic particle sizer. This version has weighting set for merging SMPS-APS distributions
4. "Sizing\_Merge2.m" - Merge size distribution data from an electrical mobility spectrometer with an optical particle counter or aerodynamic particle sizer. This version has weighting set for merging SM-OPS distributions
5. "modulair\_export.m" - extract variables of interest from modulair .csv file for subsequent analysis
6. "SQA_smps_3938.m" - quickly process data from a Scanning Mobility Particle Sizer model 3938 (TSI Inc.) generates figures and saves data as .mat file for subequent analysis.
7. "smps_3938_export.m" - read in data from a Scanning Mobility Particle Sizer model 3938 (TSI Inc.)





# Python Scripts

*Python version TBD*

