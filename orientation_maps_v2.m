%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

%% Specify Crystal and Specimen Symmetries
CS = {... 
  'notIndexed',...
  crystalSymmetry('-3m1', [5.1233 5.1233 13.7602], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Ilmenite', 'color', 'light blue'),...
  crystalSymmetry('m-3m', [8.395 8.395 8.395], 'mineral', 'Magnetite', 'color', 'light green'),...
  crystalSymmetry('-1', [8.1797 12.8748 14.1721], [93.13,115.89,91.24]*degree, 'X||a*', 'Z||c', 'mineral', 'Anorthite', 'color', 'light red')};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');
setMTEXpref('outerPlotSpacing',0); 

% path to files
pname = 'C:\Users\zv211\OneDrive - University Of Cambridge\Documents\Bushveld\Upper Zone\BK3-anorthosites\Mtex files\ctf files';

% which files to be imported
fname = [pname '\BK3-14-8a LAM_NR_v2.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');

%% calc grains

[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',8*degree);

gB = [grains.boundary grains.innerBoundary] ;
gB_Pl = gB('a','a');

%% select grains
figure
plot(grains('Anorthite'),grains('Anorthite').meanOrientation)
%% define subset with a polygon
%you need this next command line if you want to do more than one operation
hold on
poly = selectPolygon
ebsd01 = ebsd(inpolygon(ebsd, poly))

cs = ebsd01('Anorthite').CS;
oM = ipfHSVKey(cs)
color = oM.orientation2color(ebsd01('Anorthite').orientations);


gbgrains = ebsd01('Anorthite').calcGrains('angle',2*degree,'unitCell')

% All-E map

figure
[~,mP]= plot(ebsd01('Anorthite'),ebsd01('Anorthite').orientations, 'FaceAlpha',0.7);
hold on
plot(gbgrains.boundary,'linewidth',2,'FaceAlpha',0.7);
plot(gbgrains.innerBoundary,'lineColor','w','linewidth',2,'FaceAlpha',0.7);
mP.micronBar.visible = 'off'
hold off

%% plot IPF maps

ori = ebsd01('Anorthite').orientations;
om = ipfHSVKey(cs,cs);
col = om.orientation2color(ebsd01('Anorthite').orientations); % here's the nx3 color vector

h = [Miller(1,0,0,'uvw',ebsd01('Anorthite').CS),Miller(0,1,0,'hkl',ebsd01('Anorthite').CS),Miller(0,0,1,'hkl',ebsd01('Anorthite').CS)];
plotPDF(ori,col,h,'antipodal','MarkerSize',8)

% % plot(ebsd(selected_grains),col) 
% h = [Miller(1,0,0,'uvw',ebsd01('Anorthite').CS),Miller(0,1,0,'hkl',ebsd01('Anorthite').CS),Miller(0,0,1,'hkl',ebsd01('Anorthite').CS)];
% plotPDF(ori,ebsd01('Anorthite').mad,h,'antipodal','MarkerSize',4)