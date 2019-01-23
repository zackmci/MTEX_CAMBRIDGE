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
fname = [pname '\UG2_11 LAM_1_NR.ctf'];

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
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',10*degree);

gB = grains.boundary;
gB_ChrChr = gB('Chromite','Chromite');

%% Chr mis-Axis 10-20 CrystCoordinates

CS_Chromite = ebsd('Chromite').CS
cond1 = gB_ChrChr.misorientation.angle/degree >10 & gB_ChrChr.misorientation.angle/degree <20;

ori = ebsd(gB_ChrChr(cond1).ebsdId).orientations
ChrChr_ax = axis(ori(:,1),ori(:,2));

ChrChr_ax_CC = gB_ChrChr.misorientation.axis;

figure
plotAxisDistribution(gB_ChrChr(cond1).misorientation,'DisplayName','10-20 degrees', 'markerSize', 2);
legend('show','Location','northwest');
figure
plotAxisDistribution(gB_ChrChr.misorientation,'DisplayName','Chromite-Chromite','contourf');
mtexColorbar('title','mrd');
legend('show','Location','northwest');
%% Misorientation axis 20-30
cond2 = gB_ChrChr.misorientation.angle/degree >20 & gB_ChrChr.misorientation.angle/degree <30;

ori2 = ebsd(gB_ChrChr(cond2).ebsdId).orientations
ChrChr_ax2 = axis(ori2(:,1),ori2(:,2));
figure
plotAxisDistribution(gB_ChrChr(cond2).misorientation,'DisplayName','20-30 degrees', 'markerSize', 2);
legend('show','Location','northwest');
figure
plotAxisDistribution(gB_ChrChr(cond2).misorientation,'DisplayName','Chromite-Chromite','contourf');
mtexColorbar('title','mrd')
legend('show','Location','northwest');

%% Misorientation axis 30-40
cond3 = gB_ChrChr.misorientation.angle/degree >30 & gB_ChrChr.misorientation.angle/degree <40;

ori3 = ebsd(gB_ChrChr(cond3).ebsdId).orientations
ChrChr_ax2 = axis(ori3(:,1),ori3(:,2));
figure
plotAxisDistribution(gB_ChrChr(cond3).misorientation,'DisplayName','30-40 degrees', 'markerSize', 2);
legend('show','Location','northwest');
figure
plotAxisDistribution(gB_ChrChr(cond3).misorientation,'DisplayName','Chromite-Chromite','contourf');
mtexColorbar('title','mrd')
legend('show','Location','northwest');

%% Misorientation axis 40-50
cond4 = gB_ChrChr.misorientation.angle/degree >40 & gB_ChrChr.misorientation.angle/degree <50;

ori4 = ebsd(gB_ChrChr(cond4).ebsdId).orientations
ChrChr_ax4 = axis(ori4(:,1),ori4(:,2));
figure
plotAxisDistribution(gB_ChrChr(cond3).misorientation,'DisplayName','40-50 degrees', 'markerSize', 2);
legend('show','Location','northwest');
figure
plotAxisDistribution(gB_ChrChr(cond3).misorientation,'DisplayName','Chromite-Chromite','contourf');
mtexColorbar('title','mrd')
legend('show','Location','northwest');

%% Misorientation axis 50-70
cond4 = gB_ChrChr.misorientation.angle/degree >50 & gB_ChrChr.misorientation.angle/degree <70;

ori4 = ebsd(gB_ChrChr(cond4).ebsdId).orientations
ChrChr_ax2 = axis(ori4(:,1),ori4(:,2));
figure
plotAxisDistribution(gB_ChrChr(cond4).misorientation,'DisplayName','50-70 degrees', 'markerSize', 2);
legend('show','Location','northwest');
figure
plotAxisDistribution(gB_ChrChr(cond4).misorientation,'DisplayName','Chromite-Chromite','contourf');
mtexColorbar('title','mrd')
legend('show','Location','northwest');