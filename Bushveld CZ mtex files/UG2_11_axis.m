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
  crystalSymmetry('12/m1', [9.746 8.99 5.251], [90,105.63,90]*degree, 'X||a*', 'Y||b', 'Z||c', 'mineral', 'Diopside   CaMgSi2O6', 'color', 'light red'),...
  crystalSymmetry('m-3m', [8.378 8.378 8.378], 'mineral', 'Chromite', 'color', 'cyan')};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

%% Specify File Names

% path to files
pname = 'C:\Users\zv211\Documents\Bushveld\Critical Zone\UG\new files';

% which files to be imported
fname = [pname '\UG2_11 LAM_1_NR_v2.ctf'];

ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');
oM = ipdfHSVOrientationMapping(ebsd('Chromite'));


b = 10;
% calculates grains and creates vector variable "grains"
[grains, ebsd.grainId] = calcGrains(ebsd,'angle',b*degree);
% creates a subset of BCC grains called "greinsBCC"
grainsChromite = grains('Chromite');

%grain boundaries definition
frm = fundamentalRegion(CS('Chromite'),CS('Chromite'));
plot(frm,'color','r');

hold on

gb = grains.boundary;
gb_Chr = gb('Chromite','Chromite');
Sampling_N=20;
gb_Chr = gb_Chr(1:Sampling_N:end);
%ori = ebsd(gb_Chr.ebsdId).orientations;
%gb_axes = axis(ori(:,1),ori(:,2));
gb_Chr_miso = gb_Chr.misorientation;
gb_Chr_miso_axes = axis(gb_Chr_miso);
gb_Chr_miso_angle = angle(gb_Chr_miso) / degree;
hist(gb_Chr_miso_angle)

%plot(gb_Chr.project2FundamentalRegion('antipodal'),'color','g');
plot(gb_Chr_miso_axes,'resolution',1*degree)

hold off


plot(gb_Chr,gb_Chr.misorientation.angle./degree,'linewidth',2)
hold on
mtexColorbar
set(gcf, 'name','grain boundaries');

hold off

%% Misorientation

%misAngle = gb_Chr.misorientation.angle./degree;
%hist(misAngle);

% d  = Miller({1,0,0},grainsChromite('Chromite').CS)
% 
% grainsChromite100 = orientation(grainsChromite.meanOrientation) * d;
% 
% grainsChromite100_vs_X_angles = angle(grainsChromite100,vector3d.Z) / degree; 
%  
% hist(grainsChromite100_vs_X_angles)


