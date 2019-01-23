clear all

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
pname = 'C:\Users\zv211\OneDrive - University Of Cambridge\Documents\Bushveld\Critical Zone\UG\EBSD\ctf';

% which files to be imported
fname = [pname '\UG2-5 LAM_NR.ctf'];
%%
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');

%% calc grains

[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',10*degree);

gB = [grains.boundary grains.innerBoundary] ;
gB_Chr = ebsd('c').calcGrains('angle',2*degree,'unitCell');

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
plot(ebsd('c'),ebsd('c').mis2mean.angle ./ degree, 'FaceAlpha',0.7)
hold on
plot(gB_Chr.boundary,'linewidth',2);
plot(gB_Chr.innerBoundary,'lineColor','r','linewidth',2);
mtexColorbar
hold off

%% plot IPF maps

cs = ebsd('c').CS;
ori = ebsd('c').orientations;
om = ipfHSVKey(cs,cs);
plot(om)
ipfKey = ipfColorKey(grains('c'));
ipfKey.inversePoleFigureDirection = xvector;
col = ipfKey.orientation2color(ebsd('c').orientations); % here's the nx3 color vector


[~,mP]= plot(ebsd,ebsd.bc,'Facealpha',0.75)
colormap gray
hold on
plot(ebsd('c'),col,'Facealpha',0.75) 
hold on
plot(gB_Chr.boundary,'linewidth',1);
%plot(gB_Chr.innerBoundary,'lineColor','r','linewidth',2);
mP.micronBar.visible = 'off'
hold off

%% PFs

h = [Miller(1,0,0,'hkl',ebsd('c').CS),Miller(1,1,0,'hkl',ebsd('c').CS),Miller(1,1,1,'hkl',ebsd('c').CS)];
figure
plotPDF(ori,col,h,'antipodal','MarkerSize',6)

%% contoured PFs
Chr_odf = calcODF(ori,'halfwidth',10.0*degree)
Max_density_of_odf = max(Chr_odf);
figure
plotPDF(Chr_odf,h,'contourf','antipodal')
mtexColorbar('title','mrd');
mtexColorMap white2black;

%% rotation axes
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',2*degree);
grains=grains('c')
gB_Chr=[grains.innerBoundary('c', 'c'); grains.boundary('c', 'c')];

ori_axis = ebsd(gB_Chr.ebsdId).orientations;

Chr_ax = axis(ori_axis(:,1),ori_axis(:,2));

cond= gB_Chr.misorientation.angle/degree <10 & gB_Chr.misorientation.angle/degree >2; 
figure
plot(Chr_ax(cond),'antipodal','contourf')
mtexColorMap white2black;
mtexColorbar


