%% LabA 

%% Setup

addpath /site/edu/bb/Bildsensorer/A-DigitalCamera/
addpath /site/edu/bb/Bildsensorer/A-DigitalCamera/shadingcorr
addpath /site/edu/bb/Bildsensorer/A-DigitalCamera/bayer

shadcorr 

close all

%% 2.1 

%Question
% Gives a better linnear approximation in the spectrum which is the camera
% is more likely to be used in.

bA = darkimage;
bB = whiteimage;
b  = origimage;

fA = mean(mean(bA)); % 118,3710
fB = mean(mean(bB)); % 206,6197

c  =1./(bB-bA);
d  = (fA.*bB-fB.*bA)./(fB-fA);

f = c.*(b+d);

figure(1)
imagesc(f); axis image; axis off; colormap(jet);


%Question 
%no


