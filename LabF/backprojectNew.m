function [f M] = backprojectNew(q, rVec, phiVec, xVec, yVec, intpol)

close all

[xGrid, yGrid] = meshgrid(xVec, yVec);
f = zeros(size(xGrid));
Nr = length(rVec);
Nphi = length(phiVec);
deltaR = rVec(2) - rVec(1);



switch intpol
  case 'nearest'
    for phiIx = 1:Nphi
      phi = phiVec(phiIx);
      proj = q(:, phiIx); 
      r = xGrid * cos(phi) + yGrid * sin(phi);
      rIx = round(r / deltaR + (Nr + 1) / 2);
      f = f + proj(rIx);
      
      figure(5)
      imagesc(yVec, xVec, f);
      axis xy; axis image;
      colormap('gray');
      M(phiIx) = getframe;
      
    end
  case 'linear'
      for phiIx = 1:Nphi
          phi = phiVec(phiIx);
          proj = q(:, phiIx); 
          r = xGrid * cos(phi) + yGrid * sin(phi);
          
          rIx = r / deltaR + (Nr + 1) / 2;
          rIxlow = floor(rIx);
          rIxhigh = rIxlow + 1;
    
          w2 = rIx - rIxlow;
          w1 = 1-w2;
    
          f = f + w1.*proj(rIxlow) + w2.*proj(rIxhigh);
          
          figure(5)
          imagesc(yVec, xVec, f);
          axis xy; axis image;
          colormap('gray');
          M(phiIx) = getframe;
      end
  otherwise
    error('Unknown interpolation.');
end

f = f * pi / (Nphi*deltaR);
