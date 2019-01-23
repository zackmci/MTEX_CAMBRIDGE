clear all
%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('12/m1', [9.746 8.99 5.251], [90,105.63,90]*degree, 'X||a*', 'Y||b*', 'Z||c', 'mineral', 'Diopside   CaMgSi2O6', 'color', 'light blue'),...
  crystalSymmetry('-3m1', [5.1233 5.1233 13.7602], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Ilmenite', 'color', 'light green'),...
  crystalSymmetry('m-3m', [8.395 8.395 8.395], 'mineral', 'Magnetite', 'color', 'light red'),...
  crystalSymmetry('-1', [8.1797 12.8748 14.1721], [93.13,115.89,91.24]*degree, 'X||a*', 'Z||c', 'mineral', 'Anorthite', 'color', 'cyan'),...
  crystalSymmetry('mmm', [18.2406 8.8302 5.1852], 'mineral', 'Enstatite  Opx AV77', 'color', 'magenta')};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

%% Specify File Names

% path to files
pname = 'C:\Users\zv211\OneDrive - University Of Cambridge\Documents\Bushveld\Main Zone\EBSD\SL12-1395_v2';

% which files to be imported
fname = [pname '\SL12-1395_v2 LAM_NR-largeimport_wizard( grains ppg.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');


% Estimate ODFs of corrected EBSD measurements
%***********************************************************************
% N.B. You cannot plot pole figures densities without
%      creating ODF first in MTEX

%odf_cpx = calcODF(ebsd('Diopside').orientations, 'halfwidth',10*degree);
odf_An = calcODF(ebsd('Anorthite').orientations, 'halfwidth',10*degree);

mdf_An = calcMDF(odf_An)
%% Calculate Texture indices of ODF and MDF
% ODF (F2 or J-index) - measure of ODF strength
T2 = textureindex(odf_An)
% MDF (M2) - measure of MDF strength
M2 = textureindex(mdf_An)
% Entropy of ODF - measure of ODF dispersion
S = entropy(odf_An)
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
[density_MDF,omega] = calcAngleDistribution(mdf_An,'resolution',1*degree);
% normalize by sum of all densities
density_MDF = density_MDF/sum(density_MDF);
%% M_index of Skemer
M_Index = (sum((abs(density_MDF-density_uniform))/2));