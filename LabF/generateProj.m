function p = generateProj(E, rVec, phiVec, oversampling)

Nr = length(rVec) * oversampling;
rLen = (rVec(2) - rVec(1)) / oversampling * Nr;
rVec = (0.5 : Nr - 0.5) * rLen / Nr - rLen / 2;

x0 = E(:, 1);
y0 = E(:, 2);
a = E(:, 3);
dens = E(:, 4);

p = zeros(length(rVec), length(phiVec));

for phiIx = 1:length(phiVec)
  phi = phiVec(phiIx);
  for i = 1:length(x0)    
    aSqr = a.^2;
    r1Sqr = (rVec' - x0(i) * cos(phi) - y0(i) * sin(phi)).^2;
    ind = find(aSqr(i) > r1Sqr);   
    p(ind, phiIx) = p(ind, phiIx) + 2*dens(i)*sqrt(aSqr(i) - r1Sqr(ind));
  end
end

p = conv2(p, ones(oversampling, 1) / oversampling, 'same');
p = p(round(oversampling/2):oversampling:end, :);
