clear all 
close all


%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('mmm', [4.762 10.225 5.994], 'mineral', 'Forsterite', 'color', 'light blue'),...
  crystalSymmetry('m-3m', [8.358 8.358 8.358], 'mineral', 'Chromite', 'color', 'light green')};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

%% Specify File Names

% path to files
pname = 'C:\Users\zv211\Documents\Bushveld\Critical Zone\mtex files';

%\Kil_2_L2_308.ctf  \Ulubigolivines_159.ctf
% which files to be imported
fname = [pname '\Kil_2_L3_424.ctf'];
b=10
c=0.16
K=1
d=3.8
N=1
%% Import the Data
%From https://mtex-toolbox.github.io/files/doc/GrainReconstructionDemo.html
% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');
ebsd.unitCell = ebsd.unitCell * 1.01;
%Kuwahara filter applied to smooth it out. 2 passes works very well.


%First pass at grain ID -code runs quicker if use this rather than FMC. 
 
 min_points=3
[grains, ebsd.grainId, ebsd.mis2mean]= calcGrains(ebsd,'angle',b*degree)
ebsd(grains(grains.grainSize<20)).phase=0 

%%
%grains=grains(grains.grainSize > min_points)
%EnterFilter

if K==1
F = KuwaharaFilter;
F.numNeighbours = 5;
ebsd = smooth(ebsd, F)
end

ebsd01 = ebsd(grains('indexed'));

if N==1
[grains,ebsd01.grainId,ebsd01.mis2mean]= calcGrains(ebsd01('indexed'),'angle',c*degree)
grains = smooth(grains);
end
if N==2
ebsd=ebsd('Forsterite')
grains = calcGrains(ebsd,'FMC', d)
grains = smooth(grains, 7);

end

figure(1)
plot(ebsd('Fo'),ebsd('Fo').mis2mean.angle./degree)
hold on
plot(grains.boundary)
hold on
caxis([0 5])
mtexColorbar
disp(' ') 
disp('Select grain with cursor and one mouse click')
disp(' ')
[x1, y1]=ginput(1) 
plot(x1,y1, 'ok', 'MarkerSize', 1, 'MarkerFaceColor', 'k')
disp(' ') 
disp('Select grain with cursor and one mouse click')
disp(' ')
[x2, y2]=ginput(1)
plot(x2,y2, 'ok', 'MarkerSize', 1, 'MarkerFaceColor', 'k')
disp(' ') 
disp('Select grain with cursor and one mouse click')
disp(' ')
[x3, y3]=ginput(1)
plot(x3,y3, 'ok', 'MarkerSize', 1, 'MarkerFaceColor', 'k')
disp(' ') 
disp('Select grain with cursor and one mouse click')
disp(' ')
[x4, y4]=ginput(1)
plot(x4,y4, 'ok', 'MarkerSize', 1, 'MarkerFaceColor', 'k')

ind = inpolygon(ebsd,[x1 y1; x2 y2; x3 y3; x4 y4])
ebsd = ebsd(ind)

ebsd8=ebsd('Fo')% 
if N==1
f=c+0.03
[grains2,ebsd.grainId,ebsd.mis2mean]= calcGrains(ebsd8('Fo'),'angle',f*degree)
grains=smooth(grains2, 4)
end
if N==2
grains2 = calcGrains(ebsd8('Fo'),'FMC', d)
grains=smooth(grains2)
end


%% Figure
minpoints=3
grains=grains(grains.grainSize > min_points)
plot(grains('fo'),grains('fo').mis2mean.angle./degree,'micronbar','off','figSize','large')
hold off
%gB=grains.boundary('Fo', 'Fo')
% plot(grains.boundary,'linewidth',1,'color','red')

% gB = grains(grains.grainSize > min_points).boundary('Fo','Fo');
% plot(gB, 'linewidth',1,'color','red')
ori = ebsd(gB.ebsdId).orientations;
gB_axes = axis(ori(:,1),ori(:,2));
%quiver(gB,gB_axes,'linewidth',1,'color','green','autoScaleFactor',0.5)

% Plotting Vectors on stereonet sample ref frame: https://mtex-toolbox.github.io/files/doc/CrystalDirections.html
figure(12)
setMTEXpref('xAxisDirection','east');
setMTEXpref('yAxisDirection','north');
misor=inv(ori(:,1)).*ori(:,2)
cs = ebsd('Fo').CS
%v is the range of grain boundary traces. 
v=vector3d(gB.direction)
GBD=mean(v)
GBD2=-mean(v)
%S = mean of rotation axes
ROT=mean(gB_axes)
%n is perp to rotation axis and grain boundary trace. Slip direction in
%tilt and twist. 
n=cross(ROT,v)
nm=cross(ROT,GBD)
%dot product
%in the following way:
a = atan2d(norm(cross(ROT,GBD)),dot(ROT,GBD)); % Angle in
da=grains('Fo').meanOrientation * Miller(1,0,0,grains('Fo').CS);
d100=vector3d(da)
db=grains('Fo').meanOrientation * Miller(0,1,0,grains('Fo').CS);
d010=vector3d(db)
dc=grains('Fo').meanOrientation * Miller(0,0,1,grains('Fo').CS);
d001=vector3d(dc)
% d2=Miller(0,1,0, cs, 'antipodal')
% plane010=vector3d(d2)
% d3=Miller(0,0,1, cs, 'antipodal')
% plane001=vector3d(d3)

plot(GBD, 'MarkerSize',10,'MarkerEdgeColor','black','MarkerFaceColor','yellow', 'antipodal')
hold on
plot(GBD2, 'MarkerSize',10,'MarkerEdgeColor','black','MarkerFaceColor','yellow', 'antipodal')
%contour plot is of rotation axis
plot(gB_axes, 'MarkerSize',3,'MarkerEdgeColor','k','MarkerFaceColor','red', 'antipodal')
plot(gB_axes, 'contourf', 'antipodal')
plot(nm, 'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','black', 'antipodal')
%S is mean rotation axis
plot(ROT, 'MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','red', 'antipodal')
plot(gB_axes, 'plane', 'linecolor', 'red','linewidth',0.1, 'antipodal')
plot(ROT, 'plane', 'linecolor', 'red','linewidth',3, 'antipodal')
circle(n,'linecolor', 'yellow','linewidth', 0.1)
circle(nm,'linecolor', 'yellow','linewidth', 3)
plot(d100, 'MarkerSize',10,'MarkerEdgeColor','black','MarkerFaceColor','green')
plot(d010, 'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','blue')
plot(d001, 'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','red')
% circle(d010,'linecolor', 'cyan','linewidth', 3)
% circle(d001,'linecolor', 'magenta','linewidth', 3)
% circle(plane010,'linecolor', 'green','linewidth', 3)
annotate(zvector,'label',{'Z'},'BackgroundColor','w')
annotate(xvector,'label',{'X'},'BackgroundColor','w')
annotate(yvector,'label',{'Y'},'BackgroundColor','w')
title('Misorientation axis sample ref frame')
% %%
% figure(18)
% plot(gB_axes, 'contourf', 'antipodal')
%
figure(11)
bnd_FoFo = grains((grains.grainSize > min_points)).boundary('Fo','Fo')
I=bnd_FoFo.misorientation.angle./degree
mtexFig = newMtexFigure;
plotAxisDistribution(bnd_FoFo.misorientation,'smooth','parent',mtexFig.gca)
mtexTitle('boundary axis distribution')
mtexColorbar

%
for t=atan2d(norm(cross(ROT,GBD)),dot(ROT,GBD)) % Angle in
    if t<80
        disp('Unlikely twist, as angle less than 80')
       anglebetweenRotandGBD=t
    end
    if t>80
       disp('Could be twist or tilt')
      
    end 
end
