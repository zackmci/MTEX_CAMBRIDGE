clear all

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

ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');


%% calc grains

[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',10*degree);

gB = [grains.boundary grains.innerBoundary] ;

%%

figure
plot(ebsd('Anorthite'),ebsd('Anorthite').mis2mean.angle ./ degree, 'FaceAlpha',0.7)
hold on
plot(grains.boundary,'linewidth',1);
mtexColorbar
hold off

%% plot IPF maps

cs = ebsd('Anorthite').CS;
ori = ebsd('Anorthite').orientations;
om = ipfHSVKey(cs,cs);
col = om.orientation2color(ebsd('Anorthite').orientations); % here's the nx3 color vector

figure
[~,mP]= plot(ebsd,ebsd.bc,'Facealpha',0.75)
colormap gray
hold on
plot(ebsd('Anorthite'),col) 
hold on
plot(grains.boundary,'linewidth',1);
mP.micronBar.visible = 'off'
hold off


h = [Miller(1,0,0,'uvw',ebsd('Anorthite').CS),Miller(0,1,0,'hkl',ebsd('Anorthite').CS),Miller(0,0,1,'hkl',ebsd('Anorthite').CS)];
figure
plotPDF(ori,col,h,'antipodal','MarkerSize',6)


%% contoured PFs
Pl_odf = calcODF(ori,'halfwidth',10.0*degree)
Max_density_of_odf = max(Pl_odf);
figure
plotPDF(Pl_odf,h,'contourf','antipodal')
mtexColorbar('title','mrd');
mtexColorMap white2black;

%% rotation axes
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',2*degree);
grains=grains('a')
gB_Pl=[grains.innerBoundary('a', 'a'); grains.boundary('a', 'a')];

ori_axis = ebsd(gB_Pl.ebsdId).orientations;

Pl_ax = axis(ori_axis(:,1),ori_axis(:,2));

cond= gB_Pl.misorientation.angle/degree <10 & gB_Pl.misorientation.angle/degree >2; 
figure
plot(Pl_ax(cond),'antipodal','contourf')
mtexColorMap white2black;
mtexColorbar
