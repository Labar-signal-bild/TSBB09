function phm = pixelizeNew(E, xVec, yVec, flag);

[xGrid, yGrid] = meshgrid(xVec, yVec);
phm = zeros(size(xGrid));

if flag == 0
    densnumber = 6;
else
    densnumber = 7;
end

for i = 1 : size(E, 1)        
   x0 = E(i, 1);          % x offset
   y0 = E(i, 2);          % y offset
   a = E(i, 3);           % radius
   b = E(i,4);
   alpha =E(i,5);
   dens = E(i, densnumber);        % density      
   x = xGrid - x0;
   y = yGrid - y0;
   
   elipsRadius = ((y.*cos(alpha) -x.*sin(alpha))./b).^2+((cos(alpha).*x+sin(alpha).*y)./a).^2;
   idx = find(elipsRadius <= 1); 
   phm(idx) = phm(idx) + dens;
end