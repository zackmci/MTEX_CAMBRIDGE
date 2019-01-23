clear all
close all

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('12/m1', [9.746 8.99 5.251], [90,105.63,90]*degree, 'X||a*', 'Y||b*', 'Z||c', 'mineral', 'Diopside   CaMgSi2O6', 'color', 'light blue'),...
  crystalSymmetry('-1', [8.1797 12.8748 14.1721], [93.13,115.89,91.24]*degree, 'X||a*', 'Z||c', 'mineral', 'Anorthite', 'color', 'light green'),...
  crystalSymmetry('mmm', [18.2406 8.8302 5.1852], 'mineral', 'Enstatite  Opx AV77', 'color', 'light red'),...
  crystalSymmetry('m-3m', [8.395 8.395 8.395], 'mineral', 'Magnetite', 'color', 'cyan'),...
  crystalSymmetry('12/m1', [9.8701 18.0584 5.3072], [90,105.2,90]*degree, 'X||a*', 'Y||b*', 'Z||c', 'mineral', 'Hornblende', 'color', 'magenta'),...
  crystalSymmetry('12/m1', [8.56 13 7.17], [90,116,90]*degree, 'X||a*', 'Y||b*', 'Z||c', 'mineral', 'Orthoclase', 'color', 'yellow')};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

%% Specify File Names

% path to files
pname = '/Users/zack/Documents/Famatina/EBSD - Cambridge/FA18-12';

% which files to be imported
fname = [pname '/FA18-12-lam _NR.ctf'];


%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');


%% calc grains
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',8*degree);

gB = [grains.boundary grains.innerBoundary] ;
gB_Pl = ebsd('h').calcGrains('angle',2*degree,'unitCell');


figure
 
% plot(ebsd,ebsd.bc,'Facealpha',0.75)
% colormap gray
[~,mP]= plot(grains('h'),grains('h').aspectRatio,'colormap', parula,'Facealpha',0.75)
hold on
plot(gB_Pl.boundary,'linewidth',0.7);
mtexColorbar
CLim(gcm,[1 5])
mP.micronBar.visible = 'off'
hold off

%% pole figure

Pl_ori = ebsd('h').orientations
Pl_CS = ebsd('h').CS

h = [Miller(1,0,0,'hkl',ebsd('h').CS),Miller(0,1,0,'hkl',ebsd('h').CS),Miller(0,0,1,'uvw',ebsd('h').CS),Miller(1,1,0,'hkl',ebsd('h').CS)];
figure
plotPDF(grains('h').meanOrientation,grains('h').aspectRatio,h,'antipodal','MarkerSize',6)
CLim(gcm,[1 5])
colormap parula
mtexColorbar

