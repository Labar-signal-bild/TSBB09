%% Lab E Panorama stiching
l5path = '/site/edu/bb/Bildsensorer/E-Panorama/'
addpath('/site/edu/bb/Bildsensorer/E-Panorama/images1/')

%%
correspondences_select

homography_stls

image_lensdist_inv

image_resample

image_resample_sphere

%% 2. Image rectification


% ANSWER: There are 24 images of 360 degree --> 15 degree differance
% between each image



img1=imread('img01.jpg');


img_distortion1 = image_lensdist_inv('atan', img1, 0.001);
img_distortion2 = image_lensdist_inv('atan', img1, 0.0001);
img_distortion3 = image_lensdist_inv('atan', img1, 0.0003);

figure(1)
subplot(2, 2, 1)
imshow(im1)
title('Original image')
subplot(2, 2, 2)
imshow(img_distortion1)
title('Distortion gamma = 0.001')
subplot(2, 2, 3)
imshow(img_distortion2)
title('Distortion gamma = 0.0001')
subplot(2, 2, 4)
imshow(img_distortion3)
title('Distortion gamma = 0.0003')

% ANSWER: The image with gamma of 0.0003 give a good result. Just do trial
% and error, no mathematics for estimating gammma.

%% 3 Uncalibrated Stitching
img2=imread('img02.jpg');

img1_rect = img_distortion3;
img2_rect = image_lensdist_inv('atan', img2, 0.0003);



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



hr=hfov/2*[-1.8 1.8]+hoff;
vr=vfov/2*[-1.1 1.1]+voff;

%%




K = [1420 -3 808;
    0 1420 605;
    0 0 1];

fovR = atan(rows/2/K(2,2));
fovC = atan(cols/2/K(1,1));

fovR_deg = fovR*180/pi;
fovC_deg = fovC*180/pi;

hfov = fovR;
vfov = fovC;

% ANSWEAR: field of view for Rows is 26,6779 degres/0.4656 rad and for 
%          Cols it's 37.1401 degres/0.6482 rad!

hoff = atan((cols/2-808)*K(1,1));
voff = atan((rows/2-605)*K(1,1));



hr=hfov/2*[-1.8 1.8]+hoff;
vr=vfov/2*[-1.1 1.1]+voff;

































