clear all

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('12/m1', [9.746 8.99 5.251], [90,105.63,90]*degree, 'X||a*', 'Y||b*', 'Z||c', 'mineral', 'Diopside   CaMgSi2O6', 'color', 'light blue'),...
  crystalSymmetry('-1', [8.1797 12.8748 14.1721], [93.1346,115.885,91.2365]*degree, 'X||a*', 'Z||c', 'mineral', 'Anorthite', 'color', 'light green'),...
  crystalSymmetry('mmm', [18.2406 8.8302 5.1852], 'mineral', 'Enstatite  Opx AV77', 'color', 'light red'),...
  crystalSymmetry('m-3m', [8.395 8.395 8.395], 'mineral', 'Magnetite', 'color', 'cyan'),...
  crystalSymmetry('12/m1', [9.8701 18.0584 5.3072], [90,105.2,90]*degree, 'X||a*', 'Y||b*', 'Z||c', 'mineral', 'Hornblende', 'color', 'magenta'),...
  crystalSymmetry('-3m1', [4.913 4.913 5.504], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Quartz-new', 'color', 'yellow')};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

%% Specify File Names

% path to files
pname = '/Users/zack/Documents/Famatina/EBSD - Cambridge/FA18-05a';

% which files to be imported
fname = [pname '/FA18-05a LAM_NR.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');


%% calc grains

[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',8*degree);

gB = [grains.boundary grains.innerBoundary];


%% select grains
% plot(grains('Anorthite'),grains('Anorthite').meanOrientation)
% grain_xy= ginput; 
% % close on those grains you want to select, hit ENTER when done
% selected_grains = grains(findByLocation(grains,grain_xy));
% plot(ebsd(selected_grains),ebsd(selected_grains).orientations)
% %save selected_grains

%% 

[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',8*degree);

%% mis profile

cs = ebsd('Anorthite').CS;
ori = ebsd('Anorthite').orientations;
om = ipfHSVKey(cs,cs);
om.inversePoleFigureDirection = Miller(om.dirMap.whiteCenter,om.CS2); 

om.maxAngle=10*degree;
figure
plot(om) % legend

gbgrains = ebsd('Anorthite').calcGrains('angle',2*degree,'unitCell')
col = om.orientation2color(ebsd('Anorthite').mis2mean); % here's the nx3 color vector

figure
[~,mP]= plot(ebsd('a'),ebsd('a').bc)
colormap gray
hold on
plot(ebsd('Anorthite'),col,'Facealpha',0.75)
hold on
plot(gbgrains.boundary,'linewidth',1.5);
hold on
plot(gbgrains.innerBoundary,'lineColor','r','linewidth',2);
mP.micronBar.visible = 'off'
hold off

%% pole figures

figure
plotPDF(ori, col, Miller(1,0,0,cs,'uvw'),'lower','markersize',8)
figure
plotPDF(ori, col, Miller(0,1,0,cs,'hkl'),'markersize',8)
figure
plotPDF(ori, col, Miller(0,0,1,cs,'hkl'),'markersize',8)
