function f = backproject(q, rVec, phiVec, xVec, yVec, intpol)

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
    end
  case 'linear'
    % your code here
  otherwise
    error('Unknown interpolation.');
end

f = f * pi / (Nphi*deltaR);
