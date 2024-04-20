clc;
clear all;
close all;
I = imread('RGB image.jpg');
      J = rgb2gray(I);
      P= 0.02;
      x = rand(size(J));
      d = find(x < P/2);
      J(d) = 0; % Minimum value
      figure,imshow(J)
      K = rgb2gray(I);
      e = find(x >= P/2 & x < P);
      K(e) = 255; % Maximum (saturated) value
      figure,imshow(K);
      figure,imshowpair(I,J,'montage');
      figure,imshowpair(I,K,'montage');
      J = rgb2gray(I);
      P= 0.02;
      x = rand(size(J));
      d = find(x < P/2);
      J(d) = 0; 
      d = find(x >= P/2 & x < P);
      J(d) = 255;
      figure,imshowpair(I,J,'montage');
