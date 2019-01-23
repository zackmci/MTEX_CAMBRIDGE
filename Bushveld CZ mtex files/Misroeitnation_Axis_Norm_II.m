%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('-1', [8.1732 12.8583 14.1703], [93.172,115.952,91.222]*degree, 'X||a*', 'Z||c', 'mineral', 'Anorthite', 'color', 'light blue'),...
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
fname = [pname '\UG2-5 LAM_NR.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');

CS_Chr = ebsd('Chromite').CS
mori_Chr = calcMisorientation(ebsd('Chromite'));
%%
oM = ipdfHSVOrientationMapping(ebsd('Chromite'));
oM.inversePoleFigureDirection = xvector;

% compute the colors again
color = oM.orientation2color(ebsd('Chromite').orientations);

%compute grain boundaires
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',8*degree);

gB = grains.boundary;
gB_ChrChr = gB('Chromite','Chromite');

%% normalise misoirnetations

mdf_Chr_Chr =calcMDF(gB_ChrChr.misorientation)

axisDist_measured = calcAxisDistribution(mdf_Chr_Chr) 
nextAxis
figure
plot(axisDist_measured)
mtexTitle('measured')

axisDist_uniform = calcAxisDistribution(mdf_Chr_Chr.CS)
nextAxis
figure
plot(axisDist_uniform)
mtexTitle('uniform')
nextAxis

axisDist_normalised = axisDist_measured./axisDist_uniform
figure
plot(axisDist_normalised)
mtexTitle('normalized')

