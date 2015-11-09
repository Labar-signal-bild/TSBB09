%% LabA 

%% Setup

addpath /site/edu/bb/Bildsensorer/A-DigitalCamera/
addpath /site/edu/bb/Bildsensorer/A-DigitalCamera/shadingcorr
addpath /site/edu/bb/Bildsensorer/A-DigitalCamera/bayer

shadcorr 



%% 2.1 

%ANSWER:
% Gives a better linnear approximation in the spectrum which is the camera
% is more likely to be used in.

bB = double(darkimage);
bA = double(whiteimage);
b  = double(origimage);

%ANSWER: fA = 118,3710, fB = 206,6197

f1 = shadecorr(bA, bB, b);

figure(1)
imshow(f1/255); axis image; axis off; colormap(jet);



%ANSWER: Yes 

%% Black imange and white image

bB = blackimage;

f2 = shadecorr(bA, bB, b);

figure(1)
subplot(2, 1, 1)
imagesc(b); axis image; axis off; colormap(jet);
subplot(2, 1, 2)
imagesc(f2); axis image; axis off; colormap(jet);

%ANSWER: The image is not noisier then the original image

%ANSWER: To get a more acurate model of the shade correction for the camera


%%

im = imread('interlaced_image.png');

im = im2double(im);

figure(2)
imshow(im);

%ANSWER: The hand is moving and there's also a shadow from the hand. It's
%moving in vertical direction either up or down. 

%%

[rows,cols,ndim]=size(im);
mask1=zeros(rows,cols);
mask1(1:2:end,:)=1;
mask2=zeros(rows,cols);
mask2(2:2:end,:)=1;

im1 = im.*repmat(mask1,[1 1 3]);
im2 = im.*repmat(mask2,[1 1 3]);

figure(3)
imshow(im1);
figure(4)
imshow(im2);

%ANSWER: The motion is easeier to see but we can still not say in which
%direction the hand is moving

%% Fill in the black rows with interpolation

f=[1 2 1]'/2;

%ANSWER: Since we just have half of the oimage we want to have it brighter


im1 = zeros(size(im));
im2 = zeros(size(im));
for k=1:3,
    bk=im(:,:,k);
    a = conv2(f,bk.*repmat(mask1,[1 1]));
    b = conv2(f,bk.*repmat(mask2,[1 1]));
    im1(:,:,k) = a(2:577,:);
    im2(:,:,k) = b(2:577,:); 
end

figure(5)
imshow(im1);
figure(6)
imshow(im2);

%ANSWER: The convolved image is a bit more smuged, but just a bit

%% BAYER GBRG

im = imread('bayer/raw0001.png');
im = im2double(im);

imshow(im);
[rows,cols] = size(im); 


mask1=zeros(rows,cols);
mask1(2:2:end,1:2:end) = 1;
mask2=zeros(rows,cols);
mask2(1:2:end,1:2:end) = 1;
mask2(2:2:end,2:2:end) = 1;
mask3=zeros(rows,cols);
mask3(1:2:end,2:2:end) = 1;


im_rgb=reshape([im.*mask1 im.*mask2 im.*mask3],[size(im) 3]);

imshow(im_rgb);

%% BAYER GRBG

mask1=zeros(rows,cols);
mask1(1:2:end,2:2:end) = 1;
mask2=zeros(rows,cols);
mask2(1:2:end,1:2:end) = 1;
mask2(2:2:end,2:2:end) = 1;
mask3=zeros(rows,cols);
mask3(2:2:end,1:2:end) = 1;

im_rgb=reshape([im.*mask1 im.*mask2 im.*mask3],[size(im) 3]);
imshow(im_rgb);


%% BAYER BGGR

mask1=zeros(rows,cols);
mask1(2:2:end,2:2:end) = 1;
mask2=zeros(rows,cols);
mask2(1:2:end,2:2:end) = 1;
mask2(2:2:end,1:2:end) = 1;
mask3=zeros(rows,cols);
mask3(1:2:end,1:2:end) = 1;

im_rgb=reshape([im.*mask1 im.*mask2 im.*mask3],[size(im) 3]);
imshow(im_rgb);

%ANSWER: THIS ONE LOOKS CORRECT


%% BAYER RGGB


mask1=zeros(rows,cols);
mask1(1:2:end,1:2:end)= 1;
mask2=zeros(rows,cols);
mask2(1:2:end,2:2:end) = 1;
mask2(2:2:end,1:2:end) = 1;
mask3=zeros(rows,cols);
mask3(2:2:end,2:2:end) = 1;

im_rgb=reshape([im.*mask1 im.*mask2 im.*mask3],[size(im) 3]);
imshow(im_rgb);

%%

f=[1 2 1]/4;
imgr=conv2(f,f,im.*mask1,'same');

imshow(img);


mean(mean(im));
mean(mean(img));
%ANSWER: The means are different since the img image is darker then im. 

imgr=conv2(f,f,im.*mask1,'same')./conv2(f,f,mask1,'same');
mean(mean(im));
mean(mean(img));
%ANSWER: Now we have normalized the filter. Since the mask has values lower
%the 1 dividing by it will increase the power in the image

imgg=conv2(f,f,im.*mask2,'same')./conv2(f,f,mask2,'same');
imgb=conv2(f,f,im.*mask3,'same')./conv2(f,f,mask3,'same');

im_rgb=reshape([imgr imgg imgb],[size(im) 3]);

imshow(im_rgb);

%ANSWER: There's chromatic aberration

%%

im = imread('bayer/raw0010.png');

rgb = raw2rgb(im);

imshow(rgb);

%% Noise measurments

fpath='bayer/';

im=cell(100,1);
for k=1:100,
fname=sprintf('raw%04d.png',k);
im{k}=imread([fpath fname]);
end

%figure(7)
%for k=1:100,
%imshow(raw2rgb(im{k}));
%axis([871 980 401 480]);
%drawnow;
%end


im_temp=zeros(rows,cols);
for k=1:100,
im_temp = im_temp + im2double(im{k});
end
imm = im_temp./100;
rgb_avr=raw2rgb(imm);

%%

imtemp = imread('bayer/raw0010.png');
imtemp = im2double(imtemp);
imtemp = raw2rgb(imtemp);

figure(8)
subplot(2, 1, 1)
imshow(rgb_avr); 
subplot(2, 1, 2)
imshow(imtemp); 

%%

im_temp=zeros(rows,cols);
imva=zeros(rows,cols);
for k=1:100,
imva=imva + im2double(im{k}).^2;
end



imv=imva/100-imm.*imm;

imvrgb=raw2rgb(imv);

imshow(imvrgb*10000);

%ANSWEAR: highest absoul


%% SNR

%ANSWER: N = imv, S = imva/100

imshow(10000*imv*100./imva);




%%

indim=uint8(imm*255);
rhist=zeros(256,1);
ghist=zeros(256,1);
bhist=zeros(256,1);
for k=0:255,
k;
redk=find(mask1);
indk=redk(find(indim(redk)==k));
rhist(k+1)=sum(imv(indk))/(length(indk)+eps);
greenk=find(mask2);
indk=greenk(find(indim(greenk)==k));
ghist(k+1)=sum(imv(indk))/(length(indk)+eps);
bluek=find(mask3);
indk=bluek(find(indim(bluek)==k));
bhist(k+1)=sum(imv(indk))/(length(indk)+eps);
end


plot([0:255],[bhist ghist rhist]*255^2)
axis([0 255 0 10])
grid on
