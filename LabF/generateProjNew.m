function p = generateProjNew(E, rVec, phiVec, oversampling,flag)

if flag == 1
    density = 7;
else
    density = 6;
end

Nr = length(rVec) * oversampling;
rLen = (rVec(2) - rVec(1)) / oversampling * Nr;
rVec = (0.5 : Nr - 0.5) * rLen / Nr - rLen / 2;

x0 = E(:, 1);
y0 = E(:, 2);
a = E(:, 3);

b = E(:, 4);
alpha = E(:, 5);

dens = E(:, density);

p = zeros(length(rVec), length(phiVec));

for phiIx = 1:length(phiVec)
  phi = phiVec(phiIx);
  for i = 1:length(x0)    
    aSqr = a.^2;
    bSqr = b.^2;
    r0Sqr = aSqr(i)*cos(phi - alpha(i)).^2 + bSqr(i)*sin(phi - alpha(i)).^2;
    r1Sqr = (rVec' - x0(i) * cos(phi) - y0(i) * sin(phi)).^2;
    ind = find(r0Sqr > r1Sqr);   
    p(ind, phiIx) = p(ind, phiIx) + dens(i)*(2*a(i)*b(i)*sqrt(r0Sqr - r1Sqr(ind))) / r0Sqr;
  end
end

p = conv2(p, ones(oversampling, 1) / oversampling, 'same');
p = p(round(oversampling/2):oversampling:end, :);

