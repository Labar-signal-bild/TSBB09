
function  [A, R, t] = CameraCalibration(Xplane, XImg, planeNo)
% Camera calibration. Returns intrinsic matrix A for the camera and 
% extrinsic parameters [R,t]. Four sets of corresponding points
% from four different calibration images are used.
% XImg: Coordinates of the points in the image.
% XPlane: Coordinates of the points in the world.
% planeNo: Number of the plane that defines the coordinate system
%
% The extrinsic parameters are given in relation to the first image.
%
% Programmed 2004 by a project group supervised by 
% Per-Erik Forsse'n.
% Modified 2004-10-06 and 2007-10-10 by Maria Magnusson. 
% Modified 2015-11-05 by Maria Magnusson (just comments). 

% read number of planes
%----------------------
siz = size(Xplane);
noPlanes = siz(2)

% load corresponding points in all 4 images and estimate homographies
%--------------------------------------------------------------------
for i = 1:noPlanes
  uv = XImg{i};  ui = uv(:,1);  vi = uv(:,2);
  XY = Xplane{i};  Xi = XY(:,1);  Yi = XY(:,2);
  c = generate_homog(ui,vi,Xi,Yi);
  Cbig(:,:,i) = [c(1:3)'; c(4:6)'; c(7:8)',1];
end

% Compute intrinsic parameters.
%------------------------------
Hbig = Cbig;
A = homography2intrinsic(Hbig);

% Compute extrinsic parameters. The extrinsic parameters 
% are given in relation to planeNo.
%-------------------------------------------------------
H = Hbig(:,:,planeNo);
h1 = H(:,1);
h2 = H(:,2);
h3 = H(:,3);
invA = inv(A);
lambda=1/norm(invA*h1);

r1=lambda*invA*h1;
r2=lambda*invA*h2;
r3=cross(r1,r2);
t=lambda*invA*h3;
R=[r1,r2,r3];
