%%%
% GEOMETRY SETUP
%%%

Nx = 64; 				% number of grid points in x
Ny = 64; 				% number of grid points in y
Nr = 100; 				% number of detector elements
Nphi = 100;				% number of projection angles

xLen = 2.0; 				% side of reconstructed rectangle
yLen = 2.0; 				% side of reconstructed rectangle
phiLen = pi; 				% angular interval
rLen = xLen * 1.5; 			% length of detector

phiVec = (0 : Nphi - 1) * phiLen / Nphi;
rVec = (0.5 : Nr - 0.5) * rLen / Nr - rLen / 2;
xVec = (0.5 : Nx - 0.5) * xLen / Nx - xLen / 2;
yVec = (0.5 : Ny - 0.5) * yLen / Ny - yLen / 2;

%%%
% PHANTOM DEFINITION
%%%

E = [ 0.0  -0.2  0.6  1.0; ...     
      0.5  0.55  0.3  1.0; ...
     -0.5  0.55  0.3  1.0];

phm = pixelize(E, xVec, yVec);
subplot(2,2,1); imagesc(yVec, xVec, phm); title('Phantom');
axis xy; axis image; colorbar; colormap gray; pause(0);

%%%
% SINOGRAM GENERATION
%%%

p = generateProj(E, rVec, phiVec, 5);
subplot(2,2,2); imagesc(phiVec, rVec, p); title('Sinogram');
xlabel('\phi'); ylabel('r'); axis xy; colorbar; pause(0);

%%%
% RECONSTRUCTION
%%%

q = rampfilter(p, rVec, 'signal');
subplot(2,2,3); imagesc(phiVec, rVec, q);
axis xy; colorbar; title('Rampfiltered sinogram'); pause(0);

f = backproject(q, rVec, phiVec, xVec, yVec, 'nearest');
subplot(2,2,4); imagesc(yVec, xVec, f);
axis xy; axis image;  colorbar; title('Reconstructed image'); pause(0);
