%%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('12/m1', [9.746 8.99 5.251], [90,105.63,90]*degree, 'X||a*', 'Y||b', 'Z||c', 'mineral', 'Diopside   CaMgSi2O6', 'color', 'light blue'),...
  crystalSymmetry('-3m1', [5.1233 5.1233 13.7602], 'X||a*', 'Y||b', 'Z||c', 'mineral', 'Ilmenite', 'color', 'light green'),...
  crystalSymmetry('mmm', [4.756 10.207 5.98], 'mineral', 'Forsterite', 'color', 'light red'),...
  crystalSymmetry('mmm', [18.2406 8.8302 5.1852], 'mineral', 'Enstatite  Opx AV77', 'color', 'cyan'),...
  crystalSymmetry('-1', [8.1797 12.8748 14.1721], [93.13,115.89,91.24]*degree, 'X||a*', 'Z||c', 'mineral', 'Anorthite', 'color', 'magenta'),...
  crystalSymmetry('m-3m', [8.3996 8.3996 8.3996], 'mineral', 'Magnetite', 'color', 'yellow')};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

%% Specify File Names

% path to files
pname = 'C:\Users\zv211\Documents\Skeargraad\Trough bands\Mtex\ppg\TB_ppg\ctf files';

% which files to be imported
fname = [pname '\F8 C5 LAM_NR_v2-Cpx_Ol.ctf'];

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
Ol_ori = ebsd('Forsterite').orientations;
Ol_CS = ebsd('Forsterite').CS;

Cpx_ori = ebsd('Diopside   CaMgSi2O6').orientations;
Cpx_CS = ebsd('Diopside   CaMgSi2O6').CS;
%**************************************************************************
% Plot point pole figure Olivine
%**************************************************************************
figure
plotPDF(Ol_ori,Miller(1,0,0,Ol_CS,'hkl'),'equal','markersize',5)

%%
figure
plotPDF(Ol_ori,Miller(0,1,0,Ol_CS,'hkl'),'equal','markersize',5)

%%
figure
plotPDF(Ol_ori,Miller(0,0,1,Ol_CS,'hkl'),'equal','markersize',5)

%**************************************************************************
% Plot point pole figure Diopside
%**************************************************************************
figure
plotPDF(Cpx_ori,Miller(1,0,0,Cpx_CS,'hkl'),'equal','markersize',5)

%%
figure
plotPDF(Cpx_ori,Miller(0,1,0,Cpx_CS,'uvw'),'equal','markersize',5)

%%
figure
plotPDF(Cpx_ori,Miller(0,0,1,Cpx_CS,'uvw'),'equal','markersize',5)

%**************************************************************************
% calculate ODF
%**************************************************************************
Ol_odf = calcODF(Ol_ori,'halfwidth',10.0*degree)
Max_density_of_odf = max(Ol_odf);

Cpx_odf = calcODF(Cpx_ori,'halfwidth',10.0*degree)
Max_density_of_odf = max(Cpx_odf);

%%
%**************************************************************************
% Plot contoured pole figure Olivine
%**************************************************************************
figure
plotPDF(Ol_odf,Miller(1,0,0,Ol_CS,'hkl'),'equal')
% find max in PF
h = Miller(1,0,0,Ol_CS,'hkl');
S2G = regularS2Grid('points',[72,19]);
pdf_100 = calcPoleFigure(Ol_odf,Miller(1,0,0,Ol_CS,'hkl'),S2G,'equal');
PF_max_100 = max(pdf_100)
% add horizontal colorbars
mtexColorbar('title','mrd')

%%
figure
plotPDF(Ol_odf,Miller(0,1,0,Ol_CS,'hkl'),'equal')

pdf_010 = calcPoleFigure(Ol_odf,Miller(0,1,0,Ol_CS,'hkl'),S2G,'equal');
PF_max_010 = max(pdf_010)
% add horizontal colorbars
mtexColorbar('title','mrd')

%%
figure
plotPDF(Ol_odf,Miller(0,0,1,Ol_CS,'hkl'),'equal')

pdf_001 = calcPoleFigure(Ol_odf,Miller(0,0,1,Ol_CS,'hkl'),S2G,'equal');
PF_max_001 = max(pdf_001)

% add horizontal colorbars
mtexColorbar('title','mrd')

%%
%**************************************************************************
% Plot contoured pole figure Cpx
%**************************************************************************
figure
plotPDF(Cpx_odf,Miller(1,0,0,Cpx_CS,'hkl'),'equal')
% find max in PF
h = Miller(1,0,0,Cpx_CS,'hkl');
S2G = regularS2Grid('points',[72,19]);
pdf_100 = calcPoleFigure(Cpx_odf,Miller(1,0,0,Cpx_CS,'hkl'),S2G,'equal');
PF_max_100 = max(pdf_100)
% add horizontal colorbars
mtexColorbar('title','mrd')

%%
figure
plotPDF(Cpx_odf,Miller(0,1,0,Cpx_CS,'uvw'),'equal')

pdf_010 = calcPoleFigure(Cpx_odf,Miller(0,1,0,Cpx_CS,'uwv'),S2G,'equal');
PF_max_010 = max(pdf_010)

% add horizontal colorbars
mtexColorbar('title','mrd')

%%
figure
plotPDF(Cpx_odf,Miller(0,0,1,Cpx_CS,'hkl'),'equal')

pdf_001 = calcPoleFigure(Cpx_odf,Miller(0,0,1,Cpx_CS,'uwv'),S2G,'equal');
PF_max_001 = max(pdf_001)
% add horizontal colorbars
mtexColorbar('title','mrd')

