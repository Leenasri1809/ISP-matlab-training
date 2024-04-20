clc;
clear all;
close all;
input_image = imread('PEN.png');
[M, N] = size(input_image); 
FT_img = fft2(double(input_image));
D0 = 10; 
u = 0:(M-1);
idx = find(u>M/2);
u(idx) = u(idx)-M;
v = 0:(N-1);
idy = find(v>N/2);
v(idy) = v(idy)-N;
[V, U] = meshgrid(v, u);
D = sqrt(U.^2+V.^2);
H = double(D > D0);
G = H.*FT_img;
output_image = real(ifft2(double(G)));
  
% Displaying Input Image and Output Image
imshowpair(input_image, output_image, 'montage');