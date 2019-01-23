%% selecting crystals by hand

clear all

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
gB_Pl = ebsd('a').calcGrains('angle',2*degree,'unitCell');

%% select grains
plot(grains('a'),grains('a').meanOrientation)
grain_xy= ginput; 
% close on those grains you want to select, hit ENTER when done
selected_grains = grains(findByLocation(grains,grain_xy));

gbgrains = ebsd(selected_grains).calcGrains('angle',2*degree,'unitCell')

plot(ebsd(selected_grains),ebsd(selected_grains).orientations);


%% plot IPF maps

cs = ebsd(selected_grains).CS;
ori = ebsd(selected_grains).orientations;
om = ipfHSVKey(cs,cs);
ipfKey = ipfColorKey(ebsd(selected_grains));
ipfKey.inversePoleFigureDirection = yvector;
col = ipfKey.orientation2color(ebsd(selected_grains).orientations); % here's the nx3 color vector

plot(om)
[~,mP]= plot(ebsd,ebsd.bc,'Facealpha',0.75)
colormap gray
hold on
plot(ebsd(selected_grains),col,'Facealpha',0.85) 
hold on
plot(gB_Pl.boundary,'linewidth',1);
% hold on
% plot(gB_OPx.innerBoundary,'lineColor','r','linewidth',2);
mP.micronBar.visible = 'off'
hold off

%% PFs

h = [Miller(1,0,0,'uvw',ebsd(selected_grains).CS),Miller(0,1,0,'hkl',ebsd(selected_grains).CS),Miller(0,0,1,'hkl',ebsd(selected_grains).CS)];
figure
plotPDF(ori,col,h,'antipodal','MarkerSize',6)

%% contoured PFs
% OPx_odf = calcODF(ori,'halfwidth',10.0*degree)
% Max_density_of_odf = max(OPx_odf);
% figure
% plotPDF(OPx_odf,h,'contourf','antipodal')
% mtexColorbar('title','mrd');
% mtexColorMap white2black;

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


