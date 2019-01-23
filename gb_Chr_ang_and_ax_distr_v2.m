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
  crystalSymmetry('mmm', [18.2406 8.8302 5.1852], 'mineral', 'Enstatite', 'color', 'light green'),...
  crystalSymmetry('12/m1', [9.746 8.99 5.251], [90,105.63,90]*degree, 'X||a*', 'Y||b', 'Z||c', 'mineral', 'Diopside', 'color', 'light red'),...
  crystalSymmetry('m-3m', [8.378 8.378 8.378], 'mineral', 'Chromite', 'color', 'cyan')};

% plotting convention
setMTEXpref('xAxisDirection','south');
setMTEXpref('zAxisDirection','outOfPlane');

%% Specify File Names

% path to files
pname = '/Users/giulioisacco/Dropbox (Cambridge University)/Cambridge/EBSD/Zoja/20180524_chromite';

% which files to be imported
fname = [pname '/UG2_11_LAM_1_NR_v2.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',2*degree);

%% grain boundaries
gB = grains.boundary;
gB_ChrChr = gB('Chromite','Chromite');
% figure
% plot(gB_ChrChr,gB_ChrChr.misorientation.angle./degree,'linewidth',2)
% hold on
% mtexColorbar
% set(gcf,'name','grain boundaries chromite')
% hold off

%% Misorientation

gB_ChrChr_miso = gB_ChrChr.misorientation;
gB_ChrChr_misoAngle = gB_ChrChr_miso.angle./degree;
gB_ChrChr_misoAxes =  axis(gB_ChrChr_miso)


plotAngleDistribution(gB_ChrChr.misorientation,5:2:90,'DisplayName','Chromite-Chromite')
legend('show','Location','northwest')


hist(gB_ChrChr_misoAngle,5:2:65)


%Only consider the gB_ChrChr_miso with angle < 62 degrees
gB_ChrChr_misolessthan10 = gB_ChrChr_miso(angle(gB_ChrChr_miso) < 10*degree);
%Only consider the gB_ChrChr_miso with angle between 58 and 62
gB_ChrChr_miso2_10 = gB_ChrChr_misolessthan10(angle(gB_ChrChr_misolessthan10) > 2*degree);
gB_ChrChr_miso2_10Axes =  axis(gB_ChrChr_miso2_10)
%Plot the IPF for the gB_ChrChr_miso with angle between 58 and 62
%plot(gB_ChrChr_miso58_62Axes,'antipodal','MarkerSize',1)
mtexFig = newMtexFigure;
% plotAxisDistribution(gB_ChrChr_miso58_62,'contourf',mtexFig.gca)
 plot(gB_ChrChr_miso2_10Axes,'antipodal','contourf')
% plot(gB_ChrChr_miso58_62Axes,'complete')


