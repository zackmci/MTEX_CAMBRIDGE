%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
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
pname = '/Users/zack/Documents/Famatina/EBSD - Cambridge/FA18-01B';

% which files to be imported
fname = [pname '/FA18-01B_LAM_NR.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');

[grains, ebsd.grainId] = calcGrains(ebsd,'angle',10*degree);
gB_An = grains.boundary('Anorthite','Anorthite');


%%
cs = ebsd('a').CS
rot = orientation('axis',Miller(0,1,0,cs),'angle',180*degree,cs, cs);
rot1 = orientation('axis',Miller(0,0,1,cs),'angle',180*degree,cs, cs);
% calculates the angle between two trotations - the misorientation and the twinning rotation 
ang_r = angle(gB_An.misorientation,rot);
% ang_r2 = angle(gB_An.misorientation,rot1);
% condition/index all angles below a certain threshold
ind = ang_r < 5.*degree;
% ind2 =ang_r2 <5.*degree;

%select the boundaries based on this condition                                                                        
twinBoundary = gB_An(ind);
% twinBoundary2 = gB_An(ind2);
% merge grains connected with that twin boundary
[grains_merged,parentID_grains]= merge(grains,twinBoundary);
% make a copy of the ebsd dataset
ebsd_merged = ebsd;


% update the grainIds to the parentIds, so each ebsd_merged pixel knows
% again to which grain it belongs to
ebsd_merged.grainId  = parentID_grains(ebsd.grainId);
%
% lets's see
figure
plot(ebsd('Anorthite'),ebsd('Anorthite').orientations,'faceAlpha',0.3)
hold on
plot(grains_merged('Anorthite').boundary,'linewidth',2)
hold on
plot(twinBoundary,'linecolor','r','linewidth',2)
%hold on
%plot(twinBoundary2,'linecolor','r','linewidth',2)
hold off

% plot(ebsd_merged,ebsd_merged.bc)
% mtexColorMap black2white

%%

odf_An = calcODF(grains('Anorthite').meanOrientation,'halfwidth',10*degree);
%textureindex(odf_An); 

[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',8*degree);

gB = [grains.boundary grains.innerBoundary] ;
gB_Pl = ebsd('a').calcGrains('angle',2*degree,'unitCell');


figure
[~,mP]= plot(grains_merged('a'),grains_merged('a').aspectRatio,'colormap', pink,'Facealpha',0.75)
hold on
plot(gB_Pl.boundary,'linewidth',0.7);
mtexColorbar
% CLim(gcm,[1 7])
mP.micronBar.visible = 'off'
hold off

%% pole figures

Pl_ori = ebsd('a').orientations
Pl_CS = ebsd('a').CS

h = [Miller(1,0,0,'uvw',ebsd('a').CS),Miller(0,1,0,'hkl',ebsd('a').CS),Miller(0,0,1,'hkl',ebsd('a').CS)];
figure
plotPDF(grains('a').orientation,grains('a').aspectRatio,h,'antipodal','MarkerSize',6)
CLim(gcm,[1 7])
colormap pink
mtexColorbar

