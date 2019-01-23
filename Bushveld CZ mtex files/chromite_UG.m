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
pname = 'C:\Users\zv211\Documents\Bushveld\Critical Zone\UG\EBSD\ctf';

% which files to be imported
fname = [pname '\UG2-5 LAM_NR.ctf'];

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
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',5*degree);

gB = grains.boundary;
gB_ChrChr = gB('Chromite','Chromite');

%plotting

plot(ebsd, ebsd.bc);
colormap gray
hold on
plot(ebsd('Chromite'),color, 'FaceAlpha', 0.7)
hold on
plot(gB_ChrChr);
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
color = oM.orientation2color(ebsd01('Chromite').orientations);

figure
plot(ebsd01, ebsd01.bc)
hold on
plot(ebsd01('Chromite'),color)


% figure
% plot(ebsd,ebsd.prop.mad)
% cb = mtexColorbar % add a colorbar
% cb.Label.String = 'mad' % add a label to the colorbar;

cs = loadCIF(9010816)

h=[Miller(1,1,1,cs) Miller(1,1,0,cs) Miller(1,0,0,cs)]
%h=[Miller(1,2,3,cs) Miller(1,0,0,cs)]


cS=crystalShape(h,2)
plot(cS)

%% vary habitus and colorize different planes
% logical indexing can be done by plane normals
cS=crystalShape(h,1.2)
plot(cS(vector3d(symmetrise(Miller(1,1,1,cs)))),'FaceColor','r')
hold on
plot(cS(vector3d(symmetrise(Miller(1,1,0,cs)))),'FaceColor','b')
hold on
plot(cS(vector3d(symmetrise(Miller(1,0,0,cs)))),'FaceColor','b')
hold off


cS=crystalShape(h,2)
plot(cS(vector3d(symmetrise(Miller(1,1,1,cs)))),'FaceColor','r')
hold on
plot(cS(vector3d(symmetrise(Miller(1,1,0,cs)))),'FaceColor','b')
hold on
plot(cS(vector3d(symmetrise(Miller(1,0,0,cs)))),'FaceColor','b')
hold off


cS=crystalShape(h,15)
plot(cS(vector3d(symmetrise(Miller(1,1,1,cs)))),'FaceColor','r')
hold on
plot(cS(vector3d(symmetrise(Miller(1,1,0,cs)))),'FaceColor','b')
hold on
plot(cS(vector3d(symmetrise(Miller(1,0,0,cs)))),'FaceColor','b')
hold off



%% grain boundaries
[grains,ebsd01.grainId,ebsd01.mis2mean] = calcGrains(ebsd01,'angle',5*degree);

gB = grains.boundary;
gB_ChrChr01 = gB('Chromite','Chromite');

cSGrains = grains('Chromite').meanOrientation * cS * 0.7 * sqrt(grains('Chromite').area);
% plot a grain map
figure
plot(grains('Chromite'),grains('Chromite').meanOrientation)
% now we can plot these crystal shapes at the grain centers
hold on
plot(grains('Chromite').centroid + cSGrains)
hold off

%% Chr mis-Axis-CrystCoordinates

CS_Chromite = ebsd01('Chromite').CS
condition = gB_ChrChr01.misorientation.angle/degree >10;

ori = ebsd01(gB_ChrChr01(condition).ebsdId).orientations
ChrChr_ax = axis(ori(:,1),ori(:,2));

ChrChr_ax_CC = gB_ChrChr01.misorientation.axis;
% oM = ipdfHSVOrientationMapping(ebsd01('Chromite'));
% oM.inversePoleFigureDirection = xvector;

figure
plotAxisDistribution(gB_ChrChr01.misorientation,'DisplayName','Chromite-Chromite', 'markerSize', 8);
legend('show','Location','northwest');
figure
plotAxisDistribution(gB_ChrChr01.misorientation,'DisplayName','Chromite-Chromite','contourf');
legend('show','Location','northwest');
