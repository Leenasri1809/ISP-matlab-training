clc;
clear all;
close all;
a = 0.02;
b = 1;
I = imread('RGB image.jpg');
J = im2gray(I);
[M N ~] = size(J);
k=-1/a;
R=k*log(1-rand(M,N));
X = imadd(double(J),double(R));
figure,imshowpair(I,X,'montage');
title("EXPONENTIAL");
R=a+(-b*log(1-rand(M,N))).^.5;
X = imadd(double(J),double(R));
figure,imshowpair(I,X,'montage');
title("RAYLEIGH");
k=-1/a;
R=zeros(M,N);
for j=1:b
    R=R+k*log(1-rand(M,N));
end
X = imadd(double(J),double(R));
figure,imshowpair(I,X,'montage');
title("ERLANG");


