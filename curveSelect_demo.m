clc
close all
clear

%% Create a 3D lines plot
t = 0:pi/50:10*pi;

Ratio = [0.5:0.1:1.5];
[st,Rt] = meshgrid(sin(t),Ratio);
s = st.*Rt;
[ct,Rt] = meshgrid(cos(t),Ratio);
c = ct.*Rt;
T = repmat(t,[11,1]);
figure,
plot3(s',c',T');

%% Run curveSelect.m

curveSelect3D;

%% Guide
% 1) Make sure the figure is not in rotating/magnifying/panning mode
% 2) Now hit any button except 'T' on keyboard
% 3) Use the pointer the select a curve and see how it is highlighted
% 4) Now hit 'T' on keyboard to toggle off/on other curves.