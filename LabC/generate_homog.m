
function c = generate_homog(ui,vi,Xi,Yi)
% function c = generate_homog(ui,vi,Xi,Yi)
% Generates a homography, i.e. determines the matrix 
% relating a plane and its image.
% (ui,vi): Coordinates of the points in the image.
% (Xi,Yi): Coordinates of the points in the world.
%
% Programmed 2004 by a project group supervised by 
% Per-Erik Forsse'n.
% Modified 2004-10-06 by Maria Magnusson Seger. 

n = length(ui);

% Set up the calibration matrix
%------------------------------
D=[Xi(1),Yi(1),1,     0,    0,0,-ui(1)*Xi(1),-ui(1)*Yi(1);
       0,    0,0, Xi(1),Yi(1),1,-vi(1)*Xi(1),-vi(1)*Yi(1)];

for i=2:n
  D=[D;
     Xi(i),Yi(i),1,0,    0,    0,-ui(i)*Xi(i),-ui(i)*Yi(i);
         0,    0,0,Xi(i),Yi(i),1,-vi(i)*Xi(i),-vi(i)*Yi(i)];
end

f=[ui(1);
   vi(1)];
for i=2:n
  f=[f;
     ui(i);
     vi(i)];
end

c = pinv(D)*f;
c = [c;
     1];




