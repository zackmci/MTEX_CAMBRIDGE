close all
clear all
axis_ug211=load('axis_ug211');
axis_ug210=load('axis_ug210');
axis_ug208=load('axis_ug208');
axis_ug205=load('axis_ug205');
axis_ug202=load('axis_ug202');

combine_axis = [axis_ug211,...
                axis_ug210,...
                axis_ug208,...
                axis_ug202,...
                axis_ug205]
% combine_axis = [axis_ug211.axis_ug,...
%                 axis_ug210.axis_ug,...
%                 axis_ug208.axis_ug,...
%                 axis_ug202.axis_ug,...
%                 axis_ug205.axis_ug]


figure
plot(combine_axis.axis_ug, 'Fundamentalregion','antipodal', 'contourf');
hold on
plot(combine_axis, 'Fundamentalregion', 'Markersize',1)
hold off
mtexColorbar('mrd');

figure
hold on
plot(axis_ug208.axis_ug,'Fundamentalregion','antipodal','points','all', 'contourf');
hold on
plot(axis_ug205.axis_ug,'Fundamentalregion','antipodal','points','all', 'contourf');
hold on
plot(axis_ug202.axis_ug,'Fundamentalregion','antipodal','points','all', 'contourf');
hold on
plot(axis_ug210.axis_ug,'Fundamentalregion','antipodal','points', 'all','contourf');
hold on
plot(axis_ug211.axis_ug,'Fundamentalregion','antipodal','points','all', 'contourf');
hold off
mtexColorbar('mrd');

figure
hold on
plot(axis_ug208.axis_ug, 'Fundamentalregion', 'points','all','Markersize',1)
hold on
plot(axis_ug205.axis_ug, 'Fundamentalregion', 'points','all','Markersize',1)
hold on
plot(axis_ug202.axis_ug, 'Fundamentalregion', 'points','all','Markersize',1)
hold on
plot(axis_ug210.axis_ug, 'Fundamentalregion', 'points','all','Markersize',1)
hold on
plot(axis_ug211.axis_ug, 'Fundamentalregion', 'points','all','Markersize',1)
hold off