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
pname = 'C:\Users\zv211\Documents\Bushveld\Critical Zone\UG\EBSD\ctf';

% which files to be imported
fname = [pname '\UG2_8 LAM_NR_v2.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');

%%
%**************************************************************************
% Extract individual Forsterite orientations and crystal symmetry (CS)
% from ebsd object
%**************************************************************************
Opx_ori = ebsd('Enstatite  Opx AV77').orientations
Opx_CS = ebsd('Enstatite  Opx AV77').CS
%**************************************************************************
% vectors of [100] directions in specimen co-ordinates
%**************************************************************************
v = Opx_ori  * Miller(1,0,0,Opx_CS,'hkl');
%%
%********************************************************
% orientation tensor and eigenvalue analysis
%********************************************************
% Use Func_Orientation_Tensor_RH.m to calculate the Orientation Tensor "OT",
% 3 Eigen-values "value" and 3 orthogonal Eigen-vectors "vec1,vec2,vec3"
% OT and rot are not used here
[OT,E_values,E_vec1,E_vec2,E_vec3,rot] = Func_Orientation_Tensor_RH(v);
% label Eigen-values for [100]
EV1_100 = E_values(1)
EV2_100 = E_values(2)
EV3_100 = E_values(3)
% lable eigen-vector for [100]
E1_100 = E_vec1;
E2_100 = E_vec2;
E3_100 = E_vec3;
%**************************************************************************
% Vollmer, F.W., 1990. An application of eigenvalue methods to structural
% domain analysis. Geological Society of America Bulletin 102,786-791.
% Eigen-Analysis
%**************************************************************************
NORM=E_values(1)+E_values(2)+E_values(3);
% Point maximum
P100=(E_values(1)-E_values(2))/NORM
% Girdle
G100=(2.0*(E_values(2)-E_values(3)))/NORM
% Random
R100=(3.0*E_values(3))/NORM
%%
%**************************************************************************
% vectors of (010) poles in specimen co-ordinates
%**************************************************************************
v = Opx_ori * Miller(0,1,0,Opx_CS,'hkl');
%**************************************************************************
% orientation tensor and eigen-analysis
%**************************************************************************

[OT,E_values,E_vec1,E_vec2,E_vec3,rot] = Func_Orientation_Tensor_RH(v);
% label Eigen-values for [010]
EV1_010=E_values(1)
EV2_010=E_values(2)
EV3_010=E_values(3)
% lable eigen-vector for [010]
E1_010 = E_vec1;
E2_010 = E_vec2;
E3_010 = E_vec3;
%**************************************************************************
% Vollmer, F.W., 1990. An application of eigenvalue methods to structural
% domain analysis. Geological Society of America Bulletin 102,786-791.
% Eigen-Analysis
%**************************************************************************
NORM=E_values(1)+E_values(2)+E_values(3);
% Point maximum
P010=(E_values(1)-E_values(2))/NORM
% Girdle
G010=(2.0*(E_values(2)-E_values(3)))/NORM
% Random
R010=(3.0*E_values(3))/NORM
%%
%**************************************************************************
% vectors of [001] directions in specimen co-ordinates
%**************************************************************************
v = Opx_ori * Miller(0,0,1,Opx_CS,'hkl');
%**************************************************************************
% orientation tensor and eigenvalue analysis
% OT and rot are not used here
%**************************************************************************
[OT,E_values,E_vec1,E_vec2,E_vec3,rot] = Func_Orientation_Tensor_RH(v)
% label Eigen-values for [001]
EV1_001=E_values(1)
EV2_001=E_values(2)
EV3_001=E_values(3)
% lable eigen-vector for [001]
E1_001 = E_vec1;
E2_001 = E_vec2;
E3_001 = E_vec3;
%**************************************************************************
% Vollmer, F.W., 1990. An application of eigenvalue methods to structural
% domain analysis. Geological Society of America Bulletin 102,786-791.
% Eigen-Analysis
%**************************************************************************
NORM=E_values(1)+E_values(2)+E_values(3);
% Point maximum
P001=(E_values(1)-E_values(2))/NORM
% Girdle
G001=(2.0*(E_values(2)-E_values(3)))/NORM
% Random
R001=(3.0*E_values(3))/NORM
%%
%**************************************************************************
% Plot point pole figure and Eigen-vectors (antipodal)
%**************************************************************************
figure
plotPDF(Opx_ori,Miller(1,0,0,Opx_CS,'hkl'),'antipodal','markersize',10)
% plot Eigen-vectors N.B. 'antipodal' option in annotate
annotate([E1_100,E2_100,E3_100],'antipodal','label',{'E1','E2','E3'},...
  'BackgroundColor','w','markersize',10);
%saveFigure('/MatLab_Programs/Olivine_100_eigen_point_plot_antipodal.png');
%%
figure
plotPDF(Opx_ori,Miller(0,1,0,Opx_CS,'hkl'),'antipodal','markersize',10)
% plot Eigen-vectors
annotate([E1_010,E2_010,E3_010],'antipodal','label',{'E1','E2','E3'},...
  'BackgroundColor','w','markersize',10);
%saveFigure('/MatLab_Programs/Olivine_010_eigen_point_plot_antipodal.png');
%%
figure
plotPDF(Opx_ori,Miller(0,0,1,Opx_CS,'hkl'),'antipodal','markersize',10)
% plot Eigen-vectors
annotate([E1_001,E2_001,E3_001],'antipodal','label',{'E1','E2','E3'},...
  'BackgroundColor','w','markersize',10);
%saveFigure('/MatLab_Programs/Olivine_001_eigen_point_plot_antipodal.png');
%%
%**************************************************************************
% calculate ODF
%**************************************************************************
Opx_odf = calcODF(Opx_ori,'halfwidth',15.0*degree)
Max_density_of_odf = max(Opx_odf)

%%
%**************************************************************************
% Plot contoured pole figure and Eigen-vectors (antipodal)
%**************************************************************************
figure
plotPDF(Opx_odf,Miller(1,0,0,Opx_CS,'hkl'),'antipodal')
% find max in PF
h = Miller(1,0,0,Opx_CS,'hkl');
S2G = regularS2Grid('points',[72,19]);
pdf_100 = calcPoleFigure(Opx_odf,Miller(1,0,0,Opx_CS,'hkl'),S2G,'antipodal');
PF_max_100 = max(pdf_100)
% plot Eigen-vectors
%annotate([E1_100,E2_100,E3_100],'label',{'E1','E2','E3'},...
 % 'BackgroundColor','w','markersize',10);
saveFigure('C:\Users\zv211\Documents\Skeargraad\Trough bands\Mtex\figures\An_uvw_100_eigen_contour_plot_antipodal.emf');
%%
figure
plotPDF(Opx_odf,Miller(0,1,0,Opx_CS,'hkl'),'antipodal')
% plot Eigen-vectors
%annotate([E1_010,E2_010,E3_010],'label',{'E1','E2','E3'},...
 % 'BackgroundColor','w','markersize',10);
saveFigure('C:\Users\zv211\Documents\Skeargraad\Trough bands\Mtex\figures\An_hkl_010_eigen_contour_plot_antipodal.emf');
%%
figure
plotPDF(Opx_odf,Miller(0,0,1,Opx_CS,'hkl'),'antipodal')
% plot Eigen-vectors
%annotate([E1_001,E2_001,E3_001],'label',{'E1','E2','E3'},...
  %'BackgroundColor','w','markersize',10);
saveFigure('C:\Users\zv211\Documents\Skeargraad\Trough bands\Mtex\figures\An_hkl_001_eigen_contour_plot_antipodal.emf');
%
%**************************************************************************
%% Indices for olivine
%**************************************************************************
% BA_index 0=axial 010 1=axial 100 
BA_index = 0.5*(2.0-(P010/(G010+P010))-(G100/(G100+P100)))
% BC_index 0=axial 010 1=axial 001 
BC_index = 0.5*(2.0-(P010/(G010+P010))-(G001/(G001+P001)))
% AC_index 0=axial 100 1=axial 001 
AC_index = 0.5*(2.0-(P100/(G100+P100))-(G001/(G001+P001)))
% j - index
j = textureindex(Opx_odf);

