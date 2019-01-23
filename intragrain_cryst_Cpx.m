clear all
%%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('-3m1', [5.1233 5.1233 13.7602], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Ilmenite', 'color', 'light blue'),...
  crystalSymmetry('m-3m', [8.395 8.395 8.395], 'mineral', 'Magnetite', 'color', 'light green'),...
  crystalSymmetry('-1', [8.1797 12.8748 14.1721], [93.13,115.89,91.24]*degree, 'X||a*', 'Z||c', 'mineral', 'Anorthite', 'color', 'light red')};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');
setMTEXpref('outerPlotSpacing',0); 

% path to files
pname = 'C:\Users\zv211\OneDrive - University Of Cambridge\Documents\Bushveld\Upper Zone\BK3-anorthosites\EBSD\ctf files';

% which files to be imported
fname = [pname '\UZ_symplectite_NR.ctf'];


% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');


%% calc grains

[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',10*degree);
grains;
gB = grains.boundary;

%% select grains
plot(grains('Augite'),grains('Augite').meanOrientation)
grain_xy= ginput; 
% close on those grains you want to select, hit ENTER when done
selected_grains = grains(findByLocation(grains,grain_xy))
plot(ebsd(selected_grains),ebsd(selected_grains).orientations)

%% 
figure
plot(ebsd(selected_grains),ebsd(selected_grains).mis2mean.angle ./ degree)
mtexColorbar
hold on
plot(selected_grains.boundary,'linewidth',2);
hold off
%%
cs = ebsd('Augite').CS;
ori = ebsd(selected_grains).orientations;
om = ipfHSVKey(cs,cs);
om.inversePoleFigureDirection = Miller(om.dirMap.whiteCenter,om.CS2); 

om.maxAngle=5*degree; 
plot(om)

gbgrains = ebsd(selected_grains).calcGrains('angle',2*degree,'unitCell')
col = om.orientation2color(ebsd(selected_grains).mis2mean); % here's the nx3 color vector

[~,mP]= plot(ebsd(selected_grains),ebsd(selected_grains).bc)
colormap gray
hold on
plot(ebsd(selected_grains),col,'Facealpha',0.85)
hold on
plot(gbgrains.boundary,'linewidth',2);
hold on
plot(gbgrains.innerBoundary,'lineColor','r','linewidth',2);
mP.micronBar.visible = 'off'
hold off

%% pole figures 

figure
plotPDF(ori,col,Miller(1,0,0,cs,'hkl'),'markersize',5)
figure
plotPDF(ori,col,Miller(0,1,0,cs,'hkl'),'markersize',5)
figure
plotPDF(ori,col,Miller(0,0,1,cs,'uvw'),'markersize',5)

