%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = {... 
  'notIndexed',...
  'notIndexed',...
  'notIndexed',...
  'notIndexed',...
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


% F = halfQuadraticFilter;
% F.alpha = 0.01;
% F.eps = 0.001;
% ebsd_nr = smooth(ebsd('indexed'),F,'fill',grains);



%% calc grains
[grains, ebsd_nr.grainId, ebsd_nr.mis2mean] = calcGrains(ebsd_nr,ebsd_nr(grains(grains.grainSize<=20)),'angle',8*degree)

[counts, pairs] = grains('c').neighbors

gB = [grains.boundary grains.innerBoundary] ;
gB_Chr = ebsd_nr('c').calcGrains('angle',8*degree,'unitCell');

%% map

figure
[~,mP]= plot(grains('c'),grains('c').neighbors,'colormap', parula)
hold on
plot(gB_Chr.boundary,'linewidth',0.7);
mtexColorbar
%CLim(gcm,[0 10])
mP.micronBar.visible = 'off'
hold off
