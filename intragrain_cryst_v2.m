clear all

%% Specify Crystal and Specimen Symmetries
% crystal symmetry

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

gB = grains.boundary;
gB_AnAn = gB('Anorthite','Anorthite');
cs_pl = ebsd('Anorthite').CS
om = ipfHSVKey(cs_pl,cs_pl);
om.inversePoleFigureDirection = Miller(om.dirMap.whiteCenter,om.CS2);

plot(ebsd, ebsd.bc);
colormap gray
hold on
plot(ebsd('Anorthite'), 'FaceAlpha', 0.7)
hold on
plot(gB_AnAn);
hold off
%% select grains
hold on
poly = selectPolygon
ebsd = ebsd(inpolygon(ebsd, poly))
cs = ebsd('Anorthite').CS;
om = ipfHSVKey(cs,cs);
om.inversePoleFigureDirection = Miller(om.dirMap.whiteCenter,om.CS2); 
color = om.orientation2color(ebsd('Anorthite').orientations);

[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',2*degree);

%% mis profile
ori_pl = ebsd('Anorthite').orientations;

plot(om)
om.maxAngle=10*degree; 

gbgrains = ebsd('Anorthite').calcGrains('angle',2*degree,'unitCell')
col = om.orientation2color(ebsd('Anorthite').mis2mean); % here's the nx3 color vector


%% pole figures 

figure
plotPDF(ori_pl, col, Miller(1,0,0,cs,'uvw'),'lower','markersize',5)
figure
plotPDF(ori_pl, col, Miller(0,1,0,cs,'hkl'),'markersize',5)
figure
plotPDF(ori_pl, col, Miller(0,0,1,cs,'hkl'),'markersize',5)

%% rotation axis

grains=grains('Anorthite')
gB_AnAn=[grains.innerBoundary('Anorthite', 'Anorthite'); grains.boundary('Anorthite', 'Anorthite')];

ori = ebsd(gB_AnAn.ebsdId).orientations;

AnAn_ax = axis(ori(:,1),ori(:,2));

cond= gB_AnAn.misorientation.angle/degree <10 & gB_AnAn.misorientation.angle/degree >2; 
plot(AnAn_ax(cond),'antipodal','markercolor','black','markersize', 4)
