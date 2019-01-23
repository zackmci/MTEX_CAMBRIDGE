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
fname = [pname '\UG2_8 LAM_NR_v2.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');

%%
oM = ipdfHSVOrientationMapping(ebsd('Enstatite  Opx AV77'));
oM.inversePoleFigureDirection = xvector;

% compute the colors again
color = oM.orientation2color(ebsd('Enstatite  Opx AV77').orientations);

%compute grain boundaires
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',5*degree);

gB = grains.boundary;
gB_OPxOPx = gB('Enstatite  Opx AV77','Enstatite  Opx AV77');

%plotting

plot(ebsd, ebsd.bc);
colormap gray
hold on
plot(ebsd('Enstatite  Opx AV77'),color, 'FaceAlpha', 0.7)
hold on
plot(gB_OPxOPx);
hold off

%%
cs = loadCIF(1548549);

h=[Miller(1,0,0,cs) Miller(1,1,0,cs) Miller(0,1,0,cs) Miller(2,0,1,cs)];
%h=[Miller(1,2,3,cs) Miller(1,0,0,cs)]


cS=crystalShape(h,1.1);
plot(cS);

%% vary habitus and colorize different planes
% logical indexing can be done by plane normals
cS=crystalShape(h,1.2)
plot(cS(vector3d(symmetrise(Miller(1,0,0,cs)))),'FaceColor','r')
hold on
plot(cS(vector3d(symmetrise(Miller(1,1,0,cs)))),'FaceColor','b')
hold on
plot(cS(vector3d(symmetrise(Miller(0,1,0,cs)))),'FaceColor','g')
hold on
plot(cS(vector3d(symmetrise(Miller(2,0,1,cs)))),'FaceColor','y')
hold off

%% plot a grain map
plot(grains('Enstatite  Opx AV77'),grains('Enstatite  Opx AV77').meanOrientation)
% and on top for each large grain a crystal shape
hold on
plot(grains('Enstatite  Opx AV77'),0.7*cS)
hold off