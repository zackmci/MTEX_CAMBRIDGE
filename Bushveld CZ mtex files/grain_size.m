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
setMTEXpref('zAxisDirection','outOfPlane');

%% Specify File Names

% path to files
pname = 'C:\Users\zv211\OneDrive - University Of Cambridge\Documents\Bushveld\Critical Zone\UG\EBSD\ctf';

% which files to be imported
fname = [pname '\UG2_8 LAM_NR_v2.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');

%% calc grains
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',10*degree);

gB = [grains.boundary grains.innerBoundary] ;
gB_Pl = gB('e','e');
gbgrains = ebsd('e').calcGrains('angle',2*degree,'unitCell')


figure
[~,mP]= plot(grains('e'),grains('e').aspectRatio,'colormap', pink,'Facealpha',0.75)
CLim(gcm,[1.25 7])
hold on
plot(gbgrains.boundary,'linewidth',1);
hold on
plot(gbgrains.innerBoundary,'lineColor','w','linewidth',1.5);
mtexColorbar
mP.micronBar.visible = 'off'
hold off

%% pole figure

Opx_ori = ebsd('e').orientations
Opx_CS = ebsd('e').CS

h = [Miller(1,0,0,'hkl',ebsd('e').CS),Miller(0,1,0,'hkl',ebsd('e').CS),Miller(0,0,1,'hkl',ebsd('e').CS)];
figure
plotPDF(grains('e').meanOrientation,grains('e').aspectRatio,h,'antipodal','MarkerSize',6)
CLim(gcm,[1.25 7])
colormap pink
mtexColorbar

