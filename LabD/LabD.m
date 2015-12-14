%% LabD Stereo Images Dinosaurie Lab
addpath /site/edu/bb/Bildsensorer/D-EpipolarGeometry/

%%

im1=imread('dinosaur0.png');
im2=imread('dinosaur5.png');
load('dino_Ps','P');
figure(1);imagesc(im1);
figure(2);imagesc(im2);
C1=P{1};       % The camera matrix corresponding to image 1
C2=P{6};       % The camera matrix corresponding to image 2

%%

n1 = null(C1);

F21 = liu_crossop(C2*n1)*C2*pinv(C1);

y1 = vgg_get_homg([409 29; 421 454; 92 313; 294 101; ... 
                   410 154; 610 354; 265 369; 391 454]');
y2 = vgg_get_homg([405 50; 349 468; 100 206; 301 83; ...
                   485 190; 645 479; 247 325; 315 454]');

%ANSWER: No calculations just common sence, acuracy about +-5^2 pixels 


%%

% Construct epipolar lines
l2=F21*y1;
l1=F21'*y2;
for ix=1:size(y1,2),
l1(:,ix)=-l1(:,ix)/norm(l1(1:2,ix))*sign(l1(3,ix));
l2(:,ix)=-l2(:,ix)/norm(l2(1:2,ix))*sign(l2(3,ix));
end

% Plot the lines and the points
for ix=1:size(y1,2),
figure(1);hold('on');plot(y1(1,ix),y1(2,ix),'or');hold('off');
figure(1);hold('on');drawline(l1(:,ix));hold('off');
figure(2);hold('on');plot(y2(1,ix),y2(2,ix),'or');hold('off');
figure(2);hold('on');drawline(l2(:,ix));hold('off');
end


% The two epipoles are e12 and e21.

e12 = C1*null(C2);
e21 = C2*null(C1);

e12_norm = e12./e12(3);
e21_norm = e21./e21(3);

% ANSWER: Cartesian coordinates: e12 = (7391,-1377)
%                                e21 = (-6417,-988)
% The epipoles are in the image planes at coordinates as above, that means
% they are outside the image.

% All the epipolar lines intersect with there corresponding point
% The lines look parallel but if they are also intersecting the epipoles
% they are not completly parallel. Does the epipoles lay on the lines?
% Check:

% e12'*l1 =    1.0e-14 *

%    0.4441    0.5329    0.4441    0.3553    0.4441

% e121'*l2 = 1.0e-15 *

%         0   -0.4441         0         0   -0.4441

% These are all almost zero, so we say that, YES they lay on the lines,
% hence the lines are not completely parallel


mean(abs(sum(y1.*l1)))
mean(abs(sum(y2.*l2)))

% ANSER: % The mean of the sums above are cirka 0.57
% REDOVISAT HIT!!!

%% 4.2 The Loop and Zhang method

w=720;h=576; % Image width and height
lambda = -2:0.01:0; %Replace with the interval you choose
dist = LoopZhangDistortion(e12,e21,w,h,lambda);
figure(1);plot(lambda,dist);
figure(2);plot(lambda(2:end),diff(dist));
lambda(dist==min(dist)) %Print minimum lambda

% ANSWER: Varify in image that minimum lambda is -1.25

%%

lambda = -1.25;    % Insert your value here
w1=liu_crossop(e12)*[lambda 1 0]';
w1=w1/w1(3);
w2=F21*[lambda 1 0]';
w2=w2/w2(3);
Hp1=[1 0 0;0 1 0;w1'];
Hp2=[1 0 0;0 1 0;w2'];

vcp=0;
Hr1=[F21(3,2)-w1(2)*F21(3,3) w1(1)*F21(3,3)-F21(3,1) 0;
F21(3,1)-w1(1)*F21(3,3) F21(3,2)-w1(2)*F21(3,3) F21(3,3)+vcp;
0 0 1];
Hr2=[w2(2)*F21(3,3)-F21(2,3) F21(1,3)-w2(1)*F21(3,3) 0;
w2(1)*F21(3,3)-F21(1,3) w2(2)*F21(3,3)-F21(2,3) vcp;
0 0 1];

R = [-1 0 0;
    0 -1 0;
    0 0 1];

H1 = R*Hr1*Hp1;
H2 = R*Hr2*Hp2;


Fstreck = [0 0 0;
    0 0 -1;
    0 1 0];

H2'*Fstreck*H1
F21

% ANSWER: Varifying that H1 and H2 are correct by the relation
% H2'*Fstreck*H1 = F21. This match OK. 

%% 4.3 Rectifying the images 

oldcorners=[1 w w 1;1 1 h h];
newcorners1=map_points(H1,oldcorners);
newcorners2=map_points(H2,oldcorners);
mincol=min([newcorners1(1,:) newcorners2(1,:)]);
minrow=min([newcorners1(2,:) newcorners2(2,:)]);
T=[1 0 -mincol+1;0 1 -minrow+1;0 0 1]
newcorners1=map_points(T*H1,oldcorners);
newcorners2=map_points(T*H2,oldcorners);
maxcol=max([newcorners1(1,:) newcorners2(1,:)]);
maxrow=max([newcorners1(2,:) newcorners2(2,:)]);
T=inv(diag([maxcol/w maxrow/h 1]))*T


% ANSWER: T is a scalar matrix: The diagonal is not all 1
%         T is a translation matrix: The rightest column is non-zero


%%

imr1=image_resample(double(im1),T*H1,h,w);
figure(3);imagesc(uint8(imr1));
imr2=image_resample(double(im2),T*H2,h,w);
figure(4);imagesc(uint8(imr2));

y1r = vgg_get_homg(map_points(T*H2,y2(1:2,:)))
y2r = vgg_get_homg(map_points(T*H1,y1(1:2,:)))



for ix=1:size(y1r,2),
figure(3);hold('on');plot(y1r(1,ix),y1r(2,ix),'or');hold('off');

figure(4);hold('on');plot(y2r(1,ix),y2r(2,ix),'or');hold('off');
end




% map_points(T*H2,y2(1:2,:))
% map_points(T*H1,y1(1:2,:)) Varifying that these are on the same line


%% 5  The fundamental matrix and the 8-point algorithm

y1 = vgg_get_homg([409 29; 421 454; 92 313; 294 101; ... 
                   410 154; 610 354; 265 369; 391 454]');
y2 = vgg_get_homg([405 50; 349 468; 100 206; 301 83; ...
                   485 190; 645 479; 247 325; 315 454]');
               
nn8pa

figure(1);imagesc(im1);
figure(2);imagesc(im2);
l2=F*y1;
l1=F'*y2;
for ix=1:length(y1),
l1(:,ix)=-l1(:,ix)/norm(l1(1:2,ix))*sign(l1(3,ix)); %Normalise dual
l2(:,ix)=-l2(:,ix)/norm(l2(1:2,ix))*sign(l2(3,ix)); %homog. coord.
end

for ix=1:size(y1,2),
figure(1);hold('on');plot(y1(1,ix),y1(2,ix),'or');hold('off');
figure(1);hold('on');drawline(l1(:,ix));hold('off');
figure(2);hold('on');plot(y2(1,ix),y2(2,ix),'or');hold('off');
figure(2);hold('on');drawline(l2(:,ix));hold('off');
end
mean(abs(sum(y1.*l1)))
mean(abs(sum(y2.*l2)))

% ANSWEAR: This can be compared by measuring how well each point lines on
% each epipolar line. 
% ANSWEAR: We get slightly better results from F compared to F21. Also
% since the camera matrix dosn't need to be known F is better.

%% 6 Triangulation

load('tridata','x','y1','y2','im1','im2','C1','C2');

figure(1);imagesc(im1);hold('on');
for ix=1:length(y1),
plot(y1(2,ix),y1(1,ix),'ro');
end
hold('off');
figure(2);imagesc(im2);hold('on');
for ix=1:length(y2),
plot(y2(2,ix),y2(1,ix),'ro');
end
hold('off');



%%

xrec=[];
for ix=1:length(y1),
B1 = liu_crossop(y1(:,ix))*C1;
B2 = liu_crossop(y2(:,ix))*C2;

B = [B1; B2];
[U D V] = svd(B);

x_calc = V(:,4)/V(4,4);

xrec=[xrec x_calc];
end

figure(3);plot3(xrec(1,:),xrec(2,:),xrec(3,:),'o');


x_mean=mean(mean((x-xrec)'))

x_std=std((x-xrec)')

%%

y1_new = C1*xrec;
y1_new = [y1_new(1,:)./y1_new(3,:); y1_new(2,:)./y1_new(3,:); y1_new(3,:)./y1_new(3,:)];


y2_new = C2*xrec;
y2_new = [y2_new(1,:)./y2_new(3,:); y2_new(2,:)./y2_new(3,:); y2_new(3,:)./y2_new(3,:)];

y1_mean=mean(mean((y1-y1_new)'));
y1_std= std((y1-y1_new)');

y2_mean=mean(mean((y2-y2_new)'));
y2_std=std((y2-y2_new)');