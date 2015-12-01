%% Lab F Tomographic image reconstruction

fbp

% How wide is the detector used in this experiment? 3
% Over what angular interval are the projections taken? 180 grader
% Tex 90 grader är scxanning i horisontellt led

% Home exercise 1: The X-ray detectar detect a sine that makes a sinogram,
% a set of line integrals is a sinogram
%% 1.3 Filtered backprojection

% ANSWER: The reconstuction values are about 0.15 wrong
% ANSWER: The rampfilter is needed to compensate for the higher intensity
% in the middle of the backprojected image. When not useing a rampfilter
% their will be a lot of values in the middle of the dot and it will become
% a "vulcano"

% When the angular interval is reduced the reconstructed image isn't
% backporjected for all angles that's neeeded.

% When incresing the number of angular projections the image is getting
% better but after about 500 it didn't get better. When reducing the number
% of angular projections the image get more pixely.

% Home exercise 2: pi*N <= M

% ANSWEAR: If N>M we get lines through the image. Why can we disrecard pi?

%% 2.1 Pixelization

% Home excersise 3 (((y-y0)cos(alpha) -
% (x-x0)sin(alpha))/b)^2+(((cos(alpha)(x-x0)+sin(alpha(y-y0))/a)^2<=1

fbpNew

% ANSWEAR: 0.2-0.5 soft tissue density
% 1-1.03 for low contrast

% When ploting the reconstructed image with oversample 5 and 1 the
% difference is that the one with low oversampling is more pixely then the
% other. The reason for this is that we don't get as many values. 

%% 3 Backprojection

















