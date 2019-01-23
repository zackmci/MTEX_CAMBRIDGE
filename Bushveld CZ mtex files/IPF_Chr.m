clear all
close all
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
  crystalSymmetry('m-3m', [8.378 8.378 8.378], 'mineral', 'Chromite', 'color', 'light red')};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

%% Specify File Names

% path to files
pname = 'C:\Users\zv211\Documents\Bushveld\Critical Zone\UG\EBSD\ctf';

% which files to be imported
fname = [pname '\UG2_10_LAM_NR.ctf'];

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

%% define subset with a polygon
%you need this next command line if you want to do more than one operation
hold on
poly = selectPolygon
ebsd01 = ebsd(inpolygon(ebsd, poly))
color = oM.orientation2color(ebsd01('Chromite').orientations);

[grains01,ebsd01.grainId,ebsd01.mis2mean] = calcGrains(ebsd01,'angle',5*degree);

gB01 = grains01.boundary;
gB_ChrChr01 = gB01('Chromite','Chromite');
figure
gb_C=grains01.boundary('Chromite', 'Chromite')
axis_ug=gb_C.misorientation.axis
save('axis_ug210')
plot(axis_ug,'Fundamentalregion','antipodal', 'contourf')
hold on
plot(axis_ug, 'Fundamentalregion', 'Markersize', 1, 'Markercolor','black', 'FaceAlpha', 0.7)
figure
angle=gb_C.misorientation.angle./degree
histogram(angle)

% grains01=grains01('Chromite')
% gb_C=grains01.boundary('Chromite', 'Chromite')
% o=ebsd01(gb_C.ebsdId).orientations
% axistest = axis(o(:,1),o(:,2));
% plot(axistest,'Fundamentalregion','antipodal', 'contourf')

% figure
% plot(ebsd01, ebsd01.bc)
% hold on
% plot(ebsd01('Chromite'),color);

plot(ebsd01, ebsd01.bc);
colormap gray
hold on
plot(ebsd01('Chromite'),color, 'FaceAlpha', 0.7)
hold on
plot(gB_ChrChr01);
hold off


figure
plotIPDF(ebsd01('Chromite').orientations,[xvector; yvector; zvector],'all','contourf');
mtexColorbar('mrd');

% %% angle distribution
% % compute the Chr ODF
odf01_Chr = calcODF(ebsd01('Chromite').orientations,'Fourier')
 
CS_Chr = ebsd('Chromite').CS

% % compute the uncorrelated Chr to Chr MDF
mdf_Chr_Chr = calcMDF(odf01_Chr,odf01_Chr)
% 
% mori_Chr = calcMisorientation(ebsd('Chromite'));
% 
% figure
% plotAngleDistribution(gB_ChrChr01.misorientation,[1 0 0]);
% hold on
% plotAngleDistribution(mdf_Chr_Chr,'DisplayName','uncorreleted',[0 1 0])
% hold off
% 
% legend('-dynamicLegend','Location','northwest') % update legend
%%
% %Histogram full data set 
figure
plotAngleDistribution(gB_ChrChr01.misorientation,'displayname','uncorrelated','FaceColor','[0.5 0.5 0.5]')

condition=angle(gB_ChrChr01.misorientation.axis, Miller(1,1,1,CS_Chr))<1*degree;
condition_2=angle(gB_ChrChr01.misorientation.axis, Miller(1,1,0,CS_Chr))<1*degree;
condition_3=angle(gB_ChrChr01.misorientation.axis, Miller(1,0,0,CS_Chr))<1*degree;

figure
plotAngleDistribution(gB_ChrChr01(condition).misorientation,'Color','r')
hold on
plotAngleDistribution(gB_ChrChr01(condition_2).misorientation,'Color','g')
hold on
plotAngleDistribution(gB_ChrChr01(condition_3).misorientation,'Color','y')
legend('[111]','[110]','[100]','Location','northwest')
hold off

