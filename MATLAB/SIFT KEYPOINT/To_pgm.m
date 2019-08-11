X = imread('18.jpg');
imwrite(X,'18.pgm');
 [image, descrips, locs] = sift('18.pgm');
 showkeys(image, locs);