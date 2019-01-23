%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('-1', [8.1732 12.8583 14.1703], [93.17,115.95,91.22]*degree, 'X||a*', 'Z||c', 'mineral', 'Anorthite', 'color', 'light blue'),...
  crystalSymmetry('mmm', [18.2406 8.8302 5.1852], 'mineral', 'Enstatite  Opx AV77', 'color', 'light green'),...
  crystalSymmetry('12/m1', [9.746 8.99 5.251], [90,105.63,90]*degree, 'X||a*', 'Y||b*', 'Z||c', 'mineral', 'Diopside   CaMgSi2O6', 'color', 'light red'),...
  crystalSymmetry('m-3m', [8.378 8.378 8.378], 'mineral', 'Chromite', 'color', 'cyan')};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

%% Specify File Names

% path to files
pname = 'C:\Users\zv211\OneDrive - University Of Cambridge\Documents\Bushveld\Critical Zone\UG\EBSD\ctf';

% which files to be imported
fname = [pname '\UG2_8 LAM_NR_v2-opx_ppg.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');

%% orientations
Opx_ori = ebsd('Enstatite  Opx AV77').orientations
OPx_CS = ebsd('Enstatite  Opx AV77').CS


%%

Opx_odf = calcODF(Opx_ori,'halfwidth',10.0*degree);

mdf_OPx = calcMDF(Opx_odf);

T2 = textureindex(Opx_odf);
M2 = textureindex(mdf_OPx);

% Entropy of ODF - measure of ODF dispersion
S = entropy(Opx_odf)
%% Misoreintation angle distribution for a uniform distribution
% distribution (d) for crystal symmetry defined by 'CS'
% default 300 points
CS_triclinic = crystalSymmetry('-1');
% Misorientation angle distribution for Laue class mmm (Orthorhombic)
[density_uniform,omega] = calcAngleDistribution(CS_triclinic);
density_uniform = density_uniform/sum(density_uniform);
% Convert to degrees
omega_degree = omega./degree;
%% angle distribution of MDF for olivine data
% default 300 points
[density_MDF,omega] = calcAngleDistribution(mdf_OPx,'resolution',1*degree);
% normalize by sum of all densities
density_MDF = density_MDF/sum(density_MDF);
%% M_index of Skemer
M_Index = (sum((abs(density_MDF-density_uniform))/2));