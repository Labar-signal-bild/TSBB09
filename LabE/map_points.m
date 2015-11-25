function [ x2 ] = map_(H, x1)


x1_hom = [x1;ones(1,size(x1,2))];
x2_hom = H*x1_hom;
x2= [x2_hom(1,:)./x2_hom(3,:); x2_hom(2,:)./x2_hom(3,:)];

end

