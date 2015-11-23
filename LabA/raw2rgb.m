function [ rgb ] = raw2rgb(raw)

im = im2double(raw);
 
[rows,cols] = size(im);

mask1=zeros(rows,cols);
mask1(2:2:end,2:2:end) = 1;
mask2=zeros(rows,cols);
mask2(1:2:end,2:2:end) = 1;
mask2(2:2:end,1:2:end) = 1;
mask3=zeros(rows,cols);
mask3(1:2:end,1:2:end) = 1;


f=[1 2 1]/4;

imgr=conv2(f,f,im.*mask1,'same')./conv2(f,f,mask1,'same');
imgg=conv2(f,f,im.*mask2,'same')./conv2(f,f,mask2,'same');
imgb=conv2(f,f,im.*mask3,'same')./conv2(f,f,mask3,'same');

rgb=reshape([imgr imgg imgb],[size(im) 3]);



end

