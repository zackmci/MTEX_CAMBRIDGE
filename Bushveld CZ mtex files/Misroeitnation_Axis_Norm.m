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


CS_Chr = ebsd('Chromite').CS
mori_Chr = calcMisorientation(ebsd('Chromite'));
%%
oM = ipdfHSVOrientationMapping(ebsd('Chromite'));
oM.inversePoleFigureDirection = xvector;

% compute the colors again
color = oM.orientation2color(ebsd('Chromite').orientations);

%compute grain boundaires
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',8*degree);

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

%% Ruediger code to calcuklate pdf

centerr =zvector;
hw = 10*degree; % strength of orderin
x = 45*degree; % distance of ring from the center

odf_Chr = fibreODF(Miller(1,1,1,CS_Chr),centerr,'halfwidth',hw);


hx = Miller(rotation('Euler',[0 x 0]).* (Miller(1,1,1,CS_Chr)), CS_Chr) % a cs x-dregrees away from the center
grid  =equispacedS2Grid('resolution',1*degree);
den = calcPDF(odf_Chr,hx,grid);
pdf_Chr = S2FunHarmonic.quadrature(grid,den); %get a continuous function

%% compute the Chr ODF

mdf_Chr_Chr = calcMDF(odf_Chr,odf_Chr)

%%

Axis_Chr = calcAxisDistribution(pdf_Chr,'Fundamentalregion','antipodal','contourf');

Uniform_Chr = calcAxisDistribution(mdf_Chr_Chr,'Fundamentalregion','antipodal', 'contourf');
%% Zoja's lines Axis distributions

figure
plotAxisDistribution(mori_Chr,'Fundamentalregion','antipodal','contourf');
figure
plotAxisDistribution(mdf_Chr_Chr,'Fundamentalregion','antipodal','contourf');


%% Ralf's code
%// this is the three dimensional sector of the orientation space
oR = fundamentalRegion(ebsd('Chromite').CS)

%// for this you can get the fundamental sector
h = plotS2Grid(oR.axisSector,'resolution',.5*degree)

%// as well as the uncorrelated axisdistribution
Axis_Distribution = oR.calcAxisDistribution(h);

%// uniform axis distribution

Uniform_Axis_Dist = mdf_Chr_Chr.calcAxisDistribution(h);

NormAxis = Axis_Distribution/Uniform_Axis_Dist;

figure
plotAxisDistribution(NormAxis,'Fundamentalregion','antipodal','contourf');
