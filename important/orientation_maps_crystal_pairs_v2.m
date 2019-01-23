%% selecting crystals by drawing polygonal

clear all

%% Specify Crystal and Specimen Symmetries

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
pname = '/Users/zack/Documents/Famatina/EBSD - Cambridge/FA10-03';

% which files to be imported
fname = [pname '/FA10-03 LAM_NR.ctf'];


%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');


%% calc grains

[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',10*degree);

gB = [grains.boundary grains.innerBoundary] ;
gB_Pl = ebsd('a').calcGrains('angle',2*degree,'unitCell');


figure
plot(ebsd('Anorthite'),ebsd('Anorthite').mis2mean.angle ./ degree)
%you need this next command line if you want to do more than one operation
hold on
poly = selectPolygon
ebsd01 = ebsd(inpolygon(ebsd, poly))

cs = ebsd01('Anorthite').CS;
oM = ipfHSVKey(cs)
color = oM.orientation2color(ebsd01('Anorthite').orientations);


gbgrains = ebsd01('Anorthite').calcGrains('angle',2*degree,'unitCell')

% All-E map

figure
[~,mP]= plot(ebsd01('Anorthite'),ebsd01('Anorthite').orientations, 'FaceAlpha',0.7);
hold on
plot(gbgrains.boundary,'linewidth',2,'FaceAlpha',0.7);
plot(gbgrains.innerBoundary,'lineColor','w','linewidth',2,'FaceAlpha',0.7);
mP.micronBar.visible = 'off'
hold off

%% plot IPF maps

cs = ebsd01('Anorthite').CS;
ori = ebsd01('Anorthite').orientations;
om = ipfHSVKey(cs,cs);
ipfKey = ipfColorKey(ebsd01('Anorthite'));
ipfKey.inversePoleFigureDirection = yvector;
col = ipfKey.orientation2color(ebsd01('Anorthite').orientations); % here's the nx3 color vector

plot(om)
[~,mP]= plot(ebsd,ebsd.bc,'Facealpha',0.75)
colormap gray
hold on
plot(ebsd01('Anorthite'),col,'Facealpha',0.85) 
hold on
plot(gB_Pl.boundary,'linewidth',1);
% hold on
% plot(gB_OPx.innerBoundary,'lineColor','r','linewidth',2);
mP.micronBar.visible = 'off'
hold off

%% PFs

h = [Miller(1,0,0,'uvw',ebsd01('Anorthite').CS),Miller(0,1,0,'hkl',ebsd01('Anorthite').CS),Miller(0,0,1,'hkl',ebsd01('Anorthite').CS)];
figure
plotPDF(ori,col,h,'antipodal','MarkerSize',6)

%% contoured PFs
 pl_odf = calcODF(ori,'halfwidth',10.0*degree)
 Max_density_of_odf = max(pl_odf);

 figure
plotPDF(pl_odf,h,'contourf','antipodal')
mtexColorbar('title','mrd');
mtexColorMap white2black;

%% rotation axes
% [grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',2*degree);
% grains=grains('a')
% gB_Pl=[grains.innerBoundary('a', 'a'); grains.boundary('a', 'a')];
% 
% ori_axis = ebsd(gB_Pl.ebsdId).orientations;
% 
% Opx_ax = axis(ori_axis(:,1),ori_axis(:,2));
% 
% cond= gB_Pl.misorientation.angle/degree <10 & gB_Pl.misorientation.angle/degree >2; 
% figure
% plot(Opx_ax(cond),'antipodal','contourf')
% mtexColorMap white2black;
% mtexColorbar


