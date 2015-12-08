function [ P ] = unit_points(p)
phi = atan(p(2,:));
theta = atan(p(1,:));

P = zeros(3,length(p));
P(1,:) = cos(phi).*sin(theta);
P(2,:) = sin(phi);
P(3,:) = cos(phi).*cos(theta);

end

