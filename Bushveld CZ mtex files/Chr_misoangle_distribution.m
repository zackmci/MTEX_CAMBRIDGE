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
pname = 'C:\Users\zv211\OneDrive - University Of Cambridge\Documents\Bushveld\Critical Zone\UG\EBSD\ctf';

% which files to be imported
fname = [pname '\UG2-5 LAM_NR.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');


%%

[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',5*degree);
plot(ebsd, ebsd.bc);
colormap gray

%% grain boundaries
gB = grains.boundary;
gB_ChrChr = gB('Chromite','Chromite');
CS_Chr = ebsd('Chromite').CS

% compute the Forsterite ODF
odf_Chr = calcODF(ebsd('c').orientations,'Fourier')

% compute the uncorrelated Forsterite to Forsterite MDF
mdf_Chr = calcMDF(odf_Chr,odf_Chr)

%% Misorientation analysis
%subset chromite-chromite grain boundaries which have a miso axis close to [1 1 1]
condition=angle(gB_ChrChr.misorientation.axis, Miller(1,1,1,CS_Chr))<5*degree;
condition_2=angle(gB_ChrChr.misorientation.axis, Miller(1,1,0,CS_Chr))<5*degree;
condition_3=angle(gB_ChrChr.misorientation.axis, Miller(1,0,0,CS_Chr))<5*degree;

figure
plotAngleDistribution(gB_ChrChr.misorientation,'displayname','UG2_11')


plot(ebsd, ebsd.bc);
colormap gray
hold on
plot(gB_ChrChr(condition),'lineWidth',2,'lineColor','r','DisplayName','[111]')
hold on
plot(gB_ChrChr(condition_2),'lineWidth',2,'lineColor','g','DisplayName','[110]')
hold on
plot(gB_ChrChr(condition_3),'lineWidth',2,'lineColor','y','DisplayName','[100]')
hold off


%Histogram full data set 
figure
plotAngleDistribution(gB_ChrChr.misorientation,'displayname','uncorrelated','FaceColor','[0.5 0.5 0.5]')


% Histogram of relative angles between Chr grains

figure
plotAngleDistribution(gB_ChrChr.misorientation,'displayname','uncorrelated')
hold on
plotAngleDistribution(mdf_Chr,'DisplayName','Chr-Chr')
hold on
plotAngleDistribution(gB_ChrChr(condition).misorientation,'Color','r')
hold on
plotAngleDistribution(gB_ChrChr(condition_2).misorientation,'Color','g')
hold on
plotAngleDistribution(gB_ChrChr(condition_3).misorientation,'Color','y')
legend('random','bulk','[111]','[110]','[100]','Location','northwest')
hold off


