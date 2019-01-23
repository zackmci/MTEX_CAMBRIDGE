clear all
close all
%% Specify Crystal and Specimen Symmetries

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

[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',10*degree);

gB = [grains.boundary grains.innerBoundary] ;

%% phase map
figure 
plot(ebsd, ebsd.bc, 'FaceAlpha',0.8)
colormap gray
hold on
plot(ebsd,'FaceAlpha',0.5)
hold on
plot(grains.boundary,'linewidth',0.75);
hold off

% %% select grains
% plot(grains('a'),grains('a').meanOrientation)
% grain_xy= ginput; 
% % close on those grains you want to select, hit ENTER when done
% selected_grains = grains(findByLocation(grains,grain_xy));

gbgrains = ebsd('d').calcGrains('angle',2*degree,'unitCell')
% Pl_gbgrains = ebsd('a').calcGrains('angle',2*degree,'unitCell')


plot(ebsd('d'),ebsd('D').orientations);

figure
plot(ebsd('d'),ebsd('d').mis2mean.angle ./ degree, 'FaceAlpha',0.7)
hold on
plot(grains('d').boundary,'linewidth',2);
plot(gbgrains.innerBoundary,'lineColor','r','linewidth',2);
mtexColorbar
CLim(gcm,[1 10])
hold off



%% plot IPF maps

cs = ebsd('d').CS;
ori = ebsd('d').orientations;
om = ipfHSVKey(cs,cs);
ipfKey = ipfColorKey(ebsd('d'));
ipfKey.inversePoleFigureDirection = yvector;
col = ipfKey.orientation2color(ebsd('d').orientations); % here's the nx3 color vector

plot(om)
figure
[~,mP]= plot(ebsd,ebsd.bc,'Facealpha',0.75)
colormap gray
hold on
plot(ebsd('d'),col,'Facealpha',0.85) 
hold on
plot(grains('d').boundary,'linewidth',1);
% hold on
% plot(gB_OPx.innerBoundary,'lineColor','r','linewidth',2);
mP.micronBar.visible = 'off'
hold off


h = [Miller(1,0,0,'hkl',ebsd(grains('d')).CS),Miller(0,1,0,'hkl',ebsd(grains('d')).CS),Miller(0,0,1,'uwv',ebsd(grains('d')).CS)];
figure
plotPDF(ori,col,h,'antipodal','all','MarkerSize',6)

%% contoured PFs

di_odf = calcODF(ori,'halfwidth',10.0*degree)
Max_density_of_odf = max(di_odf);

% %**************************************************************************
% % Plot contoured pole figure and Eigen-vectors (antipodal)
% %**************************************************************************
figure
plotPDF(di_odf,Miller(1,0,0,cs,'hkl'),'equal','contourf')
% find max in PF
h = Miller(1,0,0,cs,'uvw');
S2G = regularS2Grid('points',[72,19]);
pdf_100 = calcPoleFigure(di_odf,Miller(1,0,0,cs,'uvw'),S2G,'equal');
PF_max_100 = max(pdf_100)
% add horizontal colorbars
mtexColorbar('title','mrd')
mtexColorMap white2black;


%010
figure
plotPDF(di_odf,Miller(0,1,0,cs,'hkl'),'equal','contourf')
pdf_010 = calcPoleFigure(di_odf,Miller(0,1,0,cs,'hkl'),S2G,'equal');
PF_max_010 = max(pdf_010)
% add horizontal colorbars
mtexColorbar('title','mrd')
mtexColorMap white2black;


% 001
figure
plotPDF(di_odf,Miller(0,0,1,cs,'uvw'),'equal','contourf')
pdf_001 = calcPoleFigure(di_odf,Miller(0,0,1,cs,'hkl'),S2G,'equal');
PF_max_001 = max(pdf_001)
% add horizontal colorbars
mtexColorbar('title','mrd')
mtexColorMap white2black;


