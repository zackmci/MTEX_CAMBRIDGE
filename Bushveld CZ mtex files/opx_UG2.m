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


% %% histogram
% 
% gB_ChrChr_miso = gB_ChrChr.misorientation;
% gB_ChrChr_misoAngle = gB_ChrChr_miso.angle./degree;
% plotAngleDistribution(gB_ChrChr.misorientation,5:2:65,'DisplayName','Chromite-Chromite');
% hist(gB_ChrChr_misoAngle,5:2:65);

%% define subset with a polygon
%you need this next command line if you want to do more than one operation
hold on
poly = selectPolygon
ebsd01 = ebsd(inpolygon(ebsd, poly))
color = oM.orientation2color(ebsd01('Enstatite  Opx AV77').orientations);

figure
plot(ebsd01, ebsd01.bc)
hold on
plot(ebsd01('Enstatite  Opx AV77'),color)


figure
% plot(ebsd,ebsd.prop.mad)
% cb = mtexColorbar % add a colorbar
% cb.Label.String = 'mad' % add a label to the colorbar;

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


%% grain boundaries
[grains,ebsd01.grainId,ebsd01.mis2mean] = calcGrains(ebsd01,'angle',5*degree);

gB = grains.boundary;
gB_OpxOpx01 = gB('Enstatite  Opx AV77','Enstatite  Opx AV77');

cSGrains = grains('Enstatite  Opx AV77').meanOrientation * cS * 0.7 * sqrt(grains('Enstatite  Opx AV77').area);
% plot a grain map
figure
plot(ebsd, ebsd.bc);
colormap gray
hold on
plot(grains('Enstatite  Opx AV77'),grains('Enstatite  Opx AV77').meanOrientation)
% now we can plot these crystal shapes at the grain centers
hold on
plot(grains('Enstatite  Opx AV77').centroid + cSGrains)
hold off

% %% Chr mis-Axis-CrystCoordinates
% 
% CS_Opx = ebsd01('Enstatite  Opx AV77').CS
% condition = gB_OpxOpx01.misorientation.angle/degree >10;
% 
% ori = ebsd01(gB_OpxOpx01(condition).ebsdId).orientations
% Opx_ax = axis(ori(:,1),ori(:,2));
% 
% OPxOPx_ax_CC = gB_OpxOpx01.misorientation.axis;
% % oM = ipdfHSVOrientationMapping(ebsd01('Chromite'));
% % oM.inversePoleFigureDirection = xvector;
% 
% figure
% plotAxisDistribution(gB_OpxOpx01.misorientation,'DisplayName','OPx-OPx', 'markerSize', 8);
% legend('show','Location','northwest');
% figure
% plotAxisDistribution(gB_OpxOpx01.misorientation,'DisplayName','OPx-OPx','contourf');
% legend('show','Location','northwest');
