%% Lab E Panorama stiching
l5path = '/site/edu/bb/Bildsensorer/E-Panorama/'
addpath('/site/edu/bb/Bildsensorer/E-Panorama/images1/')
addpath('/site/edu/bb/Bildsensorer/E-Panorama/util/')


%% 2. Image rectification


% ANSWER: There are 24 images of 360 degree --> 15 degree differance
% between each image



img1=imread('img01.jpg');


img_distortion1 = image_lensdist_inv('atan', img1, 0.001);
img_distortion2 = image_lensdist_inv('atan', img1, 0.0001);
img_distortion3 = image_lensdist_inv('atan', img1, 0.0003);

figure(1)
subplot(2, 2, 1)
imshow(img1)
title('Original image')
subplot(2, 2, 2)
imshow(img_distortion1)
title('Distortion gamma = 0.001')
subplot(2, 2, 3)
imshow(img_distortion2)
title('Distortion gamma = 0.0001')
subplot(2, 2, 4)
imshow(img_distortion3)
title('Distortion gamma = 0.0004')

% ANSWER: The image with gamma of 0.0003 give a good result. Just do trial
% and error, no mathematics for estimating gammma.

%% 3 Uncalibrated Stitching
img2=imread('img02.jpg');

img1 = img_distortion3;
img2 = image_lensdist_inv('atan', img2, 0.0003);



[x1,x2]=correspondences_select(img1,img2);
save corresp1to2.mat x1 x2



% ANSWER: The minimum number of points are 4. If adding more points the
% homographis will be better.

%%

H12=homography_stls(x1,x2);
x2_new = map_points(H12,x1);


% ANSWER: YES, it matters they should be spread out and in the image.


% ANSWER: There is five points so that we can print lines betwen all of the
% four pionts. The first and the last points are the same.

[rows,cols,ndim]=size(img1);
imbox=[1 cols cols 1 1;1 1 rows rows 1];


imbox12 = map_points(H12,imbox);
figure(2);imshow(img2); hold on
plot(imbox12(1,:),imbox12(2,:),'g')
axis image

[rows,cols,ndim]=size(img2);
imbox=[1 cols cols 1 1;1 1 rows rows 1];


imbox21 = map_points(inv(H12),imbox);
figure(3);imshow(img1); hold on
plot(imbox21(1,:),imbox21(2,:),'g')
axis image

%%

cl=[imbox imbox12];
cmin=floor(min(cl,[],2));
cmax=ceil(max(cl,[],2));
rows=cmax(2)-cmin(2);
cols=cmax(1)-cmin(1);

Ht=[1 0 1-cmin(1);0 1 1-cmin(2);0 0 1];


pano1=image_resample(img1,Ht*H12,rows,cols);
pano2=image_resample(img2,Ht,rows,cols);

alpha0=ones(size(img1(:,:,1)),'uint8')*255;
alpha1=image_resample(alpha0,Ht*H12,rows,cols);
alpha2=image_resample(alpha0,Ht,rows,cols);

pano=zeros(rows,cols,3,'int32');
asum=int32(alpha1)+int32(alpha2);
asum(asum==0)=1;

%%
for k=1:3,
    pano(:,:,k)=pano(:,:,k)+int32(pano1(:,:,k)).*int32(alpha1);
    pano(:,:,k)=pano(:,:,k)+int32(pano2(:,:,k)).*int32(alpha2);
    pano(:,:,k)=pano(:,:,k)./asum;
end

figure(4)
imshow(uint8(pano))



%% 4 Stitching in Spherical Coordinates

rows = 1200;
cols = 1600; 

K = [1420 -3 808;
    0 1420 605;
    0 0 1];

fovR = 2*atan(rows/2/K(2,2));
fovC = 2*atan(cols/2/K(1,1));

fovR_deg = fovR*180/pi;
fovC_deg = fovC*180/pi;

vfov = fovR;
hfov = fovC;

% ANSWEAR: field of view for Rows is 22,9058 degres/0.3998 rad and for 
%          Cols it's 29.3961 degres/0.5131 rad!

hoff = atan((cols/2-808)/K(1,1));
voff = atan((rows/2-605)/K(2,2));



hr=hfov/2*[-1.8 1.8]+hoff;
vr=vfov/2*[-1.1 1.1]+voff;

sample_density = 0.05;


%% Ta ut punkter mellan bilder


img3=imread('img03.jpg');

img3_rect = image_lensdist_inv('atan', img3, 0.0003);



[x22,x32]=correspondences_select(img2,img3);
save corresp2to3.mat x22 x32



%%
% -----------------------------------------------------
% Blend all images in the spherical coordinate system.
% -----------------------------------------------------

p1 = map_points(inv(K), x1);
p2 = map_points(inv(K), x2);
p22 = map_points(inv(K), x22);
p32 = map_points(inv(K), x32);

R12 = procrustes(p1, p2);
R23 = procrustes(p22, p32);


H12 = K*R12*inv(K);
H23 = K*R23*inv(K);

p2_new = map_points(H12,p1);

%% Test Hur kolla om detta är rimligt??

[Vtest Dtest] = eig(R12);
tr = acos((trace(R12)-1)/2)*180/pi; % Detta ger ca 15 grader. Alltså är R12 rimlig

%%
astep = 0.05 * pi/180;

pano1=image_resample_sphere(img1,K,inv(R12),hr,vr,astep);
pano2=image_resample_sphere(img2,K,eye(3),hr,vr,astep); % Mittenbilden
pano3=image_resample_sphere(img3,K,R23,hr,vr,astep);

alpha0=ones(size(img1(:,:,1)),'uint8')*255;
alpha1=image_resample_sphere(alpha0,K,inv(R12),hr,vr,astep);
alpha2=image_resample_sphere(alpha0,K,eye(3),hr,vr,astep);
alpha3=image_resample_sphere(alpha0,K,R23,hr,vr,astep);


pano=zeros(1008,2117,3,'int32');
asum=int32(alpha1)+int32(alpha2)+int32(alpha3);
asum(asum==0)=1;

%%
for k=1:3,
    pano(:,:,k)=pano(:,:,k)+int32(pano1(:,:,k)).*int32(alpha1);
    pano(:,:,k)=pano(:,:,k)+int32(pano2(:,:,k)).*int32(alpha2);
    pano(:,:,k)=pano(:,:,k)+int32(pano3(:,:,k)).*int32(alpha3);
    pano(:,:,k)=pano(:,:,k)./asum;
end



figure(5)
imshow(uint8(pano))



% ANSWER: This looks better. Sinee we map the images to something that's
% round which makes the edges fit better.


%% Gatuvyer

% Västerlånggatan 360 grader pan, ca 20 grader tilt

% Svart cirkel. Prauge 34 Gigapixels

% Det finns fler än 8 statyer




