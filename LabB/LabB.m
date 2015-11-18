%% TSBB09 LabB
%% Part 1

part1script

% The plot looks like an exponential function
% When the emittance is 40 the tempature is 367 K

% By increasing (espacially the higher lambda) the wavelength limits the
% temperature range increases

%% Part 3

load Refdata1;
load Refdata2;
load Refdata3;
load Scenedata;


%% A-1

figure(2)
imagesc(Refdata1(:,:,1)); colormap(gray);
figure(3)
imagesc(Refdata1(:,:,2)); colormap(gray);
figure(4)
imagesc(Refdata1(:,:,3)); colormap(gray);

% The pixel noise seems to be randomly distributed over the array BUT not
% in the top right corner... So NO

%% A-2

plot([0.809 1.58 2.25],[mean2(Refdata1(:,:,1)) mean2(Refdata2(:,:,1)) mean2(Refdata3(:,:,3))])
axis([0 2.25 0 8000])

% The plot is linear but does not tend to zero. This is because of internal
% parameters

%% A-3

% Normal pixel
figure(1)
plot([Refdata1(266,139,1) Refdata2(266,139,1) Refdata3(266,139,1)], [mean2(Refdata1(:,:,1)) mean2(Refdata2(:,:,1)) mean2(Refdata3(:,:,3))] )

% Salt pixel
figure(2)
plot([Refdata1(121,168,1) Refdata2(121,168,1) Refdata3(121,168,1)], [mean2(Refdata1(:,:,1)) mean2(Refdata2(:,:,1)) mean2(Refdata3(:,:,3))])

% Peppar pixel
figure(3)
plot([Refdata1(110,163,1) Refdata2(110,163,1) Refdata3(110,163,1)], [mean2(Refdata1(:,:,1)) mean2(Refdata2(:,:,1)) mean2(Refdata3(:,:,3))])

% The normal pixel is has a linear plot, the white (max value) has a
% vertical plot and the dark (not completely black) is a bit cricket.

%% A-4 Plot single pixel values over time

time = (1:20);

% Normal pixel
pixeltimearraynormal = zeros(1,20);
for k = 1:20
    pixeltimearraynormal(k) = Refdata1(223,172,k);
end


figure(1)
plot(time, pixeltimearraynormal)

% Salt pixel
pixeltimearraysalt = zeros(1,20);
for k = 1:20
    pixeltimearraysalt(k) = Refdata1(121,168,k);
end

figure(2)
plot(time, pixeltimearraysalt)

% Peppar pixel
pixeltimearraypeppar = zeros(1,20);
for k = 1:20
    pixeltimearraypeppar(k) = Refdata1(180,232,k);
end

figure(3)
plot(time, pixeltimearraypeppar)

% The salt pixel is a horisontalline, hence there is no variance and this
% is a vcompletly dead pixel. The peppar pixel vary approximatly the as
% much as the normal pixel but at a lower value.

%% B-1 Plot raw data image

part3_B % part = B_1

%% B-2 NUC 1th order

part3_B % part = B_2, poly 1

%% B-2 NUC 2th order

part3_B % part = B_2, poly 2

% The 2th order polynomial do not have as many dead pixels

%% B-3 

% The higher order with NUC and dp repl is the best!

%% B-4

% When K = 100000 there wasn't that big differnece between the raw image
% and the last one. Musch better in B-3

%% B-5 

% ????

%% C-1a  Calculate 
%RMSE
% in an image from Scenedata, before and after NUC including 
%replacement of bad pixels. 



















