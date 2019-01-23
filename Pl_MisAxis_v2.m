%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

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
  crystalSymmetry('-3m1', [5.1233 5.1233 13.7602], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Ilmenite', 'color', 'light green'),...
  crystalSymmetry('m-3m', [8.395 8.395 8.395], 'mineral', 'Magnetite', 'color', 'light red'),...
  crystalSymmetry('12/m1', [5.3771 9.3082 10.2832], [90,100.22,90]*degree, 'X||a*', 'Y||b*', 'Z||c', 'mineral', 'Biotite', 'color', 'cyan'),...
  crystalSymmetry('mmm', [4.756 10.207 5.98], 'mineral', 'Forsterite', 'color', 'magenta')};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

%% Specify File Names

% path to files
pname = 'C:\Users\zv211\OneDrive - University Of Cambridge\Documents\Bushveld\Upper Zone\BK3-anorthosites\EBSD\ctf files';

% which files to be imported
fname = [pname '\BK3_1-15_LAM_NR-Pl_ppg.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');

%% calc grains 

[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',2*degree);

%% Misorientation axes

gB = grains.boundary;
cond= gB_AnAn.misorientation.angle/degree <10 & gB_AnAn.misorientation.angle/degree >2; 
gB_AnAn = gB('Anorthite','Anorthite');

ori = ebsd(gB_AnAn(cond).ebsdId).orientations;

axis(ori(:,1),ori(:,2))

AnAn_ax = axis(ori(:,1),ori(:,2));

plot(AnAn_ax, 'antipodal','contourf')
% mtexColorMap white2black;