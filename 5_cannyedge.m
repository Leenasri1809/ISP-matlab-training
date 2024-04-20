clc;
clear all;
close all;

I2 = imread('SAN5.jfif');
figure(1),imshow(I2)
I = double(I2);
%% Determine Mask Size
sigma = 1;
w = mask_size(sigma);
%% Gaussian Smoothing Filter
[ G,sum ] = gauss_mask(w,sigma);
%% Convolve
I1 = (1/sum) * image_convolution(I,w,G);
figure(2),imshow(I1);
%% Ix(derivative in x-direction)
Ix= delx(I1);
figure(3),imshow(Ix);
%% Iy(derivative in y-direction)
Iy= dely(I1);
figure(4),imshow(Iy);
%% Gradient Magnitude
If = grad_mag(Ix,Iy);
figure(5),imshow(If);
%% Non-maxmimum suppression
It = suppression(If,abs(Ix),abs(Iy));
figure(6),imshow(It);
figure,imshowpair(I2,It,'montage');