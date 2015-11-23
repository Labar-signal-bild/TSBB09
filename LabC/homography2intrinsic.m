function A=homography2intrinsic(Hbig)
% The intrinsic matrix A is calculated from n homographies.
% Hbig is a 3x3xn matrix of homographies. This file is used by
% calib_zhang_simple, and is based on Zhang's calibration 
% technique (see calib_zhang_simple.m)
%
% Assumes the homogeneous coordinate is at the end (i.e. [x y 1])
%
% Programmed 2004 by a project group supervised by 
% Per-Erik Forsse'n.
% Modified 2004-10-06 by Maria Magnusson Seger. 
  
% Compute constraints for each homography 
%----------------------------------------  
  for n=1:size(Hbig,3)
    H=Hbig(:,:,n)';
    v11=[H(1,1)*H(1,1), H(1,1)*H(1,2)+H(1,2)*H(1,1), H(1,2)*H(1,2), ...
	 H(1,3)*H(1,1)+H(1,1)*H(1,3), H(1,3)*H(1,2)+H(1,2)*H(1,3), ...
	 H(1,3)*H(1,3)]';
    
    v12=[H(1,1)*H(2,1), H(1,1)*H(2,2)+H(1,2)*H(2,1), H(1,2)*H(2,2), ...
	 H(1,3)*H(2,1)+H(1,1)*H(2,3), H(1,3)*H(2,2)+H(1,2)*H(2,3), ...
	 H(1,3)*H(2,3)]';
    
    v22=[H(2,1)*H(2,1), H(2,1)*H(2,2)+H(2,2)*H(2,1), H(2,2)*H(2,2), ...
	 H(2,3)*H(2,1)+H(2,1)*H(2,3), H(2,3)*H(2,2)+H(2,2)*H(2,3), ...
	 H(2,3)*H(2,3)]';

    V(n*2-1,:) = v12';
    V(n*2,:)   = (v11-v22)';
  end
  
  % Solve Vb=0
  %-----------
  [U,S,V1] = svd(V);
  b = V1(:,6);
  
  % Arrange b to form B
  %--------------------
  B=[b(1),b(2),b(4);b(2),b(3),b(5);b(4),b(5),b(6)];

  % Extract the intrinsic parameters from B
  %----------------------------------------
  v0=(B(1,2)*B(1,3)-B(1,1)*B(2,3))/(B(1,1)*B(2,2)-B(1,2)*B(1,2));
  lambda=B(3,3)-(B(1,3)*B(1,3)+v0*(B(1,2)*B(1,3)-B(1,1)*B(2,3)))/B(1,1);
  alpha=sqrt(lambda/B(1,1));
  beta=sqrt(lambda*B(1,1)/(B(1,1)*B(2,2)-B(1,2)*B(1,2)));
  gamma=-B(1,2)*alpha*alpha*beta/lambda;
  u0=(gamma*v0/alpha)-(B(1,3)*alpha*alpha/lambda);
  
  % arrange the extracted data to form A
  %-------------------------------------
  A=[alpha,gamma,u0;
     0,    beta, v0;
     0,    0,    1];

