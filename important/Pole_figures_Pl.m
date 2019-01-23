%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

%% Specify Crystal and Specimen Symmetries

CS = {... 
  'notIndexed',...
  crystalSymmetry('12/m1', [9.746 8.99 5.251], [90,105.63,90]*degree, 'X||a*', 'Y||b*', 'Z||c', 'mineral', 'Diopside   CaMgSi2O6', 'color', 'light blue'),...
  crystalSymmetry('-1', [8.1797 12.8748 14.1721], [93.13,115.89,91.24]*degree, 'X||a*', 'Z||c', 'mineral', 'Anorthite', 'color', 'light green'),...
  crystalSymmetry('mmm', [18.2406 8.8302 5.1852], 'mineral', 'Enstatite  Opx AV77', 'color', 'light red'),...
  crystalSymmetry('m-3m', [8.395 8.395 8.395], 'mineral', 'Magnetite', 'color', 'cyan'),...
  crystalSymmetry('12/m1', [9.8701 18.0584 5.3072], [90,105.2,90]*degree, 'X||a*', 'Y||b*', 'Z||c', 'mineral', 'Hornblende', 'color', 'magenta')};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

%% Specify File Names

% path to files
pname = '/Users/zack/Documents/Famatina/EBSD - Cambridge/FA18-01B';

% which files to be imported
fname = [pname '/FA18-01B_LAM_NR.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');


%%

[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',2*degree);

%%
%**************************************************************************
% Extract individual Forsterite orientations and crystal symmetry (CS)
% from ebsd object
%**************************************************************************
An_ori = ebsd('Anorthite').orientations
An_CS = ebsd('Anorthite').CS
%Ol_ori = ebsd('Forsterite').orientations
%Ol_CS = ebsd('Forsterite').CS

%**************************************************************************
% Plot point pole figure and Eigen-vectors (antipodal)
%**************************************************************************
figure
plotPDF(An_ori,Miller(1,0,0,An_CS,'uvw'),'equal','all','markercolor', 'black','markersize',4)

%%
figure
plotPDF(An_ori,Miller(0,1,0,An_CS,'hkl'),'equal','all','markercolor', 'black','markersize',4)

%%
figure
plotPDF(An_ori,Miller(0,0,1,An_CS,'hkl'),'equal','all','markercolor', 'black','markersize',4)

%**************************************************************************
% calculate ODF
%**************************************************************************
An_odf = calcODF(An_ori,'halfwidth',10.0*degree)
Max_density_of_odf = max(An_odf);
% 
% %Ol_odf = calcODF(Ol_ori,'halfwidth',10.0*degree);
% %Max_density_of_odf = max(Ol_odf);
% %%
% %**************************************************************************
% % Plot contoured pole figure and Eigen-vectors (antipodal)
% %**************************************************************************
figure
plotPDF(An_odf,Miller(1,0,0,An_CS,'uvw'),'equal','contourf')
% find max in PF
h = Miller(1,0,0,An_CS,'uvw');
S2G = regularS2Grid('points',[72,19]);
pdf_100 = calcPoleFigure(An_odf,Miller(1,0,0,An_CS,'uvw'),S2G,'equal');
PF_max_100 = max(pdf_100)
% add horizontal colorbars
mtexColorbar('title','mrd')
mtexColorMap white2black;
%%
figure
plotPDF(An_odf,Miller(0,1,0,An_CS,'hkl'),'equal','contourf')

pdf_010 = calcPoleFigure(An_odf,Miller(0,1,0,An_CS,'hkl'),S2G,'equal');
PF_max_010 = max(pdf_010)
% add horizontal colorbars
mtexColorbar('title','mrd')
mtexColorMap white2black;
% %%
 figure
 plotPDF(An_odf,Miller(1,0,0,An_CS,'hkl'),'equal','contourf')

pdf_001 = calcPoleFigure(An_odf,Miller(0,0,1,An_CS,'hkl'),S2G,'equal');
PF_max_001 = max(pdf_001)
% add horizontal colorbars
mtexColorbar('title','mrd')
mtexColorMap white2black;
