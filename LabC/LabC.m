%% Lab C

%Laod image
figure(1)
bild = imread('http://cvl-cam-01.edu.isy.liu.se/jpg/image.jpg');
imagesc(bild); axis image;

%% The vector c 

c = pinv(D)*f;
%% and the matrix C
c = [c; 1];
C = (reshape (c, 3, 3))';


%% Check if the matrix C seems correct

test = C * [5 5 1]';
u5new = test(1) / test(3);
v5new = test(2) / test(3);

%% Calculate X, Y

ua = 88;
va = 78;
ub = 165;
vb = 116;

XaYas = inv(C)*[ua va 1]';
XbYbs = inv(C)*[ub vb 1]';

Xa = XaYas(1)/XaYas(3);
Ya = XaYas(2)/XaYas(3);
Xb = XbYbs(1)/XbYbs(3);
Yb = XbYbs(2)/XbYbs(3);

length = norm([Xa;Ya] - [Xb;Yb]); %length = 4.9829
% The real length is 5.1 mm, it is pretty close. The calculated length is
% done from an approximation of the world coordinate system


%% New A, R, t matrixes from lab

A = 1*10^3 * [1.2802 -0.0018 0.1900;
              0 1.1624 0.1427;
              0 0 0.0010];
          
R = [0.8536 0.5197 -0.0218;
     -0.5207 0.8535 -0.0038;
     0.0167 0.0146 0.9991];

t = [-7.2953; -20.3780; 848.6513];


 
Az = 1*10^3 * [2.1034 -0.0032 0.2277;
              0 1.9057 0.1571;
              0 0 0];
          
Rz = [0.8506 0.5216 -0.0476;
     -0.5240 0.8525  0.0071;
      0.0443 0.0188 0.9984];

tz = [-31.8230; -21.2461; 893.2176];


%% pixeldiff 

pixeldiff = (2.1034*1.9057)/(1.2802*1.1625); % 2.69. Alltså varje pixel är 2,69 ggr större.

%% Distances

dist1 = norm(t);
dist2 = norm(tz);
% Not the same

%% Rotation

rot1 = acos(R(1));
rot2 = acos(Rz(1));
% Almost the same

%% pixel dist in x- y- direction

pixelxy1 = (2.1034/1.9057);
pixelxy2 = (1.2802/1.1625);
%Almost the same


%% 2.5

uv = inv(A)*[0; 0; 1];

thetau = atan(uv(1));
thetav = atan(uv(2));

thetauDegree = thetau*180/pi;
thetavDegree = thetav*180/pi;


%% 2.6 

C = A*[R t];


[A, R, t] = P2KRt(C)












