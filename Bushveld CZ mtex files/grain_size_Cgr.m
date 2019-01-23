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


% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');

%% calc grains
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',8*degree);

gB = [grains.boundary grains.innerBoundary] ;
gB_Chr = ebsd('c').calcGrains('angle',2*degree,'unitCell');


figure
[~,mP]= plot(grains('c'),grains('c').equivalentRadius,'colormap', parula)
hold on
plot(gB_Chr.boundary,'linewidth',0.7);
mtexColorbar
CLim(gcm,[50 500])
mP.micronBar.visible = 'off'
hold off

%% pole figure

Chr_ori = ebsd('c').orientations
Chr_CS = ebsd('c').CS

h = [Miller(1,0,0,'hkl',ebsd('c').CS),Miller(1,1,0,'hkl',ebsd('c').CS),Miller(1,1,1,'hkl',ebsd('c').CS)];
figure
plotPDF(grains('c').meanOrientation,grains('c').equivalentRadius,h,'antipodal','aa','MarkerSize',6)

colormap parula
mtexColorbar

