% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('-1', [8.1732 12.8583 14.1703], [93.17,115.95,91.22]*degree, 'X||a*', 'Z||c', 'mineral', 'Anorthite', 'color', 'light blue'),...
  crystalSymmetry('-3m1', [5.1233 5.1233 13.7602], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Ilmenite', 'color', 'light green'),...
  crystalSymmetry('m-3m', [8.395 8.395 8.395], 'mineral', 'Magnetite', 'color', 'light red'),...
  crystalSymmetry('12/m1', [5.3771 9.3082 10.2832], [90,100.22,90]*degree, 'X||a*', 'Y||b*', 'Z||c', 'mineral', 'Biotite', 'color', 'cyan'),...
  crystalSymmetry('mmm', [4.756 10.207 5.98], 'mineral', 'Forsterite', 'color', 'magenta')};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

%% Specify File Names

% path to files
pname = '/Users/zack/Documents/Famatina/EBSD - Cambridge/mtex-zoja';

% which files to be imported
fname = [pname '/BK3_1-2 LAM_NR.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');


%% calc grains
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',8*degree);

gB = [grains.boundary grains.innerBoundary] ;
gB_Pl = ebsd('a').calcGrains('angle',2*degree,'unitCell');


figure
 
% plot(ebsd,ebsd.bc,'Facealpha',0.75)
% colormap gray
[~,mP]= plot(grains('a'),grains('a').aspectRatio,'colormap', pink,'Facealpha',0.75)
hold on
plot(gB_Pl.boundary,'linewidth',0.7);
mtexColorbar
CLim(gcm,[1 7])
mP.micronBar.visible = 'off'
hold off

%% pole figure

Pl_ori = ebsd('a').orientations
Pl_CS = ebsd('a').CS

h = [Miller(1,0,0,'uvw',ebsd('a').CS),Miller(0,1,0,'hkl',ebsd('a').CS),Miller(0,0,1,'hkl',ebsd('a').CS)];
figure
plotPDF(grains('a').meanOrientation,grains('a').aspectRatio,h,'antipodal','MarkerSize',6)
CLim(gcm,[1 7])
colormap pink
mtexColorbar

