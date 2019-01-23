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
fname = [pname '\UG2_11 LAM_1_NR.ctf'];


%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');


%compute grain boundaires
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',2*degree);

gB = [grains.boundary grains.innerBoundary] ;
gB_ChrChr = gB('c','c');

cond2 = gB_ChrChr.misorientation.angle/degree >2 & gB_ChrChr.misorientation.angle/degree <5;
cond3 = gB_ChrChr.misorientation.angle/degree >5 & gB_ChrChr.misorientation.angle/degree <8;
cond4 = gB_ChrChr.misorientation.angle/degree >8 & gB_ChrChr.misorientation.angle/degree <10;
cond5 = gB_ChrChr.misorientation.angle/degree >10

col = {[1 0 0] [0 1 0] [0 0 1] [1 0.3 1] [0.5 1 0]}


hold on
plot(ebsd, ebsd.bc);
colormap gray
hold on
plot(gB_ChrChr(cond3),'lineColor',[0 0 1],'linewidth',2);
hold on 
plot(gB_ChrChr(cond4),'lineColor',[1 0.3 1],'linewidth',2);
hold on
plot(gB_ChrChr(cond5),'lineColor','black','linewidth',2);
hold on
plot(grains('c').innerBoundary,'lineColor',[1 0 0],'linewidth',2);
% legend('5-8','8-10','>10','<5','Location','northwest')
hold off