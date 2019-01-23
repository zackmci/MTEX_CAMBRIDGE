%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

%% Specify Crystal and Specimen Symmetries

CS = {... 
  'notIndexed',...
  crystalSymmetry('-1', [8.1732 12.8583 14.1703], [93.17,115.95,91.22]*degree, 'X||a*', 'Z||c', 'mineral', 'Anorthite', 'color', 'light blue'),...
  crystalSymmetry('mmm', [18.2406 8.8302 5.1852], 'mineral', 'Enstatite  Opx AV77', 'color', 'light green'),...
  crystalSymmetry('12/m1', [9.746 8.99 5.251], [90,105.63,90]*degree, 'X||a*', 'Y||b*', 'Z||c', 'mineral', 'Diopside   CaMgSi2O6', 'color', 'light red'),...
  crystalSymmetry('m-3m', [8.378 8.378 8.378], 'mineral', 'Chromite', 'color', 'cyan')};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');
setMTEXpref('outerPlotSpacing',0); 
%% Specify File Names

% path to files
pname = 'C:\Users\zv211\OneDrive - University Of Cambridge\Documents\Bushveld\Critical Zone\UG\EBSD\ctf';

% which files to be imported
fname = [pname '\UG2_11 LAM_1_NR.ctf'];
%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');

%% Default MTEX colormap - jet colormap begin with white
setMTEXpref('defaultColorMap',WhiteJetColorMap);

%%
%**************************************************************************
% Extract individual Forsterite orientations and crystal symmetry (CS)
% from ebsd object
%**************************************************************************
Opx_ori = ebsd('Enstatite  Opx AV77').orientations
Opx_CS = ebsd('Enstatite  Opx AV77').CS
%Ol_ori = ebsd('Forsterite').orientations
%Ol_CS = ebsd('Forsterite').CS
%%
%compute grain boundaires
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',5*degree);

gB = grains.boundary;
gB_OPxOPx = gB('Enstatite  Opx AV77','Enstatite  Opx AV77');

plot(ebsd, ebsd.bc);
colormap gray
hold on
plot(ebsd('Enstatite  Opx AV77'))
hold off

%% define subset with a polygon
%you need this next command line if you want to do more than one operation
hold on
poly = selectPolygon
ebsd01 = ebsd(inpolygon(ebsd, poly))

figure
plot(ebsd01, ebsd01.bc)
hold on
plot(ebsd01('Enstatite  Opx AV77'))


Opx_ori = ebsd01('Enstatite  Opx AV77').orientations
Opx_CS = ebsd01('Enstatite  Opx AV77').CS

Chr_ori = ebsd01('Chromite').orientations
Chr_CS = ebsd01('Chromite').CS
%**************************************************************************
% Plot point pole figure and Eigen-vectors (antipodal)
%**************************************************************************
figure
plotPDF(Opx_ori,Miller(1,0,0,Opx_CS,'hkl'),'equal','colorrange','markersize',5)

%%
figure
plotPDF(Opx_ori,Miller(0,1,0,Opx_CS,'hkl'),'equal','markersize',5)

%%
figure
plotPDF(Opx_ori,Miller(0,0,1,Opx_CS,'hkl'),'equal','markersize',5)

%**************************************************************************
% calculate ODF
%**************************************************************************
OPx_odf = calcODF(Opx_ori,'halfwidth',10.0*degree)
Max_density_of_odf = max(OPx_odf);

%Ol_odf = calcODF(Ol_ori,'halfwidth',10.0*degree);
%Max_density_of_odf = max(Ol_odf);
%%
%**************************************************************************
% Plot contoured pole figure and Eigen-vectors (antipodal)
%**************************************************************************
figure
plotPDF(OPx_odf,Miller(1,0,0,Opx_CS,'hkl'),'equal','contourf')
% find max in PF
h = Miller(1,0,0,Opx_CS,'hkl');
S2G = regularS2Grid('points',[72,19]);
pdf_100 = calcPoleFigure(OPx_odf,Miller(1,0,0,Opx_CS,'hkl'),S2G,'equal');
PF_max_100 = max(pdf_100);
% add horizontal colorbars
mtexColorbar('title','mrd');
mtexColorMap white2black;
%%
figure
plotPDF(OPx_odf,Miller(0,1,0,Opx_CS,'hkl'),'equal','contourf');

pdf_010 = calcPoleFigure(OPx_odf,Miller(0,1,0,Opx_CS,'hkl'),S2G,'equal');
PF_max_010 = max(pdf_010);
% add horizontal colorbars
mtexColorbar('title','mrd');
mtexColorMap white2black;
%%
figure
plotPDF(OPx_odf,Miller(0,0,1,Opx_CS,'hkl'),'equal','contourf')

pdf_001 = calcPoleFigure(OPx_odf,Miller(0,0,1,Opx_CS,'hkl'),S2G,'equal');
PF_max_001 = max(pdf_001)
% add horizontal colorbars
mtexColorbar('title','mrd')
mtexColorMap white2black;

%%
figure
plotPDF(OPx_odf,Miller(1,1,0,Opx_CS,'hkl'),'equal','contourf')

pdf_110 = calcPoleFigure(OPx_odf,Miller(1,1,0,Opx_CS,'hkl'),S2G,'equal');
PF_max_110 = max(pdf_110)
% add horizontal colorbars
mtexColorbar('title','mrd')
mtexColorMap white2black;

%% chromites
[grains,ebsd01.grainId,ebsd01.mis2mean] = calcGrains(ebsd01,'angle',5*degree);
gB = grains.boundary;
gB_ChrChr = gB('Chromite','Chromite');
gb_Opx = gB('Enstatite  Opx AV77','Enstatite  Opx AV77');

figure
[~,mP]= plot(ebsd01('Chromite'),ebsd01('Chromite').orientations,'FaceAlpha',0.5)
hold on
mP.micronBar.visible = 'off'
hold off

% pole figure Chr
om = ipfHSVKey(Chr_CS);
plot(om)

om.maxAngle=10*degree; 

gbgrains = ebsd01('Chromite').calcGrains('angle',2*degree,'unitCell')
col = om.orientation2color(ebsd01('Chromite').orientations); % here's the nx3 color vector

% odf and mdf
odf_Chr = calcODF(ebsd('c').orientations,'Fourier')

% compute the uncorrelated Forsterite to Forsterite MDF
mdf_Chr_Chr =calcMDF(gB_ChrChr.misorientation)

figure
plotPDF(Chr_ori, col, Miller(1,0,0,Chr_CS,'hkl'),'markersize',5)
figure
plotPDF(Chr_ori, col, Miller(1,1,0,Chr_CS,'hkl'),'markersize',5)
figure
plotPDF(Chr_ori, col, Miller(1,1,1,Chr_CS,'hkl'),'markersize',5)

axisDist_measured = calcAxisDistribution(mdf_Chr_Chr) 
nextAxis
figure
plot(axisDist_measured,'antipodal')
mtexTitle('measured')

%% opx misorientaiton axis
% compute the uncorrelated Opx to OPx MDF
mdf_Opx =calcMDF(gb_Opx.misorientation);
axisDist_measured = calcAxisDistribution(mdf_Opx) 
nextAxis
figure
plot(axisDist_measured,'antipodal')
mtexTitle('measured')
