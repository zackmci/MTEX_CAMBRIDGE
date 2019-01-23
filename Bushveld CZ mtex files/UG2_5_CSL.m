%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

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

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');

plot(ebsd,ebsd.prop.bc);

%% calc grains
[grains, ebsd.grainId, ebsd.mis2mean] = calcGrains(ebsd,'angle',5*degree)

%% twin boundaries
cs = CS{5};
gbc = grains.boundary('c','c');
sigma =3:2:27;
for i = 1:length(sigma)
csl = CSL(sigma(i),cs);
if length(csl) == 1
 l(i) = sum(gbc(angle(gbc.misorientation,csl)<sqrt(sigma(i))*5*degree).segLength)
else
    clear ltempj
    for j =1:length(csl)
        ltempj(j) = sum(gbc(angle(gbc.misorientation,csl(j))<sqrt(sigma(i))*10*degree).segLength)
    end
    l(i) = sum(ltempj)
end
end



%% plot 
mori = gbc.misorientation
fR = fundamentalRegion(cs,cs,'antipodal')
plot(fR)
hold on
plot(mori.project2FundamentalRegion('antipodal'),'all')
hold off
% 
% k = kmeans
% k.n = 5
% [label, center] = doClustering(k,mori.project2FundamentalRegion('antipodal'))
%% plotting csl boundaries on the map

tbR = { CSL(3,cs) ;...
        CSL(5,cs); ...
        CSL(7,cs); ...
        CSL(9,cs); ...
        CSL(11,cs)}

col = {[1 0 0] [0 1 0] [0 0 1] [1 0.3 1] [0.5 1 0]}
bd = [3 5 7 9 11]


for i = 1: length(tbR)
    plot(ebsd,ebsd.prop.bc)
    mtexColorMap black2white
    hold on
    plot(gbc (angle(tbR{i},gbc.misorientation,'antipodal')<10/sqrt(bd(i))*degree),'lineColor',col{i},'linewidth',2)
    hold off
    mtexTitle(['axis ' char(round(tbR{i}.axis),'latex') ' angle ' num2str(tbR{i}.angle/degree)])
    saveFigure(['name_CSL_' num2str(bd(i)) '.png'])
end



% number of grain boundary(segments) having some condition - LENGHT OF THE
% TWIN BOUNDARY

sum(angle(gbc.misorientation.axis, Miller(1,1,1,cs))<10/sqrt(3)*degree)
sum(angle(gbc.misorientation, tbR{1})<10/sqrt(3)*degree)

% grains fulfilling special condition
gbcC = gbc(angle(gbc.misorientation, tbR{1})<10/sqrt(3)*degree)
% unique grains id pairs of grains which are connected across a special
% boundary
% maybe ..
gid1  = gbcC.grainId;
ug = unique(gid1,'rows')
% gid2 = [gid1(:,2) gid1(:,1)] % switch rows because I do not know better
% ug = [unique(gid1,'rows'); unique(gid2,'rows')]


g1  = grains('id',ug(:,1));
g2  = grains('id',ug(:,2));


% test
figure
[~,mP] = plot(ebsd,ebsd.prop.bc);
colormap gray
hold on
[~,mP] = plot(g1,'FaceColor',[1 0 0]);
hold on
[~,mP] = plot(g2,'FaceColor',[0 0 1]);
hold on
[~,mP] = plot(gbcC,'lineColor',[0 1 0.3], 'linewidth',1);
hold off
mP.micronBar.visible = 'off';
%% grain size around 111
figure
plot(g1.equivalentRadius, g2.equivalentRadius,'ok',...
    'MarkerFaceColor',[0.1,0.5,1]);
hold on
xlabel('ECD (micrometer)') 
hold on
ylabel('ECD (micrometer)') 
hold on 
title('Grain size of the neigbouring grains [111] axis')
hold off

%% ordered prooperly
grain1=g1.equivalentRadius
grain2=g2.equivalentRadius
plot(grain1, grain2, 'ok')
finalpair=[];
big=[];
small=[];
for i=1:length(grain1)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    pair = [finalpair; grain1(i) grain2(i)]
    big=[big; max(pair)]
    small=[small; min(pair)]
end
figure
subplot(1,2,1)
plot(big, small, 'ok')
subplot(1,2,2)
plot(grain1, grain2, 'ok')


