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
pname = 'C:\Users\zv211\Documents\Bushveld\Critical Zone\UG\EBSD\ctf';

% which files to be imported
fname = [pname '\UG2_11 LAM_1_NR.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');


%%
oM = ipdfHSVOrientationMapping(ebsd('Chromite'));
oM.inversePoleFigureDirection = xvector;

% compute the colors again
color = oM.orientation2color(ebsd('Chromite').orientations);

%compute grain boundaires
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',10*degree);

gB = grains.boundary;
gB_ChrChr = gB('Chromite','Chromite');

%% Chr mis-Axis 60 CrystCoordinates

CS_Chromite = ebsd('Chromite').CS
cond1 = gB_ChrChr.misorientation.angle/degree >55 & gB_ChrChr.misorientation.angle/degree <61;

ori = ebsd(gB_ChrChr(cond1).ebsdId).orientations
ChrChr_ax = axis(ori(:,1),ori(:,2));

ChrChr_ax_CC = gB_ChrChr.misorientation.axis;

figure
plotAxisDistribution(gB_ChrChr(cond1).misorientation,'DisplayName','55-61 degrees', 'markerSize', 2);
legend('show','Location','northwest');
figure
plotAxisDistribution(gB_ChrChr.misorientation,'DisplayName','55-61 degrees-contour','contourf');
mtexColorbar('title','mrd');
legend('show','Location','northwest');
