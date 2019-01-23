%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

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

[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',10*degree);

gB = [grains.boundary grains.innerBoundary] ;
gB_Pl = gB('a','a');

% %% select grains
% plot(grains('a'),grains('a').meanOrientation)
% grain_xy= ginput; 
% % close on those grains you want to select, hit ENTER when done
% selected_grains = grains(findByLocation(grains,grain_xy));

gbgrains = ebsd('a').calcGrains('angle',2*degree,'unitCell')
% Pl_gbgrains = ebsd('a').calcGrains('angle',2*degree,'unitCell')


plot(ebsd('a'),ebsd('a').orientations);

figure
plot(ebsd('Anorthite'),ebsd('Anorthite').mis2mean.angle ./ degree, 'FaceAlpha',0.7)
hold on
plot(grains('a').boundary,'linewidth',2);
plot(gbgrains.innerBoundary,'lineColor','r','linewidth',2);
mtexColorbar
hold off

figure
[~,mP]= plot(ebsd,ebsd.bc)
mtexColorMap black2white
hold on
plot(ebsd('a'),ebsd('a').mis2mean.angle ./ degree, 'FaceAlpha',0.7)
hold on
plot(gB_Pl,'linewidth',2);
plot(Pl_gbgrains.innerBoundary,'lineColor','r','linewidth',2);
mtexColorbar
mP.micronBar.visible = 'off'
hold off

%%


%% plot IPF maps

cs = ebsd('a').CS;
ori = ebsd('a').orientations;
om = ipfHSVKey(cs,cs);
col = om.orientation2color(ebsd('a').orientations); % here's the nx3 color vector

plot(om)
figure
[~,mP]= plot(ebsd,ebsd.bc,'Facealpha',0.75)
colormap gray
hold on
plot(ebsd('Anorthite'),col) 
hold on
plot(grains.boundary,'linewidth',1);
mP.micronBar.visible = 'on'
hold off



h = [Miller(1,0,0,'uvw',ebsd(grains('Anorthite')).CS),Miller(0,1,0,'hkl',ebsd(grains('Anorthite')).CS),Miller(0,0,1,'hkl',ebsd(grains('Anorthite')).CS)];
plotPDF(ori,col,h,'antipodal','MarkerSize',6)


