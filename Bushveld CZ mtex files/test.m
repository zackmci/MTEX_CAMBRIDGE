close all
clear all
axis_ug211=load('axis_ug211');
axis_ug210=load('axis_ug210');
axis_ug208=load('axis_ug208');
axis_ug205=load('axis_ug205');
axis_ug202=load('axis_ug202');

combinedAXIS=['axis_ug211', 'axis_ug210','axis_ug205','axis_ug208','axis_ug202'];

plot(combinedAXIS,'Fundamentalregion','antipodal', 'contourf');
hold on
plot(combinedAXIS, 'Fundamentalregion', 'Markersize', 1, 'Markercolor','black', 'FaceAlpha', 0.7);
hold off