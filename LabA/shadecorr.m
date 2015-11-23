function [f] = shadecorr(bA, bB, b)
%SHADECORR Summary of this function goes here
%   Detailed explanation goes here

fA = mean(mean(bA));
fB = mean(mean(bB));

c  = (fB-fA)./(bB-bA);
d  = (fA.*bB-fB.*bA)./(fB-fA);

f = c.*(b+d);


end

