%% Lab H TSBB09 Range camera
fpath='/site/edu/bb/Bildsensorer/H-RangeCamera/';
%% 4 Basic images from the range camera lab setup

% Pseudo range image handran
fp = fopen([fpath 'handran'],'r');
a = fscanf(fp,'%d',[500,256]); % image size:  500*256
figure(1)
imagesc(a);
axis image; colorbar;
colormap([(0:255)'/255,(0:255)'/255,(0:255)'/255])

imagesc(a,[0,100]);axis image;

% pseudo intensity image handint

fp = fopen([fpath 'handint'],'r');
b = fscanf(fp,'%d',[500,256]); % image size:  500*256
figure(2)
imagesc(b);
axis image; colorbar;
colormap([(0:255)'/255,(0:255)'/255,(0:255)'/255])

% Note that the strange values in the pseudo range image correspond to low
% values in the pseudo intensity image. 

%% 
% Combine a och b
T = 35;
figure(3);
c = a.*(b>T); % Varför inte bara sätta en treshold på a?
imagesc(c);
axis image; colorbar;
%colormap gray
rainbow = jet;
rainbow(1,:) = [0.5 0.5 0.5];
colormap(rainbow)

%% Musran

fp=fopen([fpath 'musran'],'r');
b = fscanf(fp,'%d',[250,256]); % image size:  250*256
figure(4);
imagesc(b);

% Sensor occlusion

fp = fopen([fpath 'wood'],'r');
g = fscanf(fp,'%d',[512,512]); % image size:  512*512
figure(5)
imagesc(g);

%%

g_tresh = g>250;
g_thin = bwmorph(g_tresh, 'thin', inf);
figure(5);
imagesc(g_thin);

% Kan detektera uncertain values genom att se i vilka columner där det inte
% finns något värde från lasern

%% 5 Calibration of the range camera lab setup


imagesc(calim)
%%
calibration

%%

imagesc(trapez)
u = [174 124 141 205];
v = [72 136 389 472];

trap = inv(C') * [v; u; ones(1,length(u))];
trap = [trap(1,:)./trap(3,:); trap(2,:)./trap(3,:); trap(3,:)./trap(3,:)];



%% 6 Measures with an industrial range camera

% Läsa läsa läsa

%% 6.5 Measuring tiny details

load('cardim.mat')
rangeim;

tick_divide = 3;
r = rangeim.range;
y = rangeim.x;
x = repmat(double(rangeim.prof_id)/tick_divide,[size(y,1) 1]);
imsz = size(r);
R1 = zeros([imsz 3]);
R1(:,:,1) = double(y);
R1(:,:,2) = double(x);
R1(:,:,3) = double(r);
cert = (r == 0);
R1c = repmat(cert,[1 1 3]);
R1(R1c) = NaN;


% x ger en matris med labelnummret hos varje dataset i y

mesh(R1(:,:,3)); axis equal

mesh(R1(:,:,1),R1(:,:,2),R1(:,:,3)); axis equal

figure(6);
imagesc(mesh(R1(:,:,1),R1(:,:,2),R1(:,:,3))); %axis([R1(1,1,1) R1(end,1,1) R1(1,1,2) R1(1,end,2)]) 
; axis equal


%% 6.6 Volume measurement of object

load vit_vaggkontakt
rangeim;

tick_divide = 4;
r = rangeim.range;
y = rangeim.x;
x = repmat(double(rangeim.prof_id)/tick_divide,[size(y,1) 1]);
imsz = size(r);
R1 = zeros([imsz 3]);
R1(:,:,1) = double(y);
R1(:,:,2) = double(x);
R1(:,:,3) = double(r);
cert = (r == 0);
R1c = repmat(cert,[1 1 3]);
R1(R1c) = NaN;


R2 = R1(401:700,201:700,:);
Intens = rangeim.intens(401:700,201:700);
figure(1)
meshc(R2(:,:,1),R2(:,:,2),R2(:,:,3))
figure(2)
subplot(2,2,1), imagesc(R2(:,:,1)), title('y image'); axis equal
subplot(2,2,2), imagesc(R2(:,:,2)), title('x image');axis equal
subplot(2,2,3), imagesc(R2(:,:,3)), title('r image');axis equal
subplot(2,2,4), imagesc(Intens(:,:)), title('i image');axis equal
figure(3)
subplot(2,2,1), plot(R2(:,320,1)), title('vert, y');axis equal
subplot(2,2,2), plot(R2(150,:,2)), title('horiz, x');axis equal
subplot(2,2,3), plot(R2(:,320,3)), title('vert, r');axis equal
subplot(2,2,4), plot(R2(150,:,3)), title('horiz, r');axis equal

%%
load('hus90.mat')

rangeim;
tick_divide = 4;
r = rangeim.range;
y = rangeim.x;
x = repmat(double(rangeim.prof_id)/tick_divide,[size(y,1) 1]);
imsz = size(r);
R1 = zeros([imsz 3]);
R1(:,:,1) = double(y);
R1(:,:,2) = double(x);
R1(:,:,3) = double(r);
cert = (r == 0);
R1c = repmat(cert,[1 1 3]);
R1(R1c) = NaN;


R2 = R1(401:700,201:700,:);
Intens = rangeim.intens(401:700,201:700);
figure(1)
meshc(R2(:,:,1),R2(:,:,2),R2(:,:,3))
figure(2)
subplot(2,2,1), imagesc(R2(:,:,1)), title('y image'); axis equal
subplot(2,2,2), imagesc(R2(:,:,2)), title('x image');axis equal
subplot(2,2,3), imagesc(R2(:,:,3)), title('r image');axis equal
subplot(2,2,4), imagesc(Intens(:,:)), title('i image');axis equal
figure(3)
subplot(2,2,1), plot(R2(:,320,1)), title('vert, y');axis equal
subplot(2,2,2), plot(R2(150,:,2)), title('horiz, x');axis equal
subplot(2,2,3), plot(R2(:,320,3)), title('vert, r');axis equal
subplot(2,2,4), plot(R2(150,:,3)), title('horiz, r');axis equal

%%

xScale = 0.23;
yScale = 0.41;
zScale = 0.0676;

A = R2(:,:,3);
B = R2(:,:,3);
A = (A>410);

AreaPix = sum(sum(A));
AreaMM = xScale*yScale*AreaPix;

Aobj=find(A==1);

R2diff = 0*R2(:,:,1);
R2diff(1:end-1,:) =diff(R2(:,:,1));

volumehus = nansum(nansum((R2(:,:,3)-401.5).*R2diff*(1/4.125).*(R2(:,:,3)>410)))
volume = sum((B(Aobj)-400)*yScale*xScale)

