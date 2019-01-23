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
pname = 'C:\Users\zv211\Documents\Bushveld\Critical Zone\Merensky Reef\ctf files';

% which files to be imported
fname = [pname '\MR_normal_sampleI_runII_NR.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');


%% Default MTEX colormap - jet colormap begin with white
setMTEXpref('defaultColorMap',WhiteJetColorMap);

%%
%compute grain boundaires
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',5*degree);

gB = grains.boundary;
gB_OPxOPx = gB('Anorthite','Anorthite');

plot(ebsd, ebsd.bc);
colormap gray
hold on
plot(ebsd('Anorthite'))
hold off

%% define subset with a polygon
%you need this next command line if you want to do more than one operation
hold on
poly = selectPolygon
ebsd01 = ebsd(inpolygon(ebsd, poly))

figure
plot(ebsd01, ebsd01.bc)
hold on
plot(ebsd01('Anorthite'))


An_ori = ebsd01('Anorthite').orientations
An_CS = ebsd01('Anorthite').CS
%**************************************************************************
% Plot point pole figure and Eigen-vectors (antipodal)
%**************************************************************************
figure
plotPDF(An_ori,Miller(1,0,0,An_CS,'uvw'),'equal','colorrange','markersize',5)

%%
figure
plotPDF(An_ori,Miller(0,1,0,An_CS,'hkl'),'equal','markersize',5)

%%
figure
plotPDF(An_ori,Miller(0,0,1,An_CS,'hkl'),'equal','markersize',5)

%**************************************************************************
% calculate ODF
%**************************************************************************
An_odf = calcODF(An_ori,'halfwidth',10.0*degree)
Max_density_of_odf = max(An_odf);

%Ol_odf = calcODF(Ol_ori,'halfwidth',10.0*degree);
%Max_density_of_odf = max(Ol_odf);
%%
%**************************************************************************
% Plot contoured pole figure and Eigen-vectors (antipodal)
%**************************************************************************
figure
plotPDF(An_odf,Miller(1,0,0,An_CS,'uvw'),'equal','contourf')
% find max in PF
h = Miller(1,0,0,An_CS,'uvw');
S2G = regularS2Grid('points',[72,19]);
pdf_100 = calcPoleFigure(An_odf,Miller(1,0,0,An_CS,'uvw'),S2G,'equal');
PF_max_100 = max(pdf_100);
% add horizontal colorbars
mtexColorbar('title','mrd');
mtexColorMap white2black;
%%
figure
plotPDF(An_odf,Miller(0,1,0,An_CS,'hkl'),'equal','contourf');

pdf_010 = calcPoleFigure(An_odf,Miller(0,1,0,An_CS,'hkl'),S2G,'equal');
PF_max_010 = max(pdf_010);
% add horizontal colorbars
mtexColorbar('title','mrd');
mtexColorMap white2black;
%%
figure
plotPDF(An_odf,Miller(0,0,1,An_CS,'hkl'),'equal','contourf')

pdf_001 = calcPoleFigure(An_odf,Miller(0,0,1,An_CS,'hkl'),S2G,'equal');
PF_max_001 = max(pdf_001)
% add horizontal colorbars
mtexColorbar('title','mrd')
mtexColorMap white2black;