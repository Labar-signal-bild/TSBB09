Nr = 192; 				% number of detector elements
rLen = xLen * 1.5; 			% length of detector

rVec = (0.5:Nr-0.5) * rLen/Nr - rLen/2; % r-axis

p = ones(Nr);

domain = 'fourier2';
q = rampfilter(p, rVec, domain);


