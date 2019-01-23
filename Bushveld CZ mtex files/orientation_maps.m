clear all

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('-1', [8.1732 12.8583 14.1703], [93.17,115.95,91.22]*degree, 'X||a*', 'Z||c', 'mineral', 'Anorthite', 'color', 'light blue'),...
  crystalSymmetry('mmm', [18.2406 8.8302 5.1852], 'mineral', 'Enstatite  Opx AV77', 'color', 'light green'),...
  crystalSymmetry('m-3m', [8.378 8.378 8.378], 'mineral', 'Chromite', 'color', 'light red')};

% plotting convention
setMTEXpref('xAxisDirection','north');
setMTEXpref('zAxisDirection','intoPlane');

%% Specify File Names

% path to files
pname = 'C:\Users\zv211\OneDrive - University Of Cambridge\Documents\Bushveld\Critical Zone\UG\EBSD\ctf';

% which files to be imported
fname = [pname '\UG2_10_LAM_NR.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');
%% calc grains

[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',10*degree);

gB = [grains.boundary grains.innerBoundary] ;
gB_OPx = ebsd('e').calcGrains('angle',2*degree,'unitCell');

%% select grains
% plot(grains('e'),grains('e').meanOrientation)
% grain_xy= ginput; 
% % close on those grains you want to select, hit ENTER when done
% selected_grains = grains(findByLocation(grains,grain_xy));
% 
% gbgrains = ebsd(selected_grains).calcGrains('angle',2*degree,'unitCell')
% 
% plot(ebsd(selected_grains),ebsd(selected_grains).orientations);

figure
plot(ebsd('e'),ebsd('e').mis2mean.angle ./ degree, 'FaceAlpha',0.7)
hold on
plot(gB_OPx.boundary,'linewidth',2);
plot(gB_OPx.innerBoundary,'lineColor','r','linewidth',2);
mtexColorbar
hold off

%% plot IPF maps

cs = ebsd('e').CS;
ori = ebsd('e').orientations;
om = ipfHSVKey(cs,cs);
ipfKey = ipfColorKey(grains('e'));
ipfKey.inversePoleFigureDirection = xvector;
col = ipfKey.orientation2color(ebsd('e').orientations); % here's the nx3 color vector

plot(om)
[~,mP]= plot(ebsd,ebsd.bc,'Facealpha',0.75)
colormap gray
hold on
plot(ebsd('e'),col,'Facealpha',0.85) 
hold on
plot(gB_OPx.boundary,'linewidth',1);
% hold on
% plot(gB_OPx.innerBoundary,'lineColor','r','linewidth',2);
mP.micronBar.visible = 'off'
hold off

%% PFs

h = [Miller(1,0,0,'hkl',ebsd('e').CS),Miller(0,1,0,'hkl',ebsd('e').CS),Miller(0,0,1,'hkl',ebsd('e').CS)];
figure
plotPDF(ori,col,h,'antipodal','MarkerSize',6)

%% contoured PFs
OPx_odf = calcODF(ori,'halfwidth',10.0*degree)
Max_density_of_odf = max(OPx_odf);
figure
plotPDF(OPx_odf,h,'contourf','antipodal')
mtexColorbar('title','mrd');
mtexColorMap white2black;

%% rotation axes
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',2*degree);
grains=grains('e')
gB_OPx=[grains.innerBoundary('e', 'e'); grains.boundary('e', 'e')];

ori_axis = ebsd(gB_OPx.ebsdId).orientations;

Opx_ax = axis(ori_axis(:,1),ori_axis(:,2));

cond= gB_OPx.misorientation.angle/degree <10 & gB_OPx.misorientation.angle/degree >2; 
figure
plot(Opx_ax(cond),'antipodal','contourf')
mtexColorMap white2black;
mtexColorbar


