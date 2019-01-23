%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

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
pname = 'C:\Users\zv211\Documents\Bushveld\Critical Zone\UG\EBSD\ctf';

% which files to be imported
fname = [pname '\UG2-5 LAM_NR.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');


[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',5*degree);
plot(ebsd, ebsd.bc);
colormap gray

%% grain boundaries
gB = grains.boundary;
gB_ChrChr = gB('Chromite','Chromite');
CS_Chr = ebsd('Chromite').CS

% %% Misorientation analysis
% %subset chromite-chromite grain boundaries which have a miso axis close to [1 1 1]
% condition=angle(gB_ChrChr.misorientation.axis, Miller(1,1,1,CS_Chr));
% condition_2=angle(gB_ChrChr.misorientation.axis, Miller(1,1,0,CS_Chr));
% condition_3=angle(gB_ChrChr.misorientation.axis, Miller(1,0,0,CS_Chr));
% 
% figure
% plotAngleDistribution(gB_ChrChr.misorientation,'displayname','UG2_11')
CSL_b = { CSL(3,CS_Chr) ;...
        CSL(5,CS_Chr); ...
        CSL(7,CS_Chr); ...
        CSL(9,CS_Chr); ...
        CSL(11,CS_Chr)}

col = {[1 0 0] [0 1 0] [0 0 1] [1 0.3 1] [0.5 1 0]}
bd = [3 5 7 9 11]


for i = 1: length(CSL_b)
    plot(ebsd,ebsd.prop.bc)
    mtexColorMap black2white
    hold on
    plot(gB_ChrChr(angle(CSL_b{i},gB_ChrChr.misorientation,'antipodal')<10/sqrt(bd(i))*degree),'lineColor',col{i},'linewidth',2)
    hold off
    mtexTitle(['axis ' char(round(CSL_b{i}.axis),'latex') ' angle ' num2str(CSL_b{i}.angle/degree)])
    saveFigure(['name_CSL_' num2str(bd(i)) '.png'])
end

%Histogram full data set 

figure
plotAngleDistribution(gB_ChrChr.misorientation.axis, Miller(1,1,1,CS_Chr)*degree,'Color','r')
hold on
plotAngleDistribution(gB_ChrChr.misorientation.axis, Miller(1,1,0,CS_Chr)*degree,'Color','g')
hold on
plotAngleDistribution(gB_ChrChr.misorientation.axis, Miller(1,0,0,CS_Chr)*degree,'Color','y')

legend('[111]','[110]','[100]','Location','northwest')
hold off



