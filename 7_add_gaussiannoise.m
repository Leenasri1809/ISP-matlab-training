clc;
clear all;
close all;
S = 50;
I = imread('RGB image.jpg');
I = rgb2gray(I);
J = double(I) + S.*randn(size(I));
figure;
imshow(J)
title('Original Image')
K = J./1;
figure,imshow(K);
title('Additive Gaussian Noise')
figure,imshowpair(I,K,'montage');

%Design the Gaussian Kernel
%Standard Deviation
sigma = 2.454;
%Window size
sz = 1;
[x,y]=meshgrid(-sz:sz,-sz:sz);

M = size(x,1)-1;
N = size(y,1)-1;
Exp_comp = -(x.^2+y.^2)/(2*sigma*sigma);
Kernel= exp(Exp_comp)/(2*pi*sigma*sigma);
%Initialize
Output=zeros(size(K));
%Pad the vector with zeros
I = padarray(K,[sz sz]);

%Convolution
for i = 1:size(K,1)-M
    for j =1:size(K,2)-N
        Temp = K(i:i+M,j:j+M).*Kernel;
        Output(i,j)=sum(Temp(:));
    end
end
%Image without Noise after Gaussian blur
Output = uint8(Output);
figure,imshowpair(K, Output, 'montage');